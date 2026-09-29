import React, { useState } from 'react';
import { siteConfig } from '../config/siteConfig';
import { HeritageDivider } from './HeritageMotif';

export default function Problem() {
  const { problem } = siteConfig.siteData;
  const [activePointIndex, setActivePointIndex] = useState(0);

  // Curated descriptive representations with bold keywords & literary typography
  const visualRepresentations = [
    {
      title: "Passive Rote Learning vs Experiential Inquiry",
      detail: (
        <>
          In standard curricula, centuries of profound Indian scientific and philosophical accomplishments are compressed into <strong className="font-bold text-deepBrown">flat paragraphs and static timelines</strong>. Students are conditioned to <strong className="font-bold text-deepBrown">memorize isolated dates and dynasties</strong> for examinations rather than experiencing history as a <strong className="font-bold text-deepBrown">living, investigative laboratory</strong> where knowledge was actively debated, tested, and applied across civilization.
        </>
      ),
      color: "from-terracotta/10 to-sandstone/20",
      border: "border-terracotta/40",
      quote: "Students memorize lists of dynastic dates rather than understanding the living systems of inquiry that sustained them."
    },
    {
      title: "Isolated Monuments & Decontextualized Heritage",
      detail: (
        <>
          Ancient architectural marvels, astronomical observatories, and foundational Ayurvedic traditions are frequently presented in <strong className="font-bold text-deepBrown">isolation from their original intellectual ecosystems</strong>. Without understanding the societal context, mathematical treatises, and daily debates that shaped them, magnificent stupas and manuscripts risk being perceived as <strong className="font-bold text-deepBrown">inert stone ruins</strong> rather than <strong className="font-bold text-deepBrown">thriving hubs of civilization</strong>.
        </>
      ),
      color: "from-sandstone-dark/15 to-parchment-dark",
      border: "border-sandstone-dark/50",
      quote: "When architecture is detached from its living scholars and philosophy, heritage becomes inert stone."
    },
    {
      title: "The Generational Engagement Gap",
      detail: (
        <>
          Modern digital learners thrive through <strong className="font-bold text-deepBrown">agency, interactive deduction, and visual storytelling</strong>. Traditional static textbooks struggle to spark the genuine curiosity and tactile problem-solving required to master complex heritage disciplines like <strong className="font-bold text-deepBrown">Vedic geometry, star alignment, and ethical dialectics</strong>, leaving young learners disconnected from their civilizational roots.
        </>
      ),
      color: "from-heritageGreen/10 to-sandstone/20",
      border: "border-heritageGreen/40",
      quote: "Engaging the digital generation requires stepping into history not as a passive observer, but as an active participant."
    }
  ];

  return (
    <section id="about" className="relative py-28 bg-parchment-light border-t border-sandstone-dark/20 overflow-hidden">
      {/* Background Ambience */}
      <div className="absolute top-1/2 -left-32 w-80 h-80 bg-terracotta/5 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute bottom-10 -right-32 w-80 h-80 bg-gold/10 rounded-full blur-3xl pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        
        {/* Editorial Section Header */}
        <div className="max-w-4xl mb-20">
          <h2 className="text-3xl sm:text-4xl md:text-5xl font-cinzel font-semibold text-deepBrown tracking-wide mb-6">
            {problem.heading}
          </h2>

          <p className="text-2xl sm:text-3xl md:text-4xl font-cormorant italic text-terracotta font-normal leading-snug mb-8">
            "{problem.largeStatement}"
          </p>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-8 text-base sm:text-lg text-deepBrown/90 font-sans leading-relaxed border-l-2 border-terracotta pl-6">
            <p>{problem.paragraph1}</p>
            <p>{problem.paragraph2}</p>
          </div>
        </div>

        {/* Interactive Layout: 3 Points on Left + Dynamic Visual Plate on Right */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-stretch">
          
          {/* Left: 3 Numbered Interactive Sections */}
          <div className="lg:col-span-7 flex flex-col space-y-4">
            {problem.points.map((point, index) => {
              const isActive = activePointIndex === index;
              return (
                <div
                  key={point.number}
                  onMouseEnter={() => setActivePointIndex(index)}
                  onClick={() => setActivePointIndex(index)}
                  className={`p-6 sm:p-8 cursor-pointer transition-all duration-300 border-[1.5px] relative ${
                    isActive
                      ? 'bg-parchment border-terracotta shadow-plaque translate-x-1 sm:translate-x-2'
                      : 'bg-parchment-light/80 border-deepBrown/10 hover:border-sandstone-dark/50 hover:bg-parchment/50'
                  }`}
                >
                  {/* Point Number */}
                  <div className="mb-3">
                    <span className={`text-2xl sm:text-3xl font-cormorant font-bold transition-colors ${
                      isActive ? 'text-terracotta' : 'text-deepBrown/40'
                    }`}>
                      {point.number}
                    </span>
                  </div>

                  {/* Title & Description */}
                  <h3 className={`text-lg sm:text-xl font-cinzel font-semibold tracking-wider mb-2.5 transition-colors ${
                    isActive ? 'text-deepBrown' : 'text-deepBrown/80'
                  }`}>
                    {point.title}
                  </h3>

                  <p className="text-sm sm:text-base text-deepBrown/85 font-sans leading-relaxed font-normal">
                    {point.description}
                  </p>

                  {/* Active bottom marker */}
                  {isActive && (
                    <div className="absolute -bottom-[1px] left-0 right-0 h-[2px] bg-terracotta" />
                  )}
                </div>
              );
            })}
          </div>

          {/* Right: Dynamic Interactive Visual Plate with Larger Literary Font & Bold Keywords */}
          <div className="lg:col-span-5 flex">
            <div className={`w-full p-8 sm:p-10 bg-gradient-to-br ${visualRepresentations[activePointIndex].color} border-[1.5px] ${visualRepresentations[activePointIndex].border} flex flex-col justify-between shadow-plaque transition-all duration-500 relative overflow-hidden`}>
              
              {/* Corner brackets */}
              <span className="absolute top-2 left-2 text-xs text-deepBrown/40 font-mono">✦</span>
              <span className="absolute top-2 right-2 text-xs text-deepBrown/40 font-mono">✦</span>
              <span className="absolute bottom-2 left-2 text-xs text-deepBrown/40 font-mono">✦</span>
              <span className="absolute bottom-2 right-2 text-xs text-deepBrown/40 font-mono">✦</span>

              <div>
                <h4 className="text-2xl sm:text-3xl font-cinzel font-bold text-deepBrown mb-5 pt-1 leading-tight">
                  {visualRepresentations[activePointIndex].title}
                </h4>

                {/* Larger Literary Manuscript Prose with Clean Bold Keywords */}
                <p className="text-lg sm:text-[20px] font-cormorant text-deepBrown leading-relaxed mb-8 tracking-wide font-medium">
                  {visualRepresentations[activePointIndex].detail}
                </p>
              </div>

              {/* Curated Contextual Quote Box */}
              <div className="p-5 bg-parchment/90 border-l-2 border-terracotta shadow-sm">
                <p className="text-base sm:text-lg font-cormorant italic text-deepBrown leading-relaxed">
                  "{visualRepresentations[activePointIndex].quote}"
                </p>
              </div>

            </div>
          </div>

        </div>

      </div>
    </section>
  );
}
