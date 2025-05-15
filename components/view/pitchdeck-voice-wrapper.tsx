import React, { useState, useEffect, useRef } from 'react';
import { extractSlidesContent } from '@/lib/pitchdeck/extract-slides';
import PitchdeckVoice from './pitchdeck-voice';
import VoiceToggleButton from './voice-toggle-button';
import PagesVerticalViewer from './viewer/pages-vertical-viewer';
import { TNavData } from './nav';
import { WatermarkConfig } from '@/lib/types';

// Custom hook to observe page changes
function usePageObserver() {
  const [currentPage, setCurrentPage] = useState<number>(1);
  const observer = useRef<MutationObserver | null>(null);

  useEffect(() => {
    // Function to find and extract page number from the DOM
    const extractPageNumber = () => {
      const navElement = document.querySelector('nav');
      if (navElement) {
        const pageText = navElement.textContent;
        if (pageText) {
          const match = pageText.match(/(\d+)\s*\/\s*\d+/);
          if (match && match[1]) {
            const pageNum = parseInt(match[1], 10);
            if (!isNaN(pageNum) && pageNum > 0) {
              setCurrentPage(pageNum);
            }
          }
        }
      }
    };

    // Set up mutation observer to watch for DOM changes
    observer.current = new MutationObserver((mutations) => {
      extractPageNumber();
    });

    // Start observing the document with the configured parameters
    observer.current.observe(document.body, {
      childList: true,
      subtree: true,
      attributes: true,
      characterData: true
    });

    // Initial check
    extractPageNumber();

    // Clean up observer on unmount
    return () => {
      if (observer.current) {
        observer.current.disconnect();
      }
    };
  }, []);

  return currentPage;
}

interface PitchdeckVoiceWrapperProps {
  pages: {
    file: string;
    pageNumber: string;
    embeddedLinks: string[];
    pageLinks: { href: string; coords: string }[];
    metadata: { width: number; height: number; scaleFactor: number };
  }[];
  feedbackEnabled: boolean;
  screenshotProtectionEnabled: boolean;
  versionNumber: number;
  showPoweredByBanner?: boolean;
  showAccountCreationSlide?: boolean;
  enableQuestion?: boolean | null;
  feedback?: {
    id: string;
    data: { question: string; type: string };
  } | null;
  viewerEmail?: string;
  watermarkConfig?: WatermarkConfig | null;
  ipAddress?: string;
  linkName?: string;
  navData: TNavData;
}

export default function PitchdeckVoiceWrapper(props: PitchdeckVoiceWrapperProps) {
  const { navData, pages } = props;
  const { linkId, documentId, viewId } = navData;
  
  const [showVoiceInterface, setShowVoiceInterface] = useState<boolean>(false);
  const [slideContents, setSlideContents] = useState<Array<{ pageNumber: number; content: string }>>([]);
  const [isExtractingText, setIsExtractingText] = useState<boolean>(false);
  // This state is no longer needed as we use the hook

  // Extract text from slides when the component mounts
  useEffect(() => {
    const extractText = async () => {
      if (pages.length > 0 && slideContents.length === 0 && !isExtractingText) {
        setIsExtractingText(true);
        try {
          const contents = await extractSlidesContent(pages, linkId, documentId);
          setSlideContents(contents);
        } catch (error) {
          console.error("Error extracting slide contents:", error);
        } finally {
          setIsExtractingText(false);
        }
      }
    };
    
    extractText();
  }, [pages, linkId, documentId, slideContents.length, isExtractingText]);

  // Toggle voice interface
  const toggleVoiceInterface = () => {
    setShowVoiceInterface(!showVoiceInterface);
  };

  // Use the page observer hook to track current page
  const currentPage = usePageObserver();

  return (
    <div className="relative">
      <PagesVerticalViewer
        {...props}
      />
      
      {/* Voice Toggle Button */}
      <VoiceToggleButton 
        onClick={toggleVoiceInterface} 
        isActive={showVoiceInterface}
      />
      
      {/* Voice Interface */}
      {showVoiceInterface && slideContents.length > 0 && (
        <PitchdeckVoice
          linkId={linkId}
          documentId={documentId}
          viewId={viewId}
          currentPage={currentPage}
          totalPages={pages.length}
          slideContents={slideContents}
          onClose={toggleVoiceInterface}
        />
      )}
    </div>
  );
}