import React, { useState, useEffect } from 'react';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import Problem from './components/Problem';
import Solution from './components/Solution';
import Worlds from './components/Worlds';
import GameDemo from './components/GameDemo';
import Team from './components/Team';
import Footer from './components/Footer';
import ComingSoonModal from './components/ComingSoonModal';
import { Analytics } from '@vercel/analytics/react';

export default function App() {
  const [downloadModalOpen, setDownloadModalOpen] = useState(false);

  const handleOpenDownloadModal = () => {
    setDownloadModalOpen(true);
  };

  useEffect(() => {
    const handleMessage = (event) => {
      if (event.data && (event.data.type === 'DHAROHAR_OPEN_DOWNLOAD_MODAL' || event.data === 'DHAROHAR_OPEN_DOWNLOAD_MODAL')) {
        setDownloadModalOpen(true);
      }
    };

    window.addEventListener('message', handleMessage);
    window.dharoharOpenDownloadModal = () => setDownloadModalOpen(true);

    return () => {
      window.removeEventListener('message', handleMessage);
      delete window.dharoharOpenDownloadModal;
    };
  }, []);

  return (
    <div className="min-h-screen bg-parchment text-deepBrown flex flex-col selection:bg-terracotta/20 selection:text-deepBrown">
      {/* Sticky Top Navigation */}
      <Navbar onOpenDownloadModal={handleOpenDownloadModal} />

      {/* Main Experiential Journey */}
      <main className="flex-grow">
        {/* HERO SECTION */}
        <Hero />

        {/* SECTION 01 — THE PROBLEM */}
        <Problem />

        {/* SECTION 02 — OUR SOLUTION & GAMEPLAY PROGRESSION */}
        <Solution />

        {/* SECTION 03 — HERITAGE WORLDS (Dedicated Chapter Gallery) */}
        <Worlds />

        {/* SECTION 04 — EXPERIENCE DHAROHAR (Game Portal) */}
        <GameDemo onOpenDownloadModal={handleOpenDownloadModal} />

        {/* SECTION 05 — THE TEAM & CREDITS */}
        <Team />
      </main>

      {/* FOOTER */}
      <Footer onOpenDownloadModal={handleOpenDownloadModal} />

      {/* COMING SOON MODAL */}
      <ComingSoonModal 
        isOpen={downloadModalOpen}
        onClose={() => setDownloadModalOpen(false)}
      />

      {/* VERCEL WEB ANALYTICS */}
      <Analytics />
    </div>
  );
}
