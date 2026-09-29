import React, { useState } from 'react';
import { siteConfig } from '../config/siteConfig';
import { MapPin, Calendar, ArrowRight } from 'lucide-react';

export default function Worlds() {
  const { worldsData } = siteConfig;
  const [activeWorldId, setActiveWorldId] = useState(worldsData.worlds[0].id);

  const activeWorld = worldsData.worlds.find(w => w.id === activeWorldId) || worldsData.worlds[0];

  return (
    <section id="worlds" className="relative py-28 bg-parchment-light border-t border-sandstone-dark/20 overflow-hidden">
      {/* Background Ambience */}
      <div className="absolute top-1/4 -right-32 w-96 h-96 bg-sandstone/20 rounded-full blur-3xl pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        
        {/* Section Header */}
        <div className="flex flex-col md:flex-row md:items-end justify-between mb-16 pb-6 border-b border-sandstone-dark/30 gap-6">
          <div>
            <h2 className="text-3xl sm:text-4xl md:text-5xl font-cinzel font-semibold text-deepBrown tracking-wide">
              {worldsData.heading}
            </h2>
          </div>
          <p className="text-sm sm:text-base text-deepBrown/80 font-sans max-w-md font-normal leading-relaxed">
            {worldsData.subtitle}
          </p>
        </div>

        {/* World Chapter Cards (Interactive Horizontal Stack) */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
          {worldsData.worlds.map((world, idx) => {
            const isSelected = world.id === activeWorldId;
            return (
              <div
                key={world.id}
                onClick={() => setActiveWorldId(world.id)}
                className={`p-6 sm:p-8 cursor-pointer border-[1.5px] transition-all duration-300 relative flex flex-col justify-between ${
                  isSelected
                    ? 'bg-parchment border-terracotta shadow-plaque -translate-y-2'
                    : 'bg-parchment-light border-deepBrown/15 hover:border-sandstone-dark hover:bg-parchment/60'
                }`}
              >
                <div>
                  {/* Era & Chapter Tag */}
                  <div className="flex items-center justify-between mb-6 pb-3 border-b border-deepBrown/10">
                    <span className="text-[13px] font-mono font-bold text-terracotta">
                      CHAPTER 0{idx + 1}
                    </span>
                    <span className="text-xs font-mono tracking-wider uppercase text-deepBrown/70 font-semibold">
                      {world.era}
                    </span>
                  </div>

                  {/* World Name */}
                  <h3 className="text-2xl font-cinzel font-bold text-deepBrown mb-3">
                    {world.name}
                  </h3>

                  <p className="text-sm text-deepBrown/85 font-sans leading-relaxed mb-6 line-clamp-3">
                    {world.lore}
                  </p>
                </div>

                <div>
                  {/* Core Mechanics Preview */}
                  <div className="flex flex-wrap gap-2 mb-6">
                    {world.mechanics.map((mech, i) => (
                      <span 
                        key={i}
                        className="text-xs font-mono font-medium px-2.5 py-1 bg-parchment-light border border-deepBrown/15 text-deepBrown/90"
                      >
                        {mech}
                      </span>
                    ))}
                  </div>

                  <div className="pt-3 border-t border-deepBrown/10 flex items-center justify-between text-sm font-mono text-terracotta font-bold">
                    <span>{isSelected ? 'ACTIVE CHAPTER' : 'INSPECT CHAPTER'}</span>
                    <ArrowRight className="w-4 h-4" />
                  </div>
                </div>

                {isSelected && (
                  <div className="absolute -bottom-[2px] left-0 right-0 h-[3px] bg-terracotta" />
                )}
              </div>
            );
          })}
        </div>

        {/* Selected Chapter In-Depth Focus Box (Full Width, No Side Box) */}
        <div className="bg-parchment border-[1.5px] border-sandstone-dark p-8 sm:p-12 shadow-plaque mb-16 relative overflow-hidden">
          {/* Corner brackets */}
          <span className="absolute top-2.5 left-2.5 text-xs text-deepBrown/40 font-mono">✦</span>
          <span className="absolute top-2.5 right-2.5 text-xs text-deepBrown/40 font-mono">✦</span>
          <span className="absolute bottom-2.5 left-2.5 text-xs text-deepBrown/40 font-mono">✦</span>
          <span className="absolute bottom-2.5 right-2.5 text-xs text-deepBrown/40 font-mono">✦</span>

          <div>
            <div className="flex flex-wrap items-center gap-4 text-sm font-mono text-deepBrown/80 mb-3">
              <span className="flex items-center gap-1.5 text-terracotta font-bold">
                <MapPin className="w-4 h-4" />
                {activeWorld.location}
              </span>
              <span>•</span>
              <span className="flex items-center gap-1.5 font-semibold">
                <Calendar className="w-4 h-4" />
                {activeWorld.era}
              </span>
            </div>

            <h4 className="text-2xl sm:text-3xl font-cinzel font-bold text-deepBrown mb-4">
              {activeWorld.name} — {activeWorld.subtitle}
            </h4>

            <p className="text-lg sm:text-[20px] font-cormorant text-deepBrown leading-relaxed mb-6 tracking-wide max-w-5xl font-medium">
              {activeWorld.lore}
            </p>

            <div className="p-4 bg-parchment-light border-l-2 border-terracotta text-sm font-sans text-deepBrown/90 max-w-3xl leading-relaxed">
              <span className="font-bold text-deepBrown block mb-1">Atmospheric Setting:</span>
              {activeWorld.atmosphere}
            </div>
          </div>
        </div>

        {/* Future Expansions Banner */}
        <div className="p-6 sm:p-8 bg-parchment border border-dashed border-sandstone-dark flex flex-col md:flex-row items-center justify-between gap-6">
          <div>
            <span className="text-base font-cinzel font-bold text-deepBrown block mb-1">
              + More Worlds to Come
            </span>
            <p className="text-sm text-deepBrown/80 font-sans">
              Ellora Caves (Rock-Cut Marvels) • Tanjavur Brihadisvara (Chola Hydrology) • Lothal Dockyard (Ancient Maritime)
            </p>
          </div>

          <span className="text-xs sm:text-sm font-mono uppercase tracking-widest text-terracotta font-bold px-4 py-2 bg-parchment-light border border-terracotta/30">
            CONTINUOUS HERITAGE UNIVERSE
          </span>
        </div>

      </div>
    </section>
  );
}
