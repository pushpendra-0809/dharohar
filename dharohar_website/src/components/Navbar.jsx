import React, { useState, useEffect } from 'react';
import { siteConfig } from '../config/siteConfig';
import { Menu, X, Download, Compass, ChevronRight } from 'lucide-react';
import logoImg from '../assets/logo.png';
import HeritageButton from './HeritageButton';

export default function Navbar({ onOpenDownloadModal }) {
  const [isScrolled, setIsScrolled] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 30);
    };

    window.addEventListener('scroll', handleScroll, { passive: true });
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <header 
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        isScrolled 
          ? 'bg-parchment/95 backdrop-blur-md border-b border-sandstone-dark/40 py-3 shadow-md' 
          : 'bg-parchment/85 backdrop-blur-md py-4 border-b border-sandstone-dark/30 shadow-sm'
      }`}
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between">
          
          {/* Brand Logo Anchor */}
          <a 
            href="#" 
            className="flex items-center gap-3 group focus:outline-none"
            aria-label="DHAROHAR Home"
          >
            <div className="h-10 sm:h-12 flex items-center">
              <img 
                src={logoImg} 
                alt="DHAROHAR" 
                className="h-full w-auto object-contain transition-transform duration-300 group-hover:scale-105 filter drop-shadow-sm" 
              />
            </div>
            <div className="hidden lg:block border-l border-sandstone-dark/40 pl-3">
              <span className="text-[12px] tracking-[0.2em] uppercase text-deepBrown font-bold font-mono">
                Interactive Heritage
              </span>
            </div>
          </a>

          {/* Desktop Navigation Links - Uniform Heritage Buttons (Highlight on Hover) */}
          <nav className="hidden md:flex items-center gap-2.5" aria-label="Main Navigation">
            {siteConfig.navigation.map((item) => (
              <a
                key={item.label}
                href={item.href}
                className="text-[13px] uppercase tracking-[0.14em] font-sans font-bold px-4 py-2 bg-parchment-light/90 text-deepBrown border-[1.5px] border-sandstone-dark/60 hover:bg-terracotta hover:border-terracotta hover:text-ivory shadow-[2px_2px_0px_rgba(53,38,29,0.12)] hover:shadow-[3px_3px_0px_#35261D] hover:-translate-y-0.5 active:translate-y-0 active:shadow-none transition-all duration-200 select-none"
              >
                {item.label}
              </a>
            ))}
          </nav>

          {/* Right Action: Download Game -> Triggers Coming Soon Modal */}
          <div className="hidden md:flex items-center gap-3">
            <HeritageButton 
              onClick={onOpenDownloadModal}
              variant="terracotta"
              icon="download"
              className="py-2.5 px-5 text-[13px]"
            >
              Download Game
            </HeritageButton>
          </div>

          {/* Mobile Menu Toggle */}
          <div className="flex md:hidden items-center gap-3">
            <button
              onClick={onOpenDownloadModal}
              className="px-3.5 py-2 bg-terracotta text-ivory text-[12px] font-bold uppercase tracking-wider border border-sandstone-dark shadow-[2px_2px_0px_#35261D] cursor-pointer"
            >
              Download
            </button>
            <button
              onClick={() => setMobileOpen(!mobileOpen)}
              className="p-2 text-deepBrown hover:text-terracotta focus:outline-none"
              aria-label="Toggle navigation"
            >
              {mobileOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>

        </div>
      </div>

      {/* Mobile Drawer */}
      {mobileOpen && (
        <div className="md:hidden bg-parchment-light border-b border-sandstone-dark/30 px-6 py-6 shadow-xl animate-fadeIn">
          <nav className="flex flex-col space-y-2.5">
            {siteConfig.navigation.map((item) => (
              <a
                key={item.label}
                href={item.href}
                onClick={() => setMobileOpen(false)}
                className="flex items-center justify-between p-3.5 text-[15px] uppercase tracking-[0.12em] font-sans font-bold bg-parchment text-deepBrown border-[1.5px] border-sandstone-dark/40 hover:border-terracotta hover:bg-terracotta hover:text-ivory transition-all group"
              >
                <span>{item.label}</span>
                <ChevronRight className="w-4 h-4 text-terracotta group-hover:text-ivory transition-colors" />
              </a>
            ))}
            <div className="pt-3">
              <HeritageButton
                onClick={() => {
                  setMobileOpen(false);
                  if (onOpenDownloadModal) onOpenDownloadModal();
                }}
                variant="terracotta"
                icon="download"
                className="w-full text-[14px]"
              >
                Download Complete Game
              </HeritageButton>
            </div>
          </nav>
        </div>
      )}
    </header>
  );
}
