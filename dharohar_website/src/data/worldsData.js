/**
 * DHAROHAR - Heritage Worlds Data
 */

export const worldsData = {
  heading: "WORLDS OF DHAROHAR",
  tag: "EXPANDING INTERACTIVE CHAPTERS",
  subtitle: "Each world is an authentic spatial chapter of India's civilizational journey.",
  worlds: [
    {
      id: "nalanda",
      name: "NALANDA",
      subtitle: "Ancient Knowledge & Scholastic Life",
      era: "5th — 12th Century CE",
      location: "Bihar (Ancient Magadha)",
      lore: "Step into one of humanity's first premier residential universities. Walk through the great multi-storey Dharmaganja library, decipher birch-bark manuscripts, and engage in scholastic debates across mathematics, astronomy, grammar, and philosophy.",
      atmosphere: "Sunlit brick viharas, meditation courtyards, library scrolls, debate chambers",
      mechanics: ["Manuscript Deciphering", "Astronomical Calculations", "Philosophical Inquiry"],
      palette: {
        badge: "bg-terracotta/15 text-terracotta border-terracotta/30",
        border: "border-terracotta/40",
        accent: "text-terracotta"
      },
      imagePlaceholder: "https://images.unsplash.com/photo-1600100397608-f010f443b77a?q=80&w=1200&auto=format&fit=crop"
    },
    {
      id: "hampi",
      name: "HAMPI",
      subtitle: "Vijayanagara Heritage & Monolithic Art",
      era: "14th — 16th Century CE",
      location: "Tungabhadra Basin, Karnataka",
      lore: "Climb through granite boulder landscapes into the grand jewel of medieval global trade. Explore the riverside international gemstone bazaars, marvel at monolithic stone chariots, and decode the musical resonance of carved temple pillars.",
      atmosphere: "Golden hour sunset over boulder hills, riverside stone ghats, royal pavilions",
      mechanics: ["Acoustic Pillar Resonance", "Royal Aqueduct Engineering", "Bazaar Currency Trading"],
      palette: {
        badge: "bg-gold/15 text-gold-dark border-gold/30",
        border: "border-gold/40",
        accent: "text-gold"
      },
      imagePlaceholder: "https://images.unsplash.com/photo-1609137144813-7d9921338f24?q=80&w=1200&auto=format&fit=crop"
    },
    {
      id: "mohenjo-daro",
      name: "MOHENJO-DARO",
      subtitle: "Ancient Civilization & Urban Engineering",
      era: "c. 2500 BCE",
      location: "Indus River Valley",
      lore: "Traverse the earliest planned urban civilization on Earth. Navigate baked-brick orthogonal avenues, inspect the Great Bath's hydraulic seals, investigate subterranean covered drainage grids, and trade with steatite animal seal amulets.",
      atmosphere: "Morning river mist, clay-brick citadels, terracotta kilns, bustling grain wharves",
      mechanics: ["Hydraulic Canal Routing", "Standardized Weights & Measures", "Seal Carving"],
      palette: {
        badge: "bg-sandstone-dark/15 text-sandstone-dark border-sandstone-dark/30",
        border: "border-sandstone-dark/40",
        accent: "text-sandstone-dark"
      },
      imagePlaceholder: "https://images.unsplash.com/photo-1590059390046-586b0394c8e7?q=80&w=1200&auto=format&fit=crop"
    }
  ],
  futureWorlds: [
    { name: "ELLORA CAVES", era: "6th-10th Cent. CE", highlight: "Monolithic Rock-Cut Architecture" },
    { name: "TANJAVUR BRIHADISVARA", era: "11th Cent. CE", highlight: "Chola Temple Engineering & Bronze Craft" },
    { name: "LOTHAL DOCKYARD", era: "2400 BCE", highlight: "World's Oldest Tidal Port & Maritime Trade" }
  ]
};
