import React, { useState } from 'react';
import { siteConfig } from '../config/siteConfig';
import { ArrowRight } from 'lucide-react';

export default function WhyDharohar() {
  const { whyDharohar } = siteConfig.siteData;
  const [hoveredPillar, setHoveredPillar] = useState(null);

  return (
    <section id="why-dharohar" className="relative py-28 bg-parchment-light border-t border-sandstone-dark/20 overflow-hidden">
      {/* Background Ambience */}
      <div className="absolute top-1/2 -left-32 w-80 h-80 bg-terracotta/5 rounded-full blur-3xl pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        
        {/* Section Header */}
        <div className="max-w-4xl mx-auto text-center mb-20">
          <h2 className="text-3xl sm:text-4xl md:text-5xl font-cinzel font-semibold text-deepBrown tracking-wide mb-6">
            {whyDharohar.heading}
          </h2>

          <p className="text-2xl sm:text-3xl md:text-4xl font-cormorant italic text-terracotta max-w-2xl mx-auto leading-relaxed">
            "{whyDharohar.largeStatement}"
          </p>
        </div>

        {/* The Four Interactive Pillars Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-20">
          {whyDharohar.pillars.map((pillar, idx) => (
            <div 
              key={pillar.number}
              onMouseEnter={() => setHoveredPillar(idx)}
              onMouseLeave={() => setHoveredPillar(null)}
              className="bg-parchment border-[1.5px] border-deepBrown/15 p-8 flex flex-col justify-between group hover:border-terracotta hover:bg-parchment-light hover:shadow-plaque-hover transition-all duration-300 relative"
            >
              {/* Corner Ornaments */}
              <span className="absolute top-1.5 left-1.5 text-[9px] text-gold font-mono">✦</span>
              <span className="absolute top-1.5 right-1.5 text-[9px] text-gold font-mono">✦</span>
              <span className="absolute bottom-1.5 left-1.5 text-[9px] text-gold font-mono">✦</span>
              <span className="absolute bottom-1.5 right-1.5 text-[9px] text-gold font-mono">✦</span>

              <div>
                <div className="mb-6 pb-3 border-b border-deepBrown/10">
                  <span className="text-3xl font-cormorant font-bold text-terracotta">
                    {pillar.number}
                  </span>
                </div>

                <h3 className="text-xl font-cinzel font-bold text-deepBrown mb-3">
                  {pillar.title}
                </h3>

                <p className="text-xs text-deepBrown/75 font-sans leading-relaxed font-normal">
                  {pillar.details}
                </p>
              </div>

              <div className="mt-8 pt-4 border-t border-deepBrown/10 flex items-center justify-between text-[10px] font-mono uppercase tracking-widest text-deepBrown/60 group-hover:text-terracotta">
                <span>Pillar Paradigm</span>
                <ArrowRight className="w-3.5 h-3.5 transition-transform group-hover:translate-x-1" />
              </div>
            </div>
          ))}
        </div>

        {/* Expanding Universe Pathway */}
        <div className="bg-parchment border-[1.5px] border-sandstone-dark p-8 sm:p-12 shadow-plaque relative overflow-hidden">
          <div className="flex flex-col lg:flex-row items-center justify-between gap-8">
            
            <div className="max-w-md text-center lg:text-left">
              <h3 className="text-xl font-cinzel font-bold text-deepBrown mb-2">
                {whyDharohar.expandingUniverse.title}
              </h3>
              <p className="text-xs text-deepBrown/75 font-sans leading-relaxed">
                {whyDharohar.expandingUniverse.description}
              </p>
            </div>

            {/* Universe Flow Progression */}
            <div className="flex flex-wrap items-center justify-center gap-2 sm:gap-3 text-xs sm:text-sm font-cinzel font-bold tracking-wider">
              {whyDharohar.expandingUniverse.progression.map((item, index) => (
                <React.Fragment key={item}>
                  <span className={`px-4 py-2 border-[1.5px] ${
                    index < 3 
                      ? 'bg-parchment-light border-terracotta text-deepBrown shadow-sm'
                      : 'bg-parchment/60 border-deepBrown/20 text-deepBrown/50'
                  }`}>
                    {item}
                  </span>
                  {index < whyDharohar.expandingUniverse.progression.length - 1 && (
                    <span className="text-terracotta font-mono font-bold">→</span>
                  )}
                </React.Fragment>
              ))}
              <span className="px-3 py-2 text-terracotta font-mono font-bold text-xs">
                → ...
              </span>
            </div>

          </div>
        </div>

      </div>
    </section>
  );
}
