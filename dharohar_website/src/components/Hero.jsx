import React, { useRef } from 'react';
import { motion, useScroll, useTransform } from 'framer-motion';
import { siteConfig } from '../config/siteConfig';
import HeritageButton from './HeritageButton';
import logoImg from '../assets/logo.png';
import heroBgImg from '../assets/hero-heritage-bg.jpg';

export default function Hero() {
  const { hero } = siteConfig.siteData;
  const containerRef = useRef(null);

  // Scroll-driven interaction for background parallax & depth
  const { scrollYProgress } = useScroll({
    target: containerRef,
    offset: ["start start", "end start"]
  });

  const bgY = useTransform(scrollYProgress, [0, 1], ["0%", "18%"]);
  const bgScale = useTransform(scrollYProgress, [0, 1], [1.02, 1.12]);
  const bgOpacity = useTransform(scrollYProgress, [0, 0.7, 1], [0.88, 0.65, 0.2]);

  return (
    <section 
      ref={containerRef}
      className="relative min-h-[94vh] flex items-center justify-center overflow-hidden pt-28 pb-20 bg-parchment"
    >
      {/* Warm Heritage Atmospheric Backdrop */}
      <div className="absolute inset-0 pointer-events-none overflow-hidden">
        {/* Scroll-Interactive Architectural Landscape - Vivid & Clearly Visible */}
        <motion.div 
          className="absolute inset-0 bg-cover bg-center filter contrast-105 will-change-transform origin-center"
          style={{
            backgroundImage: `url(${heroBgImg})`,
            y: bgY,
            scale: bgScale,
            opacity: bgOpacity
          }}
        />

        {/* Soft Edge-Only Vignette & Subtle Light Glow (Keeps Center Clear) */}
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_center,_rgba(246,238,219,0.15)_0%,_rgba(246,238,219,0.45)_65%,_rgba(246,238,219,0.92)_100%)] z-10 pointer-events-none" />
        
        {/* Subtle Diagonal Warm Sunlight Overlay */}
        <div className="absolute inset-0 bg-[linear-gradient(115deg,rgba(255,255,255,0.2)_0%,transparent_40%,rgba(212,166,58,0.06)_50%,transparent_70%)] mix-blend-soft-light z-10 pointer-events-none" />

        {/* Ambient Warmth Highlights */}
        <div className="absolute bottom-0 left-0 right-0 h-32 bg-gradient-to-t from-parchment to-transparent z-10 pointer-events-none" />
      </div>

      {/* Hero Central Content */}
      <div className="relative z-10 max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center flex flex-col items-center">
        
        {/* Soft Central Luminance Back-plate for absolute text readability over sunrise */}
        <div className="absolute -inset-10 bg-[radial-gradient(ellipse_at_center,_rgba(246,238,219,0.7)_0%,_rgba(246,238,219,0.35)_55%,_transparent_75%)] blur-xl pointer-events-none -z-10" />

        {/* Prominent Official DHAROHAR Logo */}
        <div className="relative mb-5 group">
          {/* Soft ambient back-glow */}
          <div className="absolute -inset-6 bg-gradient-to-r from-sandstone/50 via-gold/40 to-terracotta/40 blur-2xl opacity-80 group-hover:opacity-100 transition-opacity duration-700 pointer-events-none" />
          
          <div className="relative animate-subtle-float">
            <img 
              src={logoImg} 
              alt="DHAROHAR Logo" 
              className="max-h-36 sm:max-h-44 md:max-h-56 w-auto object-contain mx-auto filter drop-shadow-[0_12px_28px_rgba(53,38,29,0.25)]"
            />
          </div>
        </div>

        {/* Tagline with crisp contrast */}
        <h1 className="text-2xl sm:text-3xl md:text-5xl font-cormorant font-bold text-deepBrown uppercase tracking-[0.14em] mb-4 max-w-3xl leading-tight drop-shadow-[0_2px_12px_rgba(255,248,235,0.95)]">
          "{hero.tagline}"
        </h1>

        {/* Subtitle / Digital Museum Framing */}
        <p className="text-base sm:text-lg md:text-xl text-deepBrown font-medium max-w-2xl font-sans leading-relaxed mb-9 tracking-wide drop-shadow-[0_1px_8px_rgba(255,248,235,0.9)]">
          {hero.subtitle}
        </p>

        {/* Interactive Custom Button Language Actions */}
        <div className="flex flex-col sm:flex-row items-center gap-4 sm:gap-6 mb-12">
          <HeritageButton
            href="#about"
            variant="primary"
            icon="arrow-right"
          >
            {hero.primaryCta}
          </HeritageButton>

          <HeritageButton
            href="#experience"
            variant="sandstone"
            icon="arrow-down"
          >
            {hero.secondaryCta}
          </HeritageButton>
        </div>

        {/* Bottom Civilizational Stat Plaques - Framed in Frosted Heritage Glass Plaques */}
        <div className="grid grid-cols-3 gap-3 sm:gap-6 max-w-2xl w-full pt-2">
          {hero.stats.map((stat, idx) => (
            <div 
              key={idx} 
              className="text-center bg-parchment-light/85 backdrop-blur-md p-3.5 sm:p-4 border border-sandstone-dark/50 shadow-[2px_2px_0px_rgba(53,38,29,0.1)] hover:border-terracotta transition-all"
            >
              <span className="block text-xl sm:text-3xl font-cinzel font-bold text-terracotta mb-0.5">
                {stat.value}
              </span>
              <span className="text-xs sm:text-sm uppercase tracking-wider text-deepBrown font-sans font-bold">
                {stat.label}
              </span>
            </div>
          ))}
        </div>

      </div>
    </section>
  );
}
