import React, { useState } from 'react';
import { siteConfig } from '../config/siteConfig';
import { CheckCircle2 } from 'lucide-react';

export default function Solution() {
  const { solution } = siteConfig.siteData;
  const [activeStageId, setActiveStageId] = useState('explore');

  const activeStage = solution.stages.find(s => s.id === activeStageId) || solution.stages[0];

  return (
    <section id="solution" className="relative py-28 bg-parchment border-t border-sandstone-dark/20 overflow-hidden">
      {/* Ambient background aura */}
      <div className="absolute top-1/3 left-1/2 -translate-x-1/2 w-[800px] h-[500px] bg-sandstone/25 rounded-full blur-[140px] pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        
        {/* Section Header */}
        <div className="text-center max-w-4xl mx-auto mb-20">
          <h2 className="text-3xl sm:text-4xl md:text-5xl font-cinzel font-semibold text-deepBrown tracking-wide mb-6">
            {solution.heading}
          </h2>

          <p className="text-2xl sm:text-3xl md:text-4xl font-cormorant font-normal italic text-terracotta leading-relaxed mb-6">
            "{solution.largeStatement}"
          </p>

          <p className="text-lg sm:text-xl text-deepBrown font-medium max-w-3xl mx-auto mb-4 leading-relaxed">
            {solution.coreText}
          </p>

          <p className="text-sm sm:text-base text-deepBrown/85 font-sans max-w-2xl mx-auto leading-relaxed">
            {solution.supportingCopy}
          </p>
        </div>

        {/* Interactive Gameplay Philosophy Flow: EXPLORE → DISCOVER → LEARN → SOLVE */}
        <div className="mb-16">
          <div className="text-center mb-10">
            <h3 className="text-2xl sm:text-3xl font-cinzel font-bold text-deepBrown tracking-wide">
              Core Gameplay Progression
            </h3>
          </div>

          {/* 4 Interactive Stage Tabs with Normal Numbers */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3 sm:gap-4 mb-8">
            {solution.stages.map((stage) => {
              const isSelected = stage.id === activeStageId;
              return (
                <button
                  key={stage.id}
                  onClick={() => setActiveStageId(stage.id)}
                  className={`p-5 sm:p-6 text-left border-[1.5px] transition-all duration-300 relative ${
                    isSelected
                      ? 'bg-parchment-light border-terracotta shadow-plaque -translate-y-1'
                      : 'bg-parchment/60 border-deepBrown/15 hover:border-sandstone-dark hover:bg-parchment-light/60'
                  }`}
                >
                  {/* Normal Clean Number */}
                  <div className="mb-2">
                    <span className={`text-xl sm:text-2xl font-cormorant font-bold transition-colors ${
                      isSelected ? 'text-terracotta' : 'text-deepBrown/40'
                    }`}>
                      {stage.step}
                    </span>
                  </div>

                  <h3 className="text-base sm:text-lg font-cinzel font-bold text-deepBrown mb-1">
                    {stage.name}
                  </h3>

                  <p className="text-xs sm:text-[13px] text-deepBrown/80 font-sans font-medium line-clamp-1">
                    {stage.action}
                  </p>

                  {isSelected && (
                    <div className="absolute -bottom-[2px] left-0 right-0 h-[3px] bg-terracotta" />
                  )}
                </button>
              );
            })}
          </div>

          {/* Active Stage Interactive Showcase Plate (Full Width, No Side Callout) */}
          <div className="bg-parchment-light border-[1.5px] border-sandstone-dark p-8 sm:p-12 shadow-plaque relative overflow-hidden">
            {/* Corner brackets */}
            <span className="absolute top-2.5 left-2.5 text-xs text-deepBrown/40 font-mono">✦</span>
            <span className="absolute top-2.5 right-2.5 text-xs text-deepBrown/40 font-mono">✦</span>
            <span className="absolute bottom-2.5 left-2.5 text-xs text-deepBrown/40 font-mono">✦</span>
            <span className="absolute bottom-2.5 right-2.5 text-xs text-deepBrown/40 font-mono">✦</span>

            <div className="max-w-4xl">
              <h4 className="text-2xl sm:text-3xl font-cinzel font-bold text-deepBrown mb-4 leading-snug">
                {activeStage.name} — {activeStage.action}
              </h4>

              <p className="text-lg sm:text-[20px] font-cormorant text-deepBrown leading-relaxed mb-6 tracking-wide font-medium">
                {activeStage.description}
              </p>

              {/* In-Game Mechanics Indicator */}
              <div className="p-4 bg-parchment border-l-2 border-terracotta text-sm font-mono text-deepBrown flex items-center gap-3">
                <CheckCircle2 className="w-4 h-4 text-terracotta shrink-0" />
                <span className="tracking-wide font-medium">{activeStage.visualSnippet}</span>
              </div>
            </div>
          </div>
        </div>

      </div>
    </section>
  );
}
