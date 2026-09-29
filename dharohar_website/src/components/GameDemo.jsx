import React, { useState, useRef } from 'react';
import { siteConfig } from '../config/siteConfig';
import HeritageButton from './HeritageButton';
import { Gamepad2, Download, Play, Maximize2, Cpu, Volume2, VolumeX, Sparkles } from 'lucide-react';

export default function GameDemo() {
  const { gameEmbedUrl, gameDownloadUrl } = siteConfig;
  const [audioEnabled, setAudioEnabled] = useState(false);
  const iframeRef = useRef(null);

  const handleFullscreen = () => {
    const elem = iframeRef.current;
    if (!elem) return;
    try {
      if (elem.requestFullscreen) {
        elem.requestFullscreen();
      } else if (elem.webkitRequestFullscreen) {
        elem.webkitRequestFullscreen();
      } else if (elem.webkitEnterFullscreen) {
        elem.webkitEnterFullscreen();
      } else if (elem.msRequestFullscreen) {
        elem.msRequestFullscreen();
      }
    } catch (err) {
      console.warn("Fullscreen request failed:", err);
    }
  };

  const controlsMapping = [
    { key: "WASD / ARROWS", action: "Navigate Historical World" },
    { key: "E / SPACE", action: "Interact, Inspect Artifacts & NPCs" },
    { key: "ESC", action: "World Map & Architectural Pause" }
  ];

  return (
    <section id="experience" className="relative py-20 sm:py-28 bg-parchment border-t border-sandstone-dark/20 overflow-hidden">
      {/* Background Ambience */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[900px] h-[500px] bg-sandstone/20 rounded-full blur-[160px] pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        
        {/* Section Header */}
        <div className="text-center max-w-3xl mx-auto mb-10 sm:mb-16">
          <h2 className="text-3xl sm:text-4xl md:text-5xl font-cinzel font-semibold text-deepBrown tracking-wide mb-4">
            EXPERIENCE DHAROHAR
          </h2>

          <p className="text-xl sm:text-2xl font-cormorant italic text-terracotta tracking-wide max-w-xl mx-auto">
            "Don't just read about history. Step inside it."
          </p>

          {/* Mobile Orientation Hint */}
          <div className="inline-flex items-center gap-2 mt-4 px-3.5 py-1.5 bg-sandstone/15 border border-gold/40 text-deepBrown text-xs sm:text-sm font-sans rounded-full">
            <span>📱</span>
            <span className="font-medium">
              Mobile & Tablet Ready: <strong>Rotate to Landscape</strong> & tap <strong>FULLSCREEN</strong> for best immersion!
            </span>
          </div>
        </div>

        {/* Dedicated Framed Game Portal Container */}
        <div className="max-w-5xl mx-auto bg-parchment-light border-[2px] border-sandstone-dark shadow-portal overflow-hidden relative rounded-sm">
          
          {/* Architectural Portal Top Bar */}
          <div className="bg-deepBrown px-4 sm:px-6 py-3 border-b border-sandstone-dark flex items-center justify-between gap-2 text-xs font-mono text-sandstone">
            <div className="flex items-center gap-2 sm:gap-3">
              <span className="w-2.5 h-2.5 bg-terracotta border border-gold shrink-0" />
              <span className="text-ivory font-bold tracking-wider truncate">
                DHAROHAR: GAME PORTAL
              </span>
              <span className="hidden md:inline text-sandstone/70">
                • Godot Engine 4.x (Web, Android & iOS)
              </span>
            </div>

            <div className="flex items-center gap-3 text-parchment/80 shrink-0">
              <button 
                onClick={handleFullscreen}
                className="hover:text-gold px-2 py-1 bg-parchment/10 border border-gold/30 hover:border-gold transition-all flex items-center gap-1.5 text-[11px] font-bold text-gold cursor-pointer"
                title="Launch Game in Fullscreen"
              >
                <Maximize2 className="w-3.5 h-3.5 text-gold" />
                <span>FULLSCREEN</span>
              </button>
            </div>
          </div>

          {/* Main Display Viewport (Embedded Game or Framed Heritage Placeholder) */}
          <div className="relative aspect-[16/9] min-h-[280px] sm:min-h-[420px] md:min-h-[520px] flex items-center justify-center bg-black overflow-hidden text-parchment-light">
            
            {/* If GAME_EMBED_URL is provided, render live embed */}
            {gameEmbedUrl ? (
              <iframe
                ref={iframeRef}
                src={gameEmbedUrl}
                title="DHAROHAR Web Game Experience"
                className="w-full h-full border-0 touch-none"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; fullscreen"
                allowFullScreen
              />
            ) : (
              /* Custom Sandstone Framed Placeholder */
              <div className="relative z-10 text-center px-6 py-12 max-w-lg mx-auto flex flex-col items-center">
                
                {/* Ornamental Portal Icon */}
                <div className="relative mb-6">
                  <div className="w-20 h-20 sm:w-24 sm:h-24 border-2 border-gold/40 bg-sandstone/10 flex items-center justify-center relative">
                    <span className="absolute -top-1 -left-1 w-2 h-2 bg-gold" />
                    <span className="absolute -top-1 -right-1 w-2 h-2 bg-gold" />
                    <span className="absolute -bottom-1 -left-1 w-2 h-2 bg-gold" />
                    <span className="absolute -bottom-1 -right-1 w-2 h-2 bg-gold" />
                    
                    <Gamepad2 className="w-10 h-10 text-sandstone" />
                  </div>
                </div>

                <span className="text-xs font-mono uppercase tracking-[0.25em] text-gold font-bold mb-2">
                  PLAY DEMO
                </span>

                {/* Primary Placeholder Statement */}
                <div className="px-5 py-2 bg-terracotta/20 border border-terracotta/50 text-ivory font-mono text-sm sm:text-base tracking-widest font-bold mb-4">
                  [ GAME DEMO WILL APPEAR HERE ]
                </div>

                <p className="text-xs sm:text-sm text-parchment/80 font-sans leading-relaxed mb-8">
                  The Godot HTML5 Web build is being prepared for browser play. You can configure the embed endpoint via <code className="bg-black/50 px-2 py-0.5 border border-gold/30 text-gold font-mono text-xs">GAME_EMBED_URL</code> or download the standalone desktop build.
                </p>

                {/* Direct Action */}
                <HeritageButton
                  href={gameDownloadUrl}
                  variant="terracotta"
                  icon="download"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  Download Standalone Build
                </HeritageButton>

              </div>
            )}

            {/* Subtle Grid overlay */}
            <div 
              className="absolute inset-0 pointer-events-none opacity-10"
              style={{
                backgroundImage: 'linear-gradient(rgba(229,199,139,0.3) 1px, transparent 1px), linear-gradient(90deg, rgba(229,199,139,0.3) 1px, transparent 1px)',
                backgroundSize: '40px 40px'
              }}
            />
          </div>

          {/* Controls & Mechanics Mapping Plaque */}
          <div className="bg-parchment p-5 sm:p-8 border-t border-sandstone-dark">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 mb-4 pb-2 border-b border-deepBrown/10">
              <span className="text-xs sm:text-sm font-mono uppercase tracking-[0.2em] text-deepBrown font-bold">
                ✦ CONTROLS MAPPING ✦
              </span>
              <span className="text-[11px] sm:text-xs font-mono text-deepBrown/70 font-semibold">
                Touchscreen, Gamepad & Keyboard Supported
              </span>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
              {controlsMapping.map((ctrl) => (
                <div 
                  key={ctrl.key}
                  className="p-3 sm:p-3.5 bg-parchment-light border border-deepBrown/10 flex flex-col justify-between"
                >
                  <span className="text-[11px] sm:text-[13px] font-mono font-bold text-terracotta mb-1">
                    {ctrl.key}
                  </span>
                  <span className="text-[11px] sm:text-xs text-deepBrown/85 font-sans font-medium">
                    {ctrl.action}
                  </span>
                </div>
              ))}
            </div>
          </div>

        </div>

      </div>
    </section>
  );
}
