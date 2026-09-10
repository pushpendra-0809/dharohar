class_name StupaChallengeData
extends Node

const CHALLENGES: Dictionary = {
	"mathematics": {
		"title": "MATHEMATICS — TAPPING NUMBER TILES",
		"mechanic": "Number Tiles & Arithmetic Reasoning",
		"easy": {
			"title": "Basic Arithmetic",
			"question": "Calculate the sum:
25 + 17 = ?",
			"explanation": "25 + 17 = 42. Ancient Indian Ganita placed great emphasis on swift mental calculation (Sankalana).",
			"options": ["42", "40", "52", "32"],
			"correct": 0
		},
		"medium": {
			"title": "Number Patterns & Distractors",
			"question": "Identify the missing number in the sequence:
2, 4, 6, [ ? ], 10",
			"explanation": "The pattern adds +2 at each step (Samantara Sreni / Arithmetic progression). 6 + 2 = 8.",
			"options": ["8", "7", "9", "12"],
			"correct": 0
		},
		"hard": {
			"title": "Multi-Step Pattern Reasoning",
			"question": "Examine the sequence: 3, 7, 15, 31, [ ? ]
Rule: Each term is (Previous × 2) + 1.
What is the next term?",
			"explanation": "Multi-step reasoning: (31 × 2) + 1 = 62 + 1 = 63. Ancient mathematicians like Pingala and Aryabhata analyzed exponential sequences.",
			"options": ["63", "59", "61", "65"],
			"correct": 0
		}
	},
	"astronomy": {
		"title": "ASTRONOMY — SHADOW OF THE SUN",
		"mechanic": "Sun → Shadow → Time → Observation → Deduction",
		"easy": {
			"title": "Sun Zenith Observation",
			"question": "When the sun reaches its highest point (zenith) in the sky at Midday, how does the shadow cast by the vertical gnomon (Shanku) appear?",
			"explanation": "At solar noon, the sun is highest in the sky, producing the shortest shadow of the entire day.",
			"options": ["Shortest and centered", "Longest extending West", "Longest extending East", "No shadow at any time"],
			"correct": 0
		},
		"medium": {
			"title": "Shadow Sequence in Time",
			"question": "In ancient astronomical timekeeping (Ghati-Chhaya), what is the correct chronological sequence of shadow positions from Sunrise to Sunset?",
			"explanation": "Morning sun in East casts long shadow West → Midday sun casts shortest shadow → Afternoon sun in West casts long shadow East.",
			"options": ["Long West shadow → Short Midday shadow → Long East shadow", "Short Midday → Long West → Long East", "Long East → Short Midday → Long West", "Uniform shadow in all directions"],
			"correct": 0
		},
		"hard": {
			"title": "Deduction from Shadow Coordinates",
			"question": "A Nalanda scholar observes that a pillar's shadow points North-East and is moderately long. What time and solar position does this observation deduce?",
			"explanation": "If the shadow falls North-East, the sun must be situated in the South-West, indicating mid-afternoon (Aparahna).",
			"options": ["Mid-afternoon (Sun in South-West)", "Early Dawn (Sun in East)", "Exact Solar Noon (Sun at Zenith)", "Midnight"],
			"correct": 0
		}
	},
	"medicine": {
		"title": "MEDICINE — COMBINATION GAME",
		"mechanic": "Traditional Ayurvedic Formulations & Reasoning",
		"easy": {
			"title": "Herbal Remedy Matching",
			"question": "According to ancient classical Ayurvedic texts, which traditional herbal combination was widely documented for soothing throat irritation and respiratory congestion?",
			"explanation": "Tulsi (Holy Basil) and Ginger (Ardraka) infused with honey form a classical historical remedy for soothing cough and congestion.",
			"options": ["Tulsi & Ginger with Honey", "Castor Root & Mustard Seed", "Crushed Seashells & Lime", "Neem Bark & Bitter Gourd"],
			"correct": 0
		},
		"medium": {
			"title": "Triphala Multi-Ingredient Formulation",
			"question": "The renowned ancient rasayana formulation 'Triphala' (The Three Fruits) consists of which three medicinal ingredients?",
			"explanation": "Triphala comprises Amalaki (Emblica officinalis), Haritaki (Terminalia chebula), and Bibhitaki (Terminalia bellirica).",
			"options": ["Amalaki, Haritaki, and Bibhitaki", "Tulsi, Neem, and Ashwagandha", "Ginger, Black Pepper, and Pippali", "Brahmi, Shankhpushpi, and Shatavari"],
			"correct": 0
		},
		"hard": {
			"title": "Decoction Preparation Sequence",
			"question": "In classical Ayurvedic pharmaceutics (Bhaishajya Kalpana), what is the correct sequential method for preparing an herbal decoction (Kwatha)?",
			"explanation": "Proper traditional sequence: Clean herbs → Coarsely crush → Boil in 4-16 parts water down to 1/4 volume → Filter liquid → Add honey when cooled.",
			"options": ["Clean herbs → Coarsely crush → Boil down to 1/4 volume → Filter → Add honey", "Boil dry powder → Add cold water → Store without filtering", "Dry raw plants in sun → Mix with warm oil directly", "Crush fresh roots → Filter immediately without boiling"],
			"correct": 0
		}
	},
	"philosophy": {
		"title": "PHILOSOPHY — LOGIC TILES",
		"mechanic": "Nyaya Syllogism, Consistency & Debate Rules",
		"easy": {
			"title": "Syllogistic Deduction",
			"question": "Premise 1: All scholars at Nalanda seek truth through inquiry.\nPremise 2: Vasubandhu is a scholar at Nalanda.\nWhat valid conclusion necessarily follows?",
			"explanation": "By basic deductive inference (Anumana), if the universal premise applies to all scholars, it necessarily applies to Vasubandhu.",
			"options": ["Vasubandhu seeks truth through inquiry.", "Vasubandhu teaches only astronomy.", "All seekers of truth are teachers.", "Only Vasubandhu studies at Nalanda."],
			"correct": 0
		},
		"medium": {
			"title": "Invariable Concomitance (Vyapti)",
			"question": "In Nyaya debate: 'Where there is smoke, there is fire (as in a hearth).'\nWhen observing smoke on a distant hill, what principle validates the inference of fire?",
			"explanation": "Vyapti (Invariable Concomitance) is the unconditional, universal relationship between the sign (Hetu: smoke) and what is proven (Sadhya: fire).",
			"options": ["Invariable Concomitance (Vyapti) between smoke and fire", "The geographical elevation of the mountain", "The temperature of the morning breeze", "Personal belief without prior observation"],
			"correct": 0
		},
		"hard": {
			"title": "Identifying Contradiction (Vyaghata)",
			"question": "In a rigorous philosophical debate:\nSpeaker asserts: 'All statements whatsoever are completely false and devoid of truth.'\nWhat fatal logical fallacy does this claim suffer from?",
			"explanation": "Vyaghata (Self-Contradiction / Self-Refutation): If the statement itself is true, then by its own definition it must be false.",
			"options": ["Self-Contradiction (Vyaghata) — The statement refutes its own truth", "Circular reasoning (Chakrika) only", "Irrelevant conclusion (Arthantara)", "False cause (Asat-karyavada)"],
			"correct": 0
		}
	}
}

static func get_challenge(domain: String, difficulty: String) -> Dictionary:
	var dom = domain.to_lower()
	var diff = difficulty.to_lower()
	if CHALLENGES.has(dom) and CHALLENGES[dom].has(diff):
		return CHALLENGES[dom][diff]
	return {}
