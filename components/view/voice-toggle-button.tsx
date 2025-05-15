import React from 'react';
import { VolumeIcon } from 'lucide-react';
import { cn } from '@/lib/utils';

interface VoiceToggleButtonProps {
  onClick: () => void;
  isActive?: boolean;
  className?: string;
}

export default function VoiceToggleButton({
  onClick,
  isActive = false,
  className
}: VoiceToggleButtonProps) {
  return (
    <button
      onClick={onClick}
      className={cn(
        "fixed bottom-20 right-4 z-50 bg-blue-500 hover:bg-blue-600 text-white rounded-full p-3 shadow-lg",
        isActive && "bg-blue-700",
        className
      )}
      aria-label={isActive ? "Disable voice assistant" : "Enable voice assistant"}
      title={isActive ? "Disable voice assistant" : "Enable voice assistant"}
    >
      <VolumeIcon size={24} />
    </button>
  );
}