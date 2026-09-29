/**
 * DHAROHAR - Master Site Configuration
 * 
 * Central hub for global URLs, endpoints, and branding toggles.
 * Modify values here to update the entire experience.
 */

import { siteData } from '../data/siteData';
import { worldsData } from '../data/worldsData';
import { teamData } from '../data/teamData';

export const siteConfig = {
  // Brand Identity
  siteName: "DHAROHAR",
  tagline: "A Journey Through Indian Heritage",
  metaDescription: "An interactive educational game transforming India's heritage into playable worlds.",

  // Game Endpoints (Easily configurable single-point variables)
  gameDownloadUrl: "#", // Replace with real download URL (e.g. Google Drive, itch.io, steam)
  gameEmbedUrl: "/game/index.html",     // Godot Web build served from public/game/index.html

  // Navigation Links
  navigation: [
    { label: "ABOUT", href: "#about" },
    { label: "WORLDS", href: "#worlds" },
    { label: "EXPERIENCE", href: "#experience" },
    { label: "CREDITS", href: "#credits" }
  ],

  // Footer Config
  footer: {
    motto: "EXPLORE • DISCOVER • LEARN • SOLVE",
    copyright: "© DHAROHAR. All rights reserved.",
    disclaimer: "Crafted with dedication to preserve, celebrate, and interactively share India's timeless heritage."
  },

  // Linked Modular Data
  siteData,
  worldsData,
  teamData
};
