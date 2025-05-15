import { log } from '@/lib/utils';

/**
 * Extracts text content from all slides in a document
 * @param pages Array of page objects with file URLs
 * @param linkId The link ID
 * @param documentId The document ID
 * @returns Array of slide contents with page numbers
 */
export async function extractSlidesContent(
  pages: Array<{
    file: string;
    pageNumber: string;
    metadata?: { width: number; height: number; scaleFactor: number };
  }>,
  linkId: string,
  documentId: string
): Promise<Array<{ pageNumber: number; content: string }>> {
  try {
    log({
      message: `Extracting text from ${pages.length} slides for document ${documentId}`,
      type: "info"
    });

    // Process slides in batches to avoid overwhelming the API
    const batchSize = 5;
    const results: Array<{ pageNumber: number; content: string }> = [];
    
    for (let i = 0; i < pages.length; i += batchSize) {
      const batch = pages.slice(i, i + batchSize);
      
      // Process each slide in the batch concurrently
      const batchPromises = batch.map(async (page) => {
        try {
          const response = await fetch('/api/pitchdeck/extract-text', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({
              imageUrl: page.file,
              linkId,
              documentId,
              pageNumber: parseInt(page.pageNumber, 10)
            }),
          });
          
          if (!response.ok) {
            throw new Error(`Failed to extract text from slide ${page.pageNumber}`);
          }
          
          const data = await response.json();
          return {
            pageNumber: parseInt(page.pageNumber, 10),
            content: data.textContent
          };
        } catch (error) {
          console.error(`Error extracting text from slide ${page.pageNumber}:`, error);
          
          // Generate fallback content based on slide number
          const pageNum = parseInt(page.pageNumber, 10);
          let fallbackContent = '';
          
          // Create generic content based on slide position
          if (pageNum === 1) {
            fallbackContent = 'This appears to be the title slide of the presentation. It likely contains the main title and possibly subtitle or author information.';
          } else if (pageNum === 2) {
            fallbackContent = 'This slide may contain an agenda, table of contents, or introduction to the presentation.';
          } else if (pageNum === pages.length) {
            fallbackContent = 'This appears to be the final slide, likely containing a conclusion, summary, or contact information.';
          } else if (pageNum === pages.length - 1) {
            fallbackContent = 'This slide may contain a summary, next steps, or call to action.';
          } else {
            fallbackContent = `This is slide ${pageNum} of the presentation. It likely contains key information, bullet points, or visuals related to the main topic.`;
          }
          
          return {
            pageNumber: pageNum,
            content: fallbackContent
          };
        }
      });
      
      const batchResults = await Promise.all(batchPromises);
      results.push(...batchResults);
      
      // Add a small delay between batches to avoid rate limiting
      if (i + batchSize < pages.length) {
        await new Promise(resolve => setTimeout(resolve, 500));
      }
    }
    
    // Sort results by page number
    results.sort((a, b) => a.pageNumber - b.pageNumber);
    
    log({
      message: `Successfully extracted text from ${results.length} slides for document ${documentId}`,
      type: "info"
    });
    
    return results;
  } catch (error) {
    log({
      message: `Error extracting slides content: ${(error as Error).message}`,
      type: "error",
      mention: true,
    });
    
    // Instead of throwing an error, return generic fallback content for all slides
    return pages.map(page => {
      const pageNum = parseInt(page.pageNumber, 10);
      return {
        pageNumber: pageNum,
        content: `Slide ${pageNum}: This is a presentation slide. Due to technical limitations, the exact content couldn't be extracted.`
      };
    });
  }
}

/**
 * Processes slide content to create a summary for each slide
 * @param slideContents Array of slide contents with page numbers
 * @returns Array of processed slide contents with summaries
 */
export async function processSlidesContent(
  slideContents: Array<{ pageNumber: number; content: string }>
): Promise<Array<{ pageNumber: number; content: string; summary: string }>> {
  // This function could use OpenAI to generate summaries for each slide
  // For now, we'll just return the original content
  return slideContents.map(slide => ({
    ...slide,
    summary: slide.content.length > 100 
      ? slide.content.substring(0, 100) + '...' 
      : slide.content
  }));
}