// File: pages/api/pitchdeck/text-to-speech.ts
import { NextApiRequest, NextApiResponse } from 'next';
import { getServerSession } from 'next-auth/next';

import { authOptions } from '@/pages/api/auth/[...nextauth]';
import { ratelimit } from '@/lib/redis';
import { log } from '@/lib/utils';
import { ipAddress } from '@vercel/functions';
import { LOCALHOST_IP } from '@/lib/utils/geo';

if (!process.env.ELEVENLABS_API_KEY) {
  log({
    message: "ELEVENLABS_API_KEY is not configured for /api/pitchdeck/text-to-speech",
    type: "error",
  });
}

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse,
) {
  if (req.method !== 'POST') {
    res.setHeader('Allow', ['POST']);
    return res.status(405).end(`Method ${req.method} Not Allowed`);
  }

  // Optional: Add session validation if you want to restrict this endpoint
  // const session = await getServerSession(req, res, authOptions);
  // if (!session) {
  //   return res.status(401).json({ message: "Unauthorized" });
  // }

  const { text, voiceId = "21m00Tcm4TlvDq8ikWAM" } = req.body; // Default to "Rachel" voice

  if (!text || typeof text !== 'string') {
    return res.status(400).json({ message: 'text is required and must be a string.' });
  }

  // Apply rate limiting (5 requests per minute per IP)
  try {
    // Use req.socket.remoteAddress as fallback for NextApiRequest
    const ip = req.headers['x-forwarded-for'] as string ||
               req.socket.remoteAddress ||
               LOCALHOST_IP;
    const { success } = await ratelimit(5, "1 m").limit(
      `pitchdeck-tts:${ip}`
    );

    if (!success) {
      return res.status(429).json({ message: "Too many requests for text-to-speech. Please try again later." });
    }
  } catch (e) {
    log({ message: `Rate limiting error for text-to-speech: ${(e as Error).message}`, type: "error" });
  }

  try {
    log({ message: `Requesting text-to-speech for: "${text.substring(0, 50)}..."`, type: "info" });

    const response = await fetch('https://api.elevenlabs.io/v1/text-to-speech/' + voiceId, {
      method: 'POST',
      headers: {
        'Accept': 'audio/mpeg',
        'Content-Type': 'application/json',
        'xi-api-key': process.env.ELEVENLABS_API_KEY as string
      },
      body: JSON.stringify({
        text,
        model_id: "eleven_monolingual_v1",
        voice_settings: {
          stability: 0.5,
          similarity_boost: 0.75
        }
      })
    });

    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(`ElevenLabs API error: ${JSON.stringify(errorData)}`);
    }

    // Get the audio data as an ArrayBuffer
    const audioArrayBuffer = await response.arrayBuffer();
    
    // Convert to base64 for sending to the client
    const base64Audio = Buffer.from(audioArrayBuffer).toString('base64');
    
    return res.status(200).json({ 
      audioContent: base64Audio,
      contentType: 'audio/mpeg'
    });

  } catch (error) {
    log({
      message: `Error in /api/pitchdeck/text-to-speech: ${(error as Error).message}`,
      type: "error",
      mention: true,
    });
    console.error("ElevenLabs API Error:", error);
    return res.status(500).json({ message: 'Failed to convert text to speech.' });
  }
}