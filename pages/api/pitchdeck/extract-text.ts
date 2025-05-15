// File: pages/api/pitchdeck/extract-text.ts
import { NextApiRequest, NextApiResponse } from 'next';
import { getServerSession } from 'next-auth/next';
import { OpenAI } from 'openai';

import { authOptions } from '@/pages/api/auth/[...nextauth]'; // Adjust path
import { ratelimit } from '@/lib/redis'; // Adjust path
import { log } from '@/lib/utils'; // Adjust path
import { ipAddress } from '@vercel/functions';
import { LOCALHOST_IP } from '@/lib/utils/geo';


if (!process.env.OPENAI_API_KEY) {
  log({
    message: "OPENAI_API_KEY is not configured for /api/pitchdeck/extract-text",
    type: "error",
  });
  // Potentially throw an error here or handle it gracefully depending on your app's requirements
}

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

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

  const { imageUrl, linkId, documentId, pageNumber } = req.body;

  if (!imageUrl || typeof imageUrl !== 'string') {
    return res.status(400).json({ message: 'imageUrl is required and must be a string.' });
  }
   if (!linkId || !documentId || pageNumber === undefined) {
    // These are not strictly needed for GPT-4V but good for logging/context
    log({ message: "linkId, documentId, or pageNumber missing in extract-text request, but proceeding.", type: "info"});
  }


  // Apply rate limiting (example: 5 requests per minute per IP for this specific, potentially expensive, endpoint)
  try {
    // Use req.socket.remoteAddress as fallback for NextApiRequest
    const ip = req.headers['x-forwarded-for'] as string ||
               req.socket.remoteAddress ||
               LOCALHOST_IP;
    const { success } = await ratelimit(5, "1 m").limit(
      `pitchdeck-extract-text:${ip}`
    );

    if (!success) {
      return res.status(429).json({ message: "Too many requests for text extraction. Please try again later." });
    }
  } catch (e) {
    log({ message: `Rate limiting error for text extraction: ${(e as Error).message}`, type: "error" });
    // Decide if you want to fail open or closed on rate limiting error
  }

  try {
    log({ message: `Requesting text extraction for image: ${imageUrl} (Page: ${pageNumber}, Doc: ${documentId})`, type: "info" });

    const response = await openai.chat.completions.create({
      model: "gpt-4o", // Using the latest model with vision capabilities
      messages: [
        {
          role: "user",
          content: [
            { type: "text", text: "Extract all text content from this slide image and provide additional context and explanation. First, list the raw text content under 'SLIDE CONTENT:'. Then, provide a more detailed explanation and interpretation under 'EXPLANATION:'. Include insights about what this slide is trying to convey beyond the literal text. If there's no discernible text, say 'No text found' but still try to interpret any visual elements." },
            {
              type: "image_url",
              image_url: {
                "url": imageUrl,
                "detail": "high" // Using high detail to ensure we capture all relevant information
              },
            },
          ],
        },
      ],
      max_tokens: 1000, // Adjust as needed
    });

    const textContent = response.choices[0]?.message?.content?.trim() || "Could not extract text from image.";
    
    log({ message: `Text extracted for page ${pageNumber} of doc ${documentId}: ${textContent.substring(0,100)}...`, type: "info" });

    // Process the content to ensure it has both SLIDE CONTENT and EXPLANATION sections
    let processedContent = textContent;
    if (!textContent.includes("SLIDE CONTENT:") && !textContent.includes("EXPLANATION:")) {
      processedContent = `SLIDE CONTENT:\n${textContent}\n\nEXPLANATION:\nThis slide appears to contain important information for the presentation.`;
    }

    return res.status(200).json({ textContent: processedContent });

  } catch (error) {
    log({
      message: `Error in /api/pitchdeck/extract-text for ${imageUrl}: ${(error as Error).message}\n${(error as Error).stack}`,
      type: "error",
      mention: true,
    });
    console.error("OpenAI GPT-4V API Error:", error);
    return res.status(500).json({ message: 'Failed to extract text from image.' });
  }
}
