import React, { useState, useRef, useEffect } from 'react';
import { MicIcon, StopCircleIcon, PlayIcon, PauseIcon, VolumeIcon, Volume2Icon, MessageCircleIcon } from 'lucide-react';
import { toast } from 'sonner';

// Add TypeScript declarations for the Web Speech API
declare global {
  interface Window {
    SpeechRecognition: any;
    webkitSpeechRecognition: any;
  }
}

// Define the SpeechRecognitionEvent type
interface SpeechRecognitionEvent {
  results: {
    [index: number]: {
      [index: number]: {
        transcript: string;
      };
    };
  };
}

type PitchdeckVoiceProps = {
  linkId: string;
  documentId: string;
  viewId?: string;
  currentPage: number;
  totalPages: number;
  slideContents: Array<{ pageNumber: number; content: string }>;
  onClose?: () => void;
};

export default function PitchdeckVoice({
  linkId,
  documentId,
  viewId,
  currentPage,
  totalPages,
  slideContents,
  onClose
}: PitchdeckVoiceProps) {
  // State for voice interaction
  const [isListening, setIsListening] = useState(false);
  const [isSpeaking, setIsSpeaking] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [question, setQuestion] = useState('');
  const [answer, setAnswer] = useState('');
  const [volume, setVolume] = useState(0.8);
  const [mode, setMode] = useState<'narrate' | 'qa'>('narrate');
  
  // Refs
  const audioRef = useRef<HTMLAudioElement | null>(null);
  const mediaRecorderRef = useRef<MediaRecorder | null>(null);
  const audioChunksRef = useRef<Blob[]>([]);
  
  // Function to get the current slide content
  const getCurrentSlideContent = () => {
    if (!slideContents || slideContents.length === 0) {
      return "No slide content available.";
    }
    
    const currentSlideContent = slideContents.find(slide => slide.pageNumber === currentPage);
    
    if (!currentSlideContent) {
      return "No content available for this slide.";
    }
    
    // Check if the content has EXPLANATION section
    if (currentSlideContent.content.includes("EXPLANATION:")) {
      // Extract the explanation part for narration
      const explanationMatch = currentSlideContent.content.match(/EXPLANATION:([\s\S]*?)(?:$|(?=\n\n\w+:))/i);
      if (explanationMatch && explanationMatch[1]) {
        return explanationMatch[1].trim();
      }
    }
    
    return currentSlideContent.content;
  };

  // Function to start text-to-speech
  const speakText = async (text: string) => {
    try {
      setIsLoading(true);
      
      // Check if the browser supports speech synthesis
      if ('speechSynthesis' in window) {
        try {
          // Try ElevenLabs API first
          const response = await fetch('/api/pitchdeck/text-to-speech', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({ text }),
          });
          
          if (response.ok) {
            const data = await response.json();
            
            // Convert base64 to audio
            const audioSrc = `data:${data.contentType};base64,${data.audioContent}`;
            
            if (audioRef.current) {
              audioRef.current.src = audioSrc;
              audioRef.current.volume = volume;
              audioRef.current.onended = () => setIsSpeaking(false);
              
              // Play the audio
              setIsSpeaking(true);
              audioRef.current.play();
            }
          } else {
            // Fallback to browser's speech synthesis
            throw new Error('Using browser fallback');
          }
        } catch (error) {
          // Use browser's built-in speech synthesis as fallback
          console.log('Using browser speech synthesis as fallback');
          const utterance = new SpeechSynthesisUtterance(text);
          utterance.volume = volume;
          utterance.onend = () => setIsSpeaking(false);
          
          // Play the speech
          setIsSpeaking(true);
          window.speechSynthesis.speak(utterance);
        }
      } else {
        // Browser doesn't support speech synthesis
        toast.error('Your browser does not support text-to-speech.');
      }
      
      setIsLoading(false);
    } catch (error) {
      console.error('Error speaking text:', error);
      toast.error('Failed to speak text. Please try again.');
      setIsLoading(false);
      setIsSpeaking(false);
    }
  };
  
  // Function to narrate the current slide
  const narrateCurrentSlide = () => {
    const content = getCurrentSlideContent();
    
    if (!content) {
      toast.error('No content available for this slide');
      return;
    }
    
    // Create a more engaging introduction for the narration
    const slideNumber = currentPage;
    const introduction = `Slide ${slideNumber}: `;
    
    speakText(introduction + content);
  };
  
  // Function to stop speaking
  const stopSpeaking = () => {
    if (audioRef.current) {
      audioRef.current.pause();
      audioRef.current.currentTime = 0;
      setIsSpeaking(false);
    }
  };
  
  // Function to toggle play/pause
  const togglePlayPause = () => {
    if (audioRef.current) {
      if (isSpeaking) {
        audioRef.current.pause();
        setIsSpeaking(false);
      } else {
        audioRef.current.play();
        setIsSpeaking(true);
      }
    }
  };
  
  // Function to start listening
  const startListening = async () => {
    try {
      // Check if the browser supports speech recognition
      const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
      
      if (SpeechRecognition) {
        try {
          // Try using the microphone first
          const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
          
          const mediaRecorder = new MediaRecorder(stream);
          mediaRecorderRef.current = mediaRecorder;
          audioChunksRef.current = [];
          
          mediaRecorder.ondataavailable = (event) => {
            audioChunksRef.current.push(event.data);
          };
          
          mediaRecorder.onstop = async () => {
            const audioBlob = new Blob(audioChunksRef.current, { type: 'audio/webm' });
            
            try {
              setIsLoading(true);
              
              try {
                // Try ElevenLabs API first
                const formData = new FormData();
                formData.append('audio', audioBlob);
                
                const response = await fetch('/api/pitchdeck/speech-to-text', {
                  method: 'POST',
                  body: formData,
                });
                
                if (response.ok) {
                  const data = await response.json();
                  const recognizedText = data.text;
                  
                  // Set the recognized text as the question
                  setQuestion(recognizedText);
                  
                  // If in QA mode, automatically ask the question
                  if (mode === 'qa' && recognizedText) {
                    await askQuestion(recognizedText);
                  }
                } else {
                  // Fallback to browser's speech recognition
                  throw new Error('Using browser fallback');
                }
              } catch (error) {
                // Use browser's built-in speech recognition as fallback
                console.log('Using browser speech recognition as fallback');
                
                const recognition = new SpeechRecognition();
                recognition.lang = 'en-US';
                
                recognition.onresult = (event: SpeechRecognitionEvent) => {
                  const transcript = event.results[0][0].transcript;
                  setQuestion(transcript);
                  
                  // If in QA mode, automatically ask the question
                  if (mode === 'qa' && transcript) {
                    askQuestion(transcript);
                  }
                };
                
                recognition.start();
              }
              
              setIsLoading(false);
            } catch (error) {
              console.error('Error processing speech:', error);
              toast.error('Failed to process speech. Please try again.');
              setIsLoading(false);
            }
          };
      
          mediaRecorder.start();
          setIsListening(true);
          
          // Automatically stop recording after 10 seconds
          setTimeout(() => {
            if (mediaRecorderRef.current && mediaRecorderRef.current.state === 'recording') {
              stopListening();
            }
          }, 10000);
        } catch (error) {
          // Fallback to browser's speech recognition
          console.log('Using browser speech recognition directly');
          
          const recognition = new SpeechRecognition();
          recognition.lang = 'en-US';
          
          recognition.onstart = () => {
            setIsListening(true);
          };
          
          recognition.onend = () => {
            setIsListening(false);
          };
          
          recognition.onresult = (event: SpeechRecognitionEvent) => {
            const transcript = event.results[0][0].transcript;
            setQuestion(transcript);
            
            // If in QA mode, automatically ask the question
            if (mode === 'qa' && transcript) {
              askQuestion(transcript);
            }
          };
          
          recognition.start();
          
          // Automatically stop after 10 seconds
          setTimeout(() => {
            recognition.stop();
          }, 10000);
        }
      } else {
        toast.error('Your browser does not support speech recognition.');
      }
    } catch (error) {
      console.error('Error starting microphone:', error);
      toast.error('Failed to access microphone. Please check permissions.');
    }
  };
  
  // Function to stop listening
  const stopListening = () => {
    if (mediaRecorderRef.current && mediaRecorderRef.current.state === 'recording') {
      mediaRecorderRef.current.stop();
      setIsListening(false);
    }
  };
  
  // Function to ask a question
  const askQuestion = async (text: string) => {
    try {
      setIsLoading(true);
      
      try {
        // Try OpenAI API first
        const response = await fetch('/api/pitchdeck/ask-question', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            question: text,
            slideContents,
            currentSlideNumber: currentPage,
            linkId,
            documentId,
          }),
        });
        
        if (response.ok) {
          const data = await response.json();
          setAnswer(data.answer);
          
          // Speak the answer
          await speakText(data.answer);
        } else {
          // Fallback to simple response
          throw new Error('Using fallback response');
        }
      } catch (error) {
        // Generate a simple fallback response
        console.log('Using fallback response generation');
        const fallbackAnswer = `I'm sorry, I couldn't process your question "${text}" at this time. Please try again later when API services are available.`;
        setAnswer(fallbackAnswer);
        
        // Speak the fallback answer
        await speakText(fallbackAnswer);
      }
      
      setIsLoading(false);
    } catch (error) {
      console.error('Error asking question:', error);
      toast.error('Failed to get answer. Please try again.');
      setIsLoading(false);
    }
  };
  
  // Handle volume change
  const handleVolumeChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newVolume = parseFloat(e.target.value);
    setVolume(newVolume);
    
    if (audioRef.current) {
      audioRef.current.volume = newVolume;
    }
  };
  
  // Switch between narration and Q&A modes
  const toggleMode = () => {
    setMode(mode === 'narrate' ? 'qa' : 'narrate');
    // Reset state when switching modes
    setQuestion('');
    setAnswer('');
    stopSpeaking();
  };
  
  // Clean up on unmount
  useEffect(() => {
    return () => {
      if (mediaRecorderRef.current && mediaRecorderRef.current.state === 'recording') {
        mediaRecorderRef.current.stop();
      }
      
      if (audioRef.current) {
        audioRef.current.pause();
      }
    };
  }, []);
  
  // Extract slide content on mount
  useEffect(() => {
    // If we're in narrate mode and the slide changes, automatically narrate the new slide
    if (mode === 'narrate' && !isSpeaking && !isLoading) {
      const content = getCurrentSlideContent();
      if (content) {
        narrateCurrentSlide();
      }
    }
  }, [currentPage, mode]);
  
  return (
    <div className="fixed bottom-20 right-4 z-50 flex flex-col items-end">
      {/* Hidden audio element for playback */}
      <audio ref={audioRef} className="hidden" />
      
      {/* Main voice interaction panel */}
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-4 w-80 mb-2">
        <div className="flex justify-between items-center mb-3">
          <h3 className="text-lg font-semibold">
            {mode === 'narrate' ? 'Pitch Narration' : 'Ask About Slide'}
          </h3>
          <button
            onClick={toggleMode}
            className="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
          >
            {mode === 'narrate' ? (
              <MessageCircleIcon size={20} />
            ) : (
              <VolumeIcon size={20} />
            )}
          </button>
        </div>
        
        {/* Narration mode content */}
        {mode === 'narrate' && (
          <div>
            <p className="text-sm text-gray-600 dark:text-gray-300 mb-3">
              Slide {currentPage} of {totalPages}
            </p>
            
            <div className="flex justify-between items-center mb-3">
              <button
                onClick={togglePlayPause}
                disabled={isLoading}
                className="bg-blue-500 hover:bg-blue-600 text-white rounded-full p-2 disabled:opacity-50"
              >
                {isSpeaking ? <PauseIcon size={20} /> : <PlayIcon size={20} />}
              </button>
              
              <button
                onClick={stopSpeaking}
                disabled={!isSpeaking || isLoading}
                className="bg-red-500 hover:bg-red-600 text-white rounded-full p-2 disabled:opacity-50"
              >
                <StopCircleIcon size={20} />
              </button>
              
              <div className="flex items-center">
                <Volume2Icon size={16} className="mr-2 text-gray-500" />
                <input
                  type="range"
                  min="0"
                  max="1"
                  step="0.1"
                  value={volume}
                  onChange={handleVolumeChange}
                  className="w-20"
                />
              </div>
            </div>
            
            {isLoading && (
              <div className="text-center py-2">
                <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-blue-500 mx-auto"></div>
                <p className="text-sm text-gray-500 mt-1">Loading audio...</p>
              </div>
            )}
          </div>
        )}
        
        {/* Q&A mode content */}
        {mode === 'qa' && (
          <div>
            <div className="mb-3">
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Your Question
              </label>
              <div className="flex items-center">
                <input
                  type="text"
                  value={question}
                  onChange={(e) => setQuestion(e.target.value)}
                  placeholder="Ask about this slide..."
                  className="flex-1 p-2 border rounded-l-md dark:bg-gray-700 dark:border-gray-600"
                  disabled={isListening || isLoading}
                />
                <button
                  onClick={isListening ? stopListening : startListening}
                  className={`p-2 rounded-r-md ${
                    isListening
                      ? 'bg-red-500 hover:bg-red-600'
                      : 'bg-blue-500 hover:bg-blue-600'
                  } text-white`}
                  disabled={isLoading}
                >
                  <MicIcon size={20} />
                </button>
              </div>
            </div>
            
            <button
              onClick={() => askQuestion(question)}
              disabled={!question || isLoading || isListening}
              className="w-full bg-blue-500 hover:bg-blue-600 text-white py-2 px-4 rounded-md disabled:opacity-50 mb-3"
            >
              {isLoading ? 'Processing...' : 'Ask'}
            </button>
            
            {answer && (
              <div className="mt-3 p-3 bg-gray-100 dark:bg-gray-700 rounded-md">
                <p className="text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Answer:
                </p>
                <p className="text-sm text-gray-600 dark:text-gray-400">{answer}</p>
              </div>
            )}
            
            {isListening && (
              <div className="text-center py-2 mt-2">
                <div className="flex justify-center items-center space-x-1">
                  <div className="w-2 h-2 bg-red-500 rounded-full animate-pulse"></div>
                  <div className="w-2 h-2 bg-red-500 rounded-full animate-pulse delay-75"></div>
                  <div className="w-2 h-2 bg-red-500 rounded-full animate-pulse delay-150"></div>
                </div>
                <p className="text-sm text-gray-500 mt-1">Listening...</p>
              </div>
            )}
          </div>
        )}
      </div>
      
      {/* Toggle button */}
      <button
        onClick={onClose}
        className="bg-blue-500 hover:bg-blue-600 text-white rounded-full p-3 shadow-lg"
      >
        <VolumeIcon size={24} />
      </button>
    </div>
  );
}