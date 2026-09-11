class_name StupaChallengeData
extends Node

const DOMAIN_INFO: Dictionary = {
	"mathematics": {
		"name": "Mathematics",
		"hindi_name": "Ganita (Mathematics)",
		"title": "MATHEMATICS — NUMBER STREAM",
		"mechanic": "Piano-Tiles-inspired Number Sequence Concentration",
		"symbol": "✦ 1 2 3 ✦",
		"description": "Swift visual recognition and rhythm: tap numbered stones in exact sequence."
	},
	"medicine": {
		"name": "Medicine",
		"hindi_name": "Ayurveda (Medicine)",
		"title": "MEDICINE — AYURVEDIC HERB HARMONY",
		"mechanic": "Mahjong-inspired Botanical Herb Matching",
		"symbol": "🌿 🍈 🍃",
		"description": "Focused memory and botanical classification: match sacred herbal pairs."
	},
	"astronomy": {
		"name": "Astronomy",
		"hindi_name": "Khagola (Astronomy)",
		"title": "ASTRONOMY — CELESTIAL PATTERNS",
		"mechanic": "Mahjong-inspired Celestial Observation & Symmetry",
		"symbol": "☀️ 🌙 🌟",
		"description": "Pattern recognition and sky-mapping: identify planetary and nakshatra alignments."
	},
	"philosophy": {
		"name": "Philosophy",
		"hindi_name": "Nyaya (Logic & Epistemology)",
		"title": "PHILOSOPHY — NYAYA LOGIC TILES",
		"mechanic": "Deductive Syllogism Sequence Construction & Fallacy Rejection",
		"symbol": "📜 ⚖️ 💡",
		"description": "Critical thinking: assemble valid 5-limbed logical syllogisms and discard fallacies."
	}
}

# --- HERB DEFINITIONS FOR MEDICINE ---
const HERBS: Dictionary = {
	"tulsi": {
		"id": "tulsi",
		"name": "Tulsi",
		"sub": "Holy Basil",
		"icon": "🌿",
		"color": Color(0.25, 0.7, 0.35),
		"desc": "Sacred respiratory herb"
	},
	"amla": {
		"id": "amla",
		"name": "Amla",
		"sub": "Gooseberry",
		"icon": "🍈",
		"color": Color(0.55, 0.75, 0.25),
		"desc": "Rasayana for vitality"
	},
	"neem": {
		"id": "neem",
		"name": "Neem",
		"sub": "Margosa",
		"icon": "🍃",
		"color": Color(0.2, 0.65, 0.3),
		"desc": "Purifying bitter leaf"
	},
	"ginger": {
		"id": "ginger",
		"name": "Ardraka",
		"sub": "Ginger",
		"icon": "🫚",
		"color": Color(0.85, 0.6, 0.25),
		"desc": "Digestive fire stimulant"
	},
	"turmeric": {
		"id": "turmeric",
		"name": "Haridra",
		"sub": "Turmeric",
		"icon": "✨",
		"color": Color(0.95, 0.75, 0.15),
		"desc": "Golden healing rhizome"
	},
	"ashoka": {
		"id": "ashoka",
		"name": "Ashoka",
		"sub": "Sacred Bark",
		"icon": "🌸",
		"color": Color(0.9, 0.45, 0.55),
		"desc": "Restorative tree essence"
	},
	"chandana": {
		"id": "chandana",
		"name": "Chandana",
		"sub": "Sandalwood",
		"icon": "🪵",
		"color": Color(0.8, 0.55, 0.35),
		"desc": "Cooling heartwood"
	},
	"guduchi": {
		"id": "guduchi",
		"name": "Guduchi",
		"sub": "Amrita Vine",
		"icon": "🌱",
		"color": Color(0.3, 0.8, 0.45),
		"desc": "Immunity enhancer"
	},
	"haritaki": {
		"id": "haritaki",
		"name": "Haritaki",
		"sub": "Triphala 1",
		"icon": "🌰",
		"color": Color(0.65, 0.45, 0.25),
		"desc": "Chief of the three fruits"
	},
	"bibhitaki": {
		"id": "bibhitaki",
		"name": "Bibhitaki",
		"sub": "Triphala 2",
		"icon": "🌾",
		"color": Color(0.75, 0.65, 0.35),
		"desc": "Astringent rejuvenation"
	},
	"brahmi": {
		"id": "brahmi",
		"name": "Brahmi",
		"sub": "Memory Herb",
		"icon": "🍀",
		"color": Color(0.35, 0.75, 0.5),
		"desc": "Intellect & calm"
	},
	"pippali": {
		"id": "pippali",
		"name": "Pippali",
		"sub": "Long Pepper",
		"icon": "🌶️",
		"color": Color(0.7, 0.3, 0.25),
		"desc": "Deep bio-enhancer"
	}
}

# --- CELESTIAL DEFINITIONS FOR ASTRONOMY ---
const CELESTIALS: Dictionary = {
	"surya": {
		"id": "surya",
		"name": "Surya",
		"sub": "The Sun",
		"icon": "☀️",
		"color": Color(1.0, 0.8, 0.2),
		"desc": "Center of solar time"
	},
	"chandra": {
		"id": "chandra",
		"name": "Chandra",
		"sub": "The Moon",
		"icon": "🌙",
		"color": Color(0.85, 0.9, 1.0),
		"desc": "Ruler of lunar tithis"
	},
	"brihaspati": {
		"id": "brihaspati",
		"name": "Brihaspati",
		"sub": "Jupiter",
		"icon": "🪐",
		"color": Color(0.9, 0.65, 0.4),
		"desc": "Guru of planetary orbits"
	},
	"shukra": {
		"id": "shukra",
		"name": "Shukra",
		"sub": "Venus",
		"icon": "✨",
		"color": Color(1.0, 0.95, 0.6),
		"desc": "Bright dawn harbinger"
	},
	"mangala": {
		"id": "mangala",
		"name": "Mangala",
		"sub": "Mars",
		"icon": "🔴",
		"color": Color(0.95, 0.35, 0.25),
		"desc": "Red celestial traveler"
	},
	"shani": {
		"id": "shani",
		"name": "Shani",
		"sub": "Saturn",
		"icon": "⭐",
		"color": Color(0.75, 0.7, 0.5),
		"desc": "Distant celestial guardian"
	},
	"rohini": {
		"id": "rohini",
		"name": "Rohini",
		"sub": "Red Nakshatra",
		"icon": "🌟",
		"color": Color(1.0, 0.45, 0.35),
		"desc": "Bright lunar mansion"
	},
	"ashwini": {
		"id": "ashwini",
		"name": "Ashwini",
		"sub": "1st Mansion",
		"icon": "💫",
		"color": Color(0.4, 0.85, 0.95),
		"desc": "Pioneering star cluster"
	},
	"magha": {
		"id": "magha",
		"name": "Magha",
		"sub": "Regulus",
		"icon": "👑",
		"color": Color(0.95, 0.85, 0.3),
		"desc": "Royal cosmic throne"
	},
	"dhruva": {
		"id": "dhruva",
		"name": "Dhruva",
		"sub": "North Star",
		"icon": "🧭",
		"color": Color(0.5, 0.9, 1.0),
		"desc": "Unmoving cosmic pivot"
	},
	"shanku": {
		"id": "shanku",
		"name": "Shanku",
		"sub": "Gnomon",
		"icon": "📐",
		"color": Color(0.85, 0.6, 0.3),
		"desc": "Shadow astronomical pillar"
	},
	"mandala": {
		"id": "mandala",
		"name": "Mandala",
		"sub": "Zodiac Sphere",
		"icon": "🌌",
		"color": Color(0.65, 0.45, 0.9),
		"desc": "Harmonic 27-star cosmos"
	}
}

# --- CHALLENGE DATA BY DOMAIN AND LEVEL ---
const CHALLENGES: Dictionary = {
	"mathematics": {
		"1": {
			"level": 1,
			"title": "LEVEL 1 — ASCENDING NUMBER TILES",
			"instruction": "Tap the falling stone tiles in exact order: 1 → 2 → 3 → 4 → 5.",
			"target_sequence": [1, 2, 3, 4, 5],
			"speed": 135.0,
			"spawn_rate": 1.3,
			"distractor_chance": 0.15,
			"distractor_pool": [6, 7, 8, 9]
		},
		"2": {
			"level": 2,
			"title": "LEVEL 2 — EXTENDED TILES & DISTRACTORS",
			"instruction": "Maintain focus! Tap numbers in order: 1 → 2 → 3 → 4 → 5 → 6 → 7. Avoid false stones.",
			"target_sequence": [1, 2, 3, 4, 5, 6, 7],
			"speed": 185.0,
			"spawn_rate": 0.95,
			"distractor_chance": 0.35,
			"distractor_pool": [0, 8, 9, 11, 13]
		},
		"3": {
			"level": 3,
			"title": "LEVEL 3 — MASTER NUMBER STREAM",
			"instruction": "Peak concentration! Tap the full 1 → 9 stream amidst rapid decoy stones.",
			"target_sequence": [1, 2, 3, 4, 5, 6, 7, 8, 9],
			"speed": 240.0,
			"spawn_rate": 0.72,
			"distractor_chance": 0.45,
			"distractor_pool": [0, 11, 12, 14, 15, 18, 20]
		}
	},
	"medicine": {
		"1": {
			"level": 1,
			"title": "LEVEL 1 — AYURVEDIC BOTANICAL PAIRS (4×4 Grid)",
			"instruction": "Concentrate! Memorize the 16 tiles during the 3-second preview, then match all 8 pairs.",
			"grid_columns": 4,
			"grid_rows": 4,
			"pairs_needed": 8,
			"preview_time": 3.0,
			"herb_keys": ["tulsi", "amla", "neem", "ginger", "turmeric", "ashoka", "chandana", "guduchi"]
		},
		"2": {
			"level": 2,
			"title": "LEVEL 2 — TEN HERB HARMONY (4×5 Grid)",
			"instruction": "Maintain focus! Memorize the 20 tiles during the 2-second preview, then match all 10 pairs.",
			"grid_columns": 5,
			"grid_rows": 4,
			"pairs_needed": 10,
			"preview_time": 2.0,
			"herb_keys": ["tulsi", "amla", "neem", "ginger", "turmeric", "ashoka", "chandana", "guduchi", "haritaki", "bibhitaki"]
		},
		"3": {
			"level": 3,
			"title": "LEVEL 3 — TRIPHALA & RASAYANA MASTERY (4×6 Grid)",
			"instruction": "Peak concentration! Memorize the 24 tiles during the 1-second preview, then match all 12 pairs.",
			"grid_columns": 6,
			"grid_rows": 4,
			"pairs_needed": 12,
			"preview_time": 1.0,
			"herb_keys": ["tulsi", "amla", "neem", "ginger", "turmeric", "ashoka", "chandana", "guduchi", "haritaki", "bibhitaki", "brahmi", "pippali"]
		}
	},
	"astronomy": {
		"1": {
			"level": 1,
			"title": "LEVEL 1 — GRAHA OBSERVATION (4×4 Grid)",
			"instruction": "Concentrate! Memorize the 16 tiles during the 3-second preview, then match all 8 pairs.",
			"grid_columns": 4,
			"grid_rows": 4,
			"pairs_needed": 8,
			"preview_time": 3.0,
			"celestial_keys": ["surya", "chandra", "brihaspati", "shukra", "mangala", "shani", "rohini", "ashwini"]
		},
		"2": {
			"level": 2,
			"title": "LEVEL 2 — NAKSHATRA SPHERE (4×5 Grid)",
			"instruction": "Maintain focus! Memorize the 20 tiles during the 2-second preview, then match all 10 pairs.",
			"grid_columns": 5,
			"grid_rows": 4,
			"pairs_needed": 10,
			"preview_time": 2.0,
			"celestial_keys": ["surya", "chandra", "brihaspati", "shukra", "mangala", "shani", "rohini", "ashwini", "magha", "dhruva"]
		},
		"3": {
			"level": 3,
			"title": "LEVEL 3 — ARYABHATA CELESTIAL MASTERY (4×6 Grid)",
			"instruction": "Peak concentration! Memorize the 24 tiles during the 1-second preview, then match all 12 pairs.",
			"grid_columns": 6,
			"grid_rows": 4,
			"pairs_needed": 12,
			"preview_time": 1.0,
			"celestial_keys": ["surya", "chandra", "brihaspati", "shukra", "mangala", "shani", "rohini", "ashwini", "magha", "dhruva", "shanku", "mandala"]
		}
	},
	"philosophy": {
		"1": {
			"level": 1,
			"title": "LEVEL 1 — DEDUCTIVE CHAIN: PARVATA-VAHNI",
			"instruction": "Arrange the 4 statements in the exact logical sequence of Nyaya inference (Anumana).",
			"subject": "Fire on the Mountain",
			"cards": [
				{
					"id": "p1",
					"step": 1,
					"tag": "1. PRATIJNA (Claim)",
					"text": "There is fire on the mountain.",
					"is_fallacy": false
				},
				{
					"id": "p2",
					"step": 2,
					"tag": "2. HETU (Reason)",
					"text": "Because there is smoke rising from the peak.",
					"is_fallacy": false
				},
				{
					"id": "p3",
					"step": 3,
					"tag": "3. UDAHARANA (Example)",
					"text": "Wherever there is smoke, there is fire (as seen in a kitchen hearth).",
					"is_fallacy": false
				},
				{
					"id": "p4",
					"step": 4,
					"tag": "4. NIGAMANA (Conclusion)",
					"text": "Therefore, the mountain has fire.",
					"is_fallacy": false
				}
			],
			"expected_order": ["p1", "p2", "p3", "p4"],
			"fallacy_ids": []
		},
		"2": {
			"level": 2,
			"title": "LEVEL 2 — FALLACY FILTER: SHABDA-ANITYATA",
			"instruction": "Identify and discard the false statement (Hetvabhasa), then assemble the 4 valid logical steps.",
			"subject": "Impermanence of Sound",
			"cards": [
				{
					"id": "s1",
					"step": 1,
					"tag": "1. PRATIJNA (Claim)",
					"text": "Sound is impermanent (transitory).",
					"is_fallacy": false
				},
				{
					"id": "s2",
					"step": 2,
					"tag": "2. HETU (Reason)",
					"text": "Because sound is produced by an action (Kritakatva).",
					"is_fallacy": false
				},
				{
					"id": "s3",
					"step": 3,
					"tag": "3. UDAHARANA (Example)",
					"text": "Whatever is produced by action is impermanent (like a clay pot).",
					"is_fallacy": false
				},
				{
					"id": "s4",
					"step": 4,
					"tag": "4. NIGAMANA (Conclusion)",
					"text": "Therefore, sound is impermanent.",
					"is_fallacy": false
				},
				{
					"id": "f1",
					"step": -1,
					"tag": "⚠️ FALLACY (Hetvabhasa)",
					"text": "Sound is eternal because the human eye can see it.",
					"is_fallacy": true,
					"explanation": "Fallacy of Unproven Attribute (Asiddha) — Sound cannot be perceived by sight."
				}
			],
			"expected_order": ["s1", "s2", "s3", "s4"],
			"fallacy_ids": ["f1"]
		},
		"3": {
			"level": 3,
			"title": "LEVEL 3 — COMPLETE 5-LIMBED NYAYA SYLLOGISM",
			"instruction": "Discard 2 deceptive fallacies and assemble the complete 5-Limbed Syllogism (Pancha-Avayava).",
			"subject": "Quest for Truth at Nalanda",
			"cards": [
				{
					"id": "n1",
					"step": 1,
					"tag": "1. PRATIJNA (Thesis)",
					"text": "Scholars of Nalanda discover truth through disciplined inquiry.",
					"is_fallacy": false
				},
				{
					"id": "n2",
					"step": 2,
					"tag": "2. HETU (Ground)",
					"text": "Because they apply valid evidence and invariable concomitance (Vyapti).",
					"is_fallacy": false
				},
				{
					"id": "n3",
					"step": 3,
					"tag": "3. UDAHARANA (Universal Rule)",
					"text": "Where disciplined evidence guides inquiry, truth is revealed (as in the Shastrartha councils).",
					"is_fallacy": false
				},
				{
					"id": "n4",
					"step": 4,
					"tag": "4. UPANAYA (Application)",
					"text": "The scholars of Nalanda faithfully maintain this standard of reasoned evidence.",
					"is_fallacy": false
				},
				{
					"id": "n5",
					"step": 5,
					"tag": "5. NIGAMANA (Conclusion)",
					"text": "Therefore, the scholars of Nalanda discover truth through disciplined inquiry.",
					"is_fallacy": false
				},
				{
					"id": "f2",
					"step": -1,
					"tag": "⚠️ SELF-CONTRADICTION (Vyaghata)",
					"text": "All statements whatsoever are completely false and devoid of any truth.",
					"is_fallacy": true,
					"explanation": "Self-refuting claim (Vyaghata) — If true, the statement refutes itself."
				},
				{
					"id": "f3",
					"step": -1,
					"tag": "⚠️ IRRELEVANT (Arthantara)",
					"text": "Nalanda has high brick walls and tranquil lotus ponds in the courtyard.",
					"is_fallacy": true,
					"explanation": "Irrelevant observation (Arthantara) — Architecture does not form a logical premise for inquiry."
				}
			],
			"expected_order": ["n1", "n2", "n3", "n4", "n5"],
			"fallacy_ids": ["f2", "f3"]
		}
	}
}

static func get_domain_info(domain: String) -> Dictionary:
	var dom = domain.to_lower()
	return DOMAIN_INFO.get(dom, DOMAIN_INFO["mathematics"])

static func get_challenge(domain: String, level: int) -> Dictionary:
	var dom = domain.to_lower()
	var lvl_str = str(level)
	if CHALLENGES.has(dom) and CHALLENGES[dom].has(lvl_str):
		return CHALLENGES[dom][lvl_str]
	return {}
