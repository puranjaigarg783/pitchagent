# Talk to Your Pitchdeck - Voice Interaction Feature

This feature adds voice interaction capabilities to horizontal PDF presentations, allowing users to:

1. Listen to slide narration with context and explanations using text-to-speech
2. Ask questions about slides using speech-to-text
3. Get AI-powered answers that distinguish between slide content and additional knowledge

## Graceful Degradation

This implementation includes fallback mechanisms for when API services are unavailable:

1. **Text-to-Speech**: Falls back to browser's built-in SpeechSynthesis API if ElevenLabs is unavailable
2. **Speech-to-Text**: Falls back to browser's SpeechRecognition API if ElevenLabs is unavailable
3. **Text Extraction**: Provides generic slide content based on slide position if OpenAI is unavailable
4. **Question Answering**: Provides a friendly error message if OpenAI is unavailable

## Architecture

The implementation consists of several components:

### Frontend Components

- **PitchdeckVoiceWrapper**: A wrapper component that adds voice functionality to the existing PDF viewer
- **PitchdeckVoice**: The main voice interaction UI component
- **VoiceToggleButton**: A button to toggle the voice interface

### Backend API Endpoints

- **/api/pitchdeck/extract-text**: Extracts text from slide images using OpenAI's GPT-4 Vision
- **/api/pitchdeck/text-to-speech**: Converts text to speech using ElevenLabs API
- **/api/pitchdeck/speech-to-text**: Converts speech to text using ElevenLabs API
- **/api/pitchdeck/ask-question**: Answers questions about slides using OpenAI's GPT-4

### Utility Functions

- **extractSlidesContent**: Extracts text from all slides in a document

## Setup

1. Make sure the required API keys are in your `.env` file:

```
OPENAI_API_KEY=your_openai_api_key_here
ELEVENLABS_API_KEY=your_elevenlabs_api_key_here
```

2. Install the required dependencies:

```bash
npm install formidable @types/formidable
```

## How It Works

1. When a PDF is viewed in horizontal mode, the `PitchdeckVoiceWrapper` component is used
2. A voice toggle button appears in the bottom right corner
3. When clicked, the voice interface appears
4. In "Narrate" mode, the system reads the content of the current slide
5. In "Q&A" mode, users can ask questions about the slides
6. The system extracts text from slides using OpenAI's GPT-4 Vision
7. Questions are answered using OpenAI's GPT-4 with context from all slides

## User Experience

1. User opens a PDF presentation
2. User clicks the voice button to activate the voice interface
3. User can listen to slide narration or switch to Q&A mode
4. In Q&A mode, user can type or speak questions
5. The system responds with answers based on the presentation content

## Technical Implementation Details

### Text Extraction

We use OpenAI's GPT-4o (with vision capabilities) to extract text from slide images and provide additional context and explanations. The system extracts both the raw slide content and provides a more detailed explanation of what the slide is trying to convey. This approach works with any PDF without requiring OCR or text layer extraction.

### Voice Synthesis

We use ElevenLabs for high-quality text-to-speech, providing natural-sounding narration.

### Speech Recognition

We use ElevenLabs with the 'scribe_v1' model for speech-to-text, allowing users to ask questions verbally.

### Question Answering

We use OpenAI's GPT-4o to answer questions about the presentation, providing context from all slides to ensure accurate responses. The system clearly distinguishes between information that comes directly from the slides and additional knowledge or context it provides, making it clear to users what information is from the presentation and what is supplementary.

## Limitations

1. Text extraction quality depends on the clarity of the slide images
2. Voice interaction requires microphone permissions in the browser
3. API rate limits may apply for OpenAI and ElevenLabs
4. Currently only works with horizontal PDF presentations (not vertical mode)
5. Fallback mechanisms provide reduced functionality compared to the full API-powered experience

## Future Improvements

1. Add support for more languages
2. Implement caching to reduce API calls
3. Add visual highlighting of text being narrated
4. Improve context handling for multi-page documents
5. Add support for custom voices
6. Enhance fallback mechanisms with more sophisticated local processing
7. Add offline mode that works entirely without external APIs