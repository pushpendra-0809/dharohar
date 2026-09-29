import React from 'react';
import { siteConfig } from '../config/siteConfig';
import { ExternalLink } from 'lucide-react';

function LinkedInIcon({ className = "w-3.5 h-3.5" }) {
  return (
    <svg className={className} viewBox="0 0 24 24" fill="currentColor">
      <path d="M19 3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14m-.5 15.5v-5.3a3.26 3.26 0 0 0-3.26-3.26c-.85 0-1.84.52-2.28 1.3v-1.11h-2.79v8.37h2.79v-4.93c0-.77.62-1.4 1.39-1.4a1.4 1.4 0 0 1 1.4 1.4v4.93h2.75M6.46 10.9v8.37H9.2V10.9H6.46M7.83 6.45a1.67 1.67 0 0 0-1.68 1.68c0 .93.75 1.69 1.68 1.69s1.69-.76 1.69-1.69c0-.93-.76-1.68-1.69-1.68Z"/>
    </svg>
  );
}

export default function Team() {
  const { teamData } = siteConfig;

  return (
    <section id="credits" className="relative py-28 bg-parchment border-t border-sandstone-dark/20 overflow-hidden">
      {/* Background Ambience */}
      <div className="absolute top-1/2 right-0 w-96 h-96 bg-sandstone/15 rounded-full blur-[140px] pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        
        {/* Section Header */}
        <div className="max-w-3xl mb-20">
          <h2 className="text-3xl sm:text-4xl md:text-5xl font-cinzel font-semibold text-deepBrown tracking-wide mb-4">
            {teamData.heading}
          </h2>

          <p className="text-base sm:text-lg text-deepBrown/85 font-sans leading-relaxed">
            {teamData.subtitle}
          </p>
        </div>

        {/* Custom Manuscript Plaque Team Cards Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {teamData.members.map((member) => (
            <div 
              key={member.number}
              className="bg-parchment-light border-[1.5px] border-deepBrown/15 p-6 sm:p-8 flex flex-col justify-between group hover:border-gold hover:bg-parchment hover:shadow-plaque-hover transition-all duration-300 relative"
            >
              {/* Corner Architectural Bracket Accents */}
              <span className="absolute top-2 left-2 text-[10px] text-terracotta font-mono">✦</span>
              <span className="absolute top-2 right-2 text-[10px] text-terracotta font-mono">✦</span>
              <span className="absolute bottom-2 left-2 text-[10px] text-terracotta font-mono">✦</span>
              <span className="absolute bottom-2 right-2 text-[10px] text-terracotta font-mono">✦</span>

              <div>
                {/* Plaque Top Header */}
                <div className="mb-6 pb-3 border-b border-deepBrown/10">
                  <span className="text-2xl font-cormorant font-bold text-terracotta">
                    {member.number}
                  </span>
                </div>

                {/* Photo Frame */}
                <div className="relative w-full aspect-square bg-parchment/70 border border-deepBrown/15 mb-6 overflow-hidden flex items-center justify-center group-hover:border-gold/60 transition-colors">
                  {member.photoUrl ? (
                    <img 
                      src={member.photoUrl} 
                      alt={member.name}
                      className="w-full h-full object-contain"
                    />
                  ) : (
                    <div className="flex flex-col items-center justify-center text-center p-6 w-full h-full bg-gradient-to-b from-parchment-light to-parchment">
                      <div className="w-16 h-16 border-[1.5px] border-terracotta/40 flex items-center justify-center bg-parchment mb-2 group-hover:scale-105 group-hover:border-terracotta transition-all shadow-sm">
                        <span className="font-cinzel text-lg font-bold text-terracotta">
                          {member.initials}
                        </span>
                      </div>
                    </div>
                  )}
                </div>

                {/* Name & Role */}
                <div className="mb-4">
                  <h3 className="text-xl font-cinzel font-bold text-deepBrown group-hover:text-terracotta transition-colors mb-1">
                    {member.name}
                  </h3>
                  <p className="text-sm uppercase tracking-wider font-mono text-terracotta font-bold">
                    {member.role}
                  </p>
                </div>

                <p className="text-sm text-deepBrown/85 font-sans leading-relaxed mb-6 font-normal">
                  {member.bio}
                </p>
              </div>

              {/* LinkedIn Connect Button */}
              <div className="pt-4 border-t border-deepBrown/10">
                <a
                  href={member.linkedinUrl || "#"}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="w-full inline-flex items-center justify-center gap-2 py-2.5 px-4 bg-parchment hover:bg-[#0077B5]/10 text-deepBrown hover:text-[#0077B5] text-xs sm:text-sm font-sans font-semibold tracking-wider uppercase border border-deepBrown/20 hover:border-[#0077B5]/60 transition-all duration-300 group/btn"
                >
                  <LinkedInIcon className="w-4 h-4 text-[#0077B5] group-hover/btn:scale-110 transition-transform" />
                  <span>Connect on LinkedIn</span>
                  <ExternalLink className="w-4 h-4 text-deepBrown/50 group-hover/btn:text-[#0077B5] ml-auto" />
                </a>
              </div>

            </div>
          ))}
        </div>

      </div>
    </section>
  );
}
