import React from 'react';
import { siteConfig } from '../config/siteConfig';
import { ArrowUp, Download } from 'lucide-react';
import faviconImg from '../assets/fevicon_dharohar.png';
import HeritageButton from './HeritageButton';

export default function Footer({ onOpenDownloadModal }) {
  const { footer, siteName, tagline, navigation } = siteConfig;

  const scrollToTop = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <footer className="relative bg-deepBrown text-parchment-light border-t-2 border-terracotta pt-16 pb-9 overflow-hidden">
      {/* Ambient background glow */}
      <div className="absolute bottom-0 left-1/2 -translate-x-1/2 w-[700px] h-[250px] bg-terracotta/10 rounded-full blur-[140px] pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        
        {/* Top Tier */}
        <div className="grid grid-cols-1 md:grid-cols-12 gap-10 pb-12 border-b border-parchment/10 items-start">
          
          {/* Brand Col */}
          <div className="md:col-span-6 flex flex-col items-start">
            <div className="h-[56px] mb-4 inline-flex items-center">
              <img 
                src={faviconImg} 
                alt={siteName} 
                className="h-[56px] w-auto object-contain" 
              />
            </div>
            
            <p className="text-[22px] font-cormorant italic text-sandstone tracking-wide mb-3 leading-tight">
              "{tagline}"
            </p>

            <p className="text-[16px] text-parchment/75 font-sans max-w-md leading-relaxed font-light mb-5">
              {footer.disclaimer}
            </p>

            <div className="text-[15px] font-mono uppercase tracking-[0.2em] text-gold font-bold">
              {footer.motto}
            </div>
          </div>

          {/* Navigation */}
          <div className="md:col-span-3">
            <span className="text-[16px] font-mono uppercase tracking-[0.2em] text-sandstone font-bold block mb-4">
              CHRONICLES
            </span>
            <ul className="space-y-3 text-[16px] font-sans uppercase tracking-wider font-semibold">
              {navigation.map((item) => (
                <li key={item.label}>
                  <a 
                    href={item.href}
                    className="text-parchment/70 hover:text-gold transition-colors"
                  >
                    {item.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Download & Scroll to Top */}
          <div className="md:col-span-3 flex flex-col items-start md:items-end justify-between h-full">
            <div>
              <span className="text-[16px] font-mono uppercase tracking-[0.2em] text-sandstone font-bold block mb-4 md:text-right">
                OFFLINE BUILD
              </span>
              <HeritageButton
                onClick={onOpenDownloadModal}
                variant="terracotta"
                icon="download"
              >
                Download Game
              </HeritageButton>
            </div>

            <button
              onClick={scrollToTop}
              className="mt-8 md:mt-0 inline-flex items-center gap-2 text-[15px] font-mono uppercase tracking-widest text-sandstone hover:text-gold transition-colors group"
            >
              <span>RETURN TO APEX</span>
              <ArrowUp className="w-4 h-4 transition-transform group-hover:-translate-y-1" />
            </button>
          </div>

        </div>

        {/* Bottom Tier: Copyright */}
        <div className="pt-6 flex flex-col sm:flex-row items-center justify-between text-[15px] text-parchment/65 font-sans gap-4">
          <div>
            {footer.copyright}
          </div>
          <div className="text-[14px] font-mono tracking-wider uppercase text-sandstone/60">
            Interactive Digital Heritage Preservation
          </div>
        </div>

      </div>
    </footer>
  );
}
