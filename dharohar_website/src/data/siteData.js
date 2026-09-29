/**
 * DHAROHAR - Site Content & Copy Data
 */

export const siteData = {
  hero: {
    tagline: "A Journey Through Indian Heritage",
    subtitle: "An interactive digital educational experience transforming India's timeless knowledge systems, architectural marvels, and living cultures into playable worlds.",
    primaryCta: "BEGIN THE JOURNEY →",
    secondaryCta: "SCROLL TO EXPLORE ↓",
    heritageBadge: "✦ INTERACTIVE HERITAGE ODYSSEY ✦",
    coordinates: "28°36'N • 77°12'E",
    stats: [
      { label: "Living Worlds", value: "03+" },
      { label: "Historical Eras", value: "4500+ YRS" },
      { label: "Knowledge Systems", value: "100% PLAYABLE" }
    ]
  },

  problem: {
    tag: "01 — THE PEDAGOGICAL CHALLENGE",
    heading: "THE PROBLEM",
    largeStatement: "We know the stories. But we rarely get to live them.",
    paragraph1: "India has thousands of years of heritage, knowledge and stories — but experiencing them is still largely limited to textbooks, photographs and passive learning.",
    paragraph2: "Young audiences can read about places like Nalanda, Mohenjo-daro and Hampi, but rarely get the opportunity to step inside these worlds, interact with them and learn through experience.",
    points: [
      {
        number: "01",
        title: "PASSIVE LEARNING",
        subtitle: "Rote Memory vs. Experiential Play",
        description: "History is often presented as information to remember rather than a living, breathing world to explore, test, and understand.",
        visualTheme: "manuscript",
        accent: "border-terracotta/40",
        quote: "Memorizing dates without walking the streets creates detached facts rather than lifelong curiosity."
      },
      {
        number: "02",
        title: "LOST CONTEXT",
        subtitle: "Monuments Isolated from Systems",
        description: "Monuments, traditions and ancient knowledge can become separated from the stories, scientific frameworks, and daily life that made them meaningful.",
        visualTheme: "architecture",
        accent: "border-sandstone-dark/40",
        quote: "An ancient granary or drainage grid is an engineering marvel only when you witness it functioning."
      },
      {
        number: "03",
        title: "THE ENGAGEMENT GAP",
        subtitle: "Static Formats in a Digital Age",
        description: "Traditional heritage education struggles to create the same curiosity, agency, and tactile interaction that modern digital experiences provide.",
        visualTheme: "interactive",
        accent: "border-heritageGreen/40",
        quote: "Modern minds learn best when given agency, inquiry, and the freedom to solve contextual dilemmas."
      }
    ]
  },

  solution: {
    tag: "02 — OUR PHILOSOPHY",
    heading: "SO WE BUILT DHAROHAR.",
    largeStatement: "What if history wasn't something you studied — but something you experienced?",
    coreText: "Dharohar is an interactive educational game that transforms India's heritage into playable worlds.",
    supportingCopy: "Players explore historically inspired environments, interact with characters and objects, discover cultural and scientific knowledge, and solve challenges based on what they learn.",
    
    // Interactive 4 Stages (EXPLORE → DISCOVER → LEARN → SOLVE)
    stages: [
      {
        id: "explore",
        step: "01",
        name: "EXPLORE",
        action: "Walk through living historical worlds",
        description: "Navigate the rich 2D pixel-art environments of ancient Nalanda Mahavihara, from bustling monastery courtyards to towering stupas. Discover environmental storytelling, architectural triggers with detailed historical lore, and dynamic path navigation.",
        visualSnippet: "2D World Navigation • Architectural Stupa Triggers • Environmental Storytelling",
        badge: "Spatial Immersion"
      },
      {
        id: "discover",
        step: "02",
        name: "DISCOVER",
        action: "Engage scholars, merchants & inscriptions",
        description: "Interact with living historical characters including Merchant travelers, disciples, and Teacher Silabhadra. Inspect ancient building inscriptions, examine architectural plaques, and uncover the civilizational stories behind every monument.",
        visualSnippet: "Dynamic NPC Dialogue • Building History & Lore • Manuscript Inscriptions",
        badge: "Tactile Inquiry"
      },
      {
        id: "learn",
        step: "03",
        name: "LEARN",
        action: "Master ancient Indian knowledge systems",
        description: "Deconstruct foundational scientific and intellectual frameworks across 5 core heritage domains: Vedic Mathematics, Jyotisha (Astronomy), Ayurveda (Medicine), Tarka (Logic), and Philosophy, guided by cinematic domain cutscenes and entrance quizzes.",
        visualSnippet: "5 Heritage Knowledge Domains • Cinematic Cutscenes • Domain Quizzes",
        badge: "Deep Knowledge"
      },
      {
        id: "solve",
        step: "04",
        name: "SOLVE",
        action: "Tackle interactive intellectual challenges",
        description: "Apply your gathered wisdom in hands-on intellectual puzzles: solve number pattern calculations in Mathematics, align night-sky constellation stars in Astronomy, diagnose herbal Ayurvedic symptoms, and win dialectical philosophical debate trials.",
        visualSnippet: "Constellation Star Alignment • Ayurvedic Herbal Diagnosis • Arithmetic & Logic Puzzles",
        badge: "Applied Mastery"
      }
    ]
  },

  whyDharohar: {
    tag: "03 — WHY WE ARE DIFFERENT",
    heading: "NOT JUST ANOTHER HISTORY GAME.",
    largeStatement: "We don't want you to memorize India's heritage. We want you to experience it.",
    pillars: [
      {
        number: "01",
        title: "EXPLORE",
        tagline: "Walk through historically inspired worlds.",
        details: "Every stone, archway, and waterway is modeled according to archaeological blueprints, authentic regional topography, and period-specific masonry."
      },
      {
        number: "02",
        title: "DISCOVER",
        tagline: "Interact with people, places, objects and stories.",
        details: "Engage with citizens, decipher inscriptions, examine trade goods, and discover the human stories that animated these historical centers."
      },
      {
        number: "03",
        title: "LEARN",
        tagline: "Understand the knowledge and culture behind them.",
        details: "Uncover how ancient scholars calculated celestial movements, how civil engineers routed storm drains, and how artisans carved resonant musical pillars."
      },
      {
        number: "04",
        title: "SOLVE",
        tagline: "Use what you've discovered to overcome challenges.",
        details: "Progress is earned through genuine comprehension and problem solving, grounding educational outcomes into rewarding game mechanics."
      }
    ],
    expandingUniverse: {
      tag: "THE GROWING HERITAGE CANON",
      title: "An Expanding Universe",
      description: "Dharohar is structured as a continuous odyssey. Each season introduces a new historical era with unique architectural systems and puzzle mechanics.",
      progression: ["NALANDA", "MOHENJO-DARO", "HAMPI", "ELLORA", "TANJAVUR", "LOTHAL"]
    }
  }
};
