// File: pages/api/pitchdeck/ask-question.ts
import { NextApiRequest, NextApiResponse } from 'next';
import { getServerSession } from 'next-auth/next';
import { OpenAI } from 'openai';

import { authOptions } from '@/pages/api/auth/[...nextauth]';
import { ratelimit } from '@/lib/redis';
import { log } from '@/lib/utils';

if (!process.env.OPENAI_API_KEY) {
  log({
    message: "OPENAI_API_KEY is not configured for /api/pitchdeck/ask-question",
    type: "error",
  });
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

  const { question, slideContents, currentSlideNumber, linkId, documentId } = req.body;

  if (!question || typeof question !== 'string') {
    return res.status(400).json({ message: 'question is required and must be a string.' });
  }

  if (!slideContents || !Array.isArray(slideContents)) {
    return res.status(400).json({ message: 'slideContents is required and must be an array.' });
  }

  // Apply rate limiting (5 requests per minute per IP)
  try {
    // Use req.socket.remoteAddress as fallback for NextApiRequest
    const ip = req.headers['x-forwarded-for'] as string || 
               req.socket.remoteAddress || 
               '127.0.0.1';
               
    const { success } = await ratelimit(5, "1 m").limit(
      `pitchdeck-ask:${ip}`
    );

    if (!success) {
      return res.status(429).json({ message: "Too many requests. Please try again later." });
    }
  } catch (e) {
    log({ message: `Rate limiting error for ask-question: ${(e as Error).message}`, type: "error" });
  }

  try {
    log({ 
      message: `Requesting answer for question: "${question}" on slide ${currentSlideNumber} of document ${documentId}`, 
      type: "info" 
    });

    // Create a context string from the slide contents
    const context = slideContents.map((slide: any, index: number) => 
      `Slide ${index + 1}: ${slide.content}`
    ).join('\n\n');

    // Create a system message that instructs the model how to respond
    const systemMessage = `
You are an AI assistant that helps explain a pitchdeck presentation.
You have access to the text content of all slides in the presentation.
The user is currently viewing slide ${currentSlideNumber}.

When answering questions:
1. Focus primarily on information from the current slide (${currentSlideNumber})
2. Reference information from other slides when relevant
3. Provide additional context and insights beyond what's explicitly stated in the slides
4. Clearly distinguish between information from the slides and your additional knowledge
5. Format your answers to separate slide content from additional context, for example:
   "According to the slides: [information from slides]
    Additional context: [your expanded explanation]"
6. If you don't know the answer, say so honestly
7. Be conversational but informative

Here is the content of all slides in the presentation:
${context}
`;

    const response = await openai.chat.completions.create({
      model: "gpt-4o", // Use the latest model
      messages: [
        { role: "system", content: systemMessage },
        { role: "user", content: question }
      ],
      max_tokens: 300, // Keep responses concise
      temperature: 0.7, // Slightly creative but mostly factual
    });

    const answer = response.choices[0]?.message?.content?.trim() || "I'm sorry, I couldn't generate an answer.";
    
    log({ 
      message: `Answer generated for question: "${question}": ${answer.substring(0, 100)}...`, 
      type: "info" 
    });

    return res.status(200).json({ answer });

  } catch (error) {
    log({
      message: `Error in /api/pitchdeck/ask-question: ${(error as Error).message}`,
      type: "error",
      mention: true,
    });
    console.error("OpenAI API Error:", error);
    return res.status(500).json({ message: 'Failed to answer question.' });
  }
}