// File: pages/api/pitchdeck/speech-to-text.ts
import { NextApiRequest, NextApiResponse } from 'next';
import { getServerSession } from 'next-auth/next';
import formidable from 'formidable';
import fs from 'fs';

import { authOptions } from '@/pages/api/auth/[...nextauth]';
import { ratelimit } from '@/lib/redis';
import { log } from '@/lib/utils';

// Configure Next.js to handle file uploads
export const config = {
  api: {
    bodyParser: false,
  },
};

if (!process.env.ELEVENLABS_API_KEY) {
  log({
    message: "ELEVENLABS_API_KEY is not configured for /api/pitchdeck/speech-to-text",
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

  // Apply rate limiting (5 requests per minute per IP)
  try {
    // Use req.socket.remoteAddress as fallback for NextApiRequest
    const ip = req.headers['x-forwarded-for'] as string || 
               req.socket.remoteAddress || 
               '127.0.0.1';
               
    const { success } = await ratelimit(5, "1 m").limit(
      `pitchdeck-stt:${ip}`
    );

    if (!success) {
      return res.status(429).json({ message: "Too many requests for speech-to-text. Please try again later." });
    }
  } catch (e) {
    log({ message: `Rate limiting error for speech-to-text: ${(e as Error).message}`, type: "error" });
  }

  try {
    // Parse the incoming form data
    const form = formidable({});
    const [fields, files] = await form.parse(req);
    
    if (!files.audio || !files.audio[0]) {
      return res.status(400).json({ message: 'No audio file provided.' });
    }
    
    const audioFile = files.audio[0];
    
    // Read the file
    const fileBuffer = fs.readFileSync(audioFile.filepath);
    
    // Create form data for ElevenLabs API
    const formData = new FormData();
    formData.append('file', new Blob([fileBuffer]), audioFile.originalFilename || 'audio.webm');
    formData.append('model_id', 'scribe_v1'); // Using the correct model ID for ElevenLabs
    
    log({ message: `Requesting speech-to-text for audio file`, type: "info" });

    // Send to ElevenLabs API
    const response = await fetch('https://api.elevenlabs.io/v1/speech-to-text', {
      method: 'POST',
      headers: {
        'xi-api-key': process.env.ELEVENLABS_API_KEY as string
      },
      body: formData
    });

    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(`ElevenLabs API error: ${JSON.stringify(errorData)}`);
    }

    const data = await response.json();
    
    return res.status(200).json({ 
      text: data.text,
      language_code: data.language_code,
      language_probability: data.language_probability
    });

  } catch (error) {
    log({
      message: `Error in /api/pitchdeck/speech-to-text: ${(error as Error).message}`,
      type: "error",
      mention: true,
    });
    console.error("ElevenLabs API Error:", error);
    return res.status(500).json({ message: 'Failed to convert speech to text.' });
  }
}