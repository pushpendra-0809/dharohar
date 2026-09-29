import React from 'react';
import { X, Clock, Gamepad2 } from 'lucide-react';

export default function ComingSoonModal({ isOpen, onClose }) {
  if (!isOpen) return null;

  return (
    <div 
      className="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-deepBrown/80 backdrop-blur-sm animate-fadeIn"
      onClick={onClose}
    >
      <div 
        className="relative max-w-md w-full bg-parchment border-2 border-sandstone-dark p-8 sm:p-10 shadow-portal text-center transform transition-all"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Corner Accents */}
        <span className="absolute top-2.5 left-2.5 text-xs text-terracotta font-mono">✦</span>
        <span className="absolute top-2.5 right-2.5 text-xs text-terracotta font-mono">✦</span>
        <span className="absolute bottom-2.5 left-2.5 text-xs text-terracotta font-mono">✦</span>
        <span className="absolute bottom-2.5 right-2.5 text-xs text-terracotta font-mono">✦</span>

        {/* Close Button */}
        <button 
          onClick={onClose}
          className="absolute top-4 right-4 p-1.5 text-deepBrown/60 hover:text-terracotta hover:bg-sandstone/20 transition-colors"
          aria-label="Close modal"
        >
          <X className="w-5 h-5" />
        </button>

        {/* Icon Plate */}
        <div className="w-16 h-16 mx-auto mb-5 border-2 border-terracotta/40 bg-sandstone/20 flex items-center justify-center shadow-sm">
          <Clock className="w-8 h-8 text-terracotta" />
        </div>

        {/* Tag & Heading */}
        <span className="text-xs font-mono uppercase tracking-[0.25em] text-terracotta font-bold block mb-2">
          OFFLINE STANDALONE BUILD
        </span>
        <h3 className="text-2xl sm:text-3xl font-cinzel font-bold text-deepBrown mb-4 tracking-wide">
          COMING SOON
        </h3>

        {/* Body Text */}
        <p className="text-sm sm:text-base text-deepBrown/85 font-sans leading-relaxed mb-8">
          The standalone desktop build for Windows, macOS, and Linux is currently being packaged. Meanwhile, you can play <strong className="font-bold text-deepBrown">DHAROHAR</strong> directly in your browser!
        </p>

        {/* Action Button */}
        <button
          onClick={() => {
            onClose();
            const el = document.getElementById('experience');
            if (el) el.scrollIntoView({ behavior: 'smooth' });
          }}
          className="w-full py-3 px-6 bg-terracotta text-ivory font-sans font-bold uppercase tracking-wider text-sm border-2 border-[#853F1F] shadow-[3px_3px_0px_#35261D] hover:bg-[#35261D] hover:border-[#23170F] hover:shadow-[4px_4px_0px_#A95D3A] transition-all flex items-center justify-center gap-2"
        >
          <Gamepad2 className="w-4 h-4" />
          <span>Play Web Demo Now</span>
        </button>
      </div>
    </div>
  );
}
