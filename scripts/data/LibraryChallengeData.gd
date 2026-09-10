class_name LibraryChallengeData
extends RefCounted

const CHALLENGES: Dictionary = {
	"mathematics": {
		"title": "Mathematics — Missing Manuscript Cipher",
		"description": "Reconstruct lost numbers and symbols on ancient palm-leaf mathematical treatises.",
		"easy": {
			"title": "Missing Sequence Cipher",
			"mechanic": "Arithmetic Sequence Completion",
			"question": "An ancient mathematical palm-leaf fragment records a fundamental arithmetic progression:\n\n2,  4,  6,  ?,  10\n\nWhich number completes the cipher?",
			"options": [
				"A) 7",
				"B) 8",
				"C) 9",
				"D) 12"
			],
			"correct": 1,
			"explanation": "In an arithmetic progression with a common difference of +2 (Dvicaya), the value following 6 is 6 + 2 = 8."
		},
		"medium": {
			"title": "Pattern & Clue Deduction",
			"mechanic": "Recursive Series with Distractor Clues",
			"question": "A damaged arithmetic manuscript reveals the recursive sequence:\n\n3  →  7  →  15  →  ?  →  63\n\nManuscript Clue: 'At every step, double the prior quantity and add unity (2x + 1).'\n\nWhich value restores the missing leaf?",
			"options": [
				"A) 31",
				"B) 29",
				"C) 30",
				"D) 35"
			],
			"correct": 0,
			"explanation": "Applying the recursive rule (2n + 1): 15 × 2 + 1 = 31. Verifying the next term: 31 × 2 + 1 = 63."
		},
		"hard": {
			"title": "Multi-Clue Cipher Reconstruction",
			"mechanic": "System of Number Theoretic Clues",
			"question": "Reconstruct the lost numeral 'N' from Nalanda's astronomy treatise using three palm-leaf rules:\n\n1. 'N' is between 40 and 80, and is divisible by both 6 and 8.\n2. Subtracting 12 from 'N' yields a perfect square.\n3. Dividing 'N' by 4 yields the 12 sacred months of the solar year.\n\nWhat is the value of 'N'?",
			"options": [
				"A) 48",
				"B) 72",
				"C) 56",
				"D) 64"
			],
			"correct": 0,
			"explanation": "Multiples of LCM(6,8)=24 between 40 and 80 are 48 and 72. 48 - 12 = 36 = 6² (perfect square). 48 / 4 = 12. Thus N = 48."
		}
	},
	"astronomy": {
		"title": "Astronomy — Ancient Calendar Reconstruction",
		"description": "Reconstruct ancient calendar manuscripts, seasonal cycles (Ritu Chakra), and astronomical observation records.",
		"easy": {
			"title": "Seasonal Cycle (Ritu Chakra)",
			"mechanic": "Canonical Season Sequence",
			"question": "Reconstruct the canonical chronological sequence of the Indian seasonal cycle (Ritu Chakra) starting immediately after Spring (Vasanta):",
			"options": [
				"A) Grīṣma (Summer) → Varṣā (Monsoon) → Śarat (Autumn) → Hemanta (Pre-winter)",
				"B) Varṣā (Monsoon) → Grīṣma (Summer) → Śarat (Autumn) → Śiśira (Winter)",
				"C) Śarat (Autumn) → Grīṣma (Summer) → Varṣā (Monsoon) → Hemanta (Pre-winter)",
				"D) Hemanta (Pre-winter) → Śiśira (Winter) → Grīṣma (Summer) → Varṣā (Monsoon)"
			],
			"correct": 0,
			"explanation": "The 6 classical Ritus proceed in strict order: Vasanta (Spring) → Grīṣma (Summer) → Varṣā (Monsoon) → Śarat (Autumn) → Hemanta (Pre-winter) → Śiśira (Winter)."
		},
		"medium": {
			"title": "Lunar Month Chronology",
			"mechanic": "Contextual Lunar Calendar Ordering",
			"question": "An astronomical manuscript fragment records three consecutive lunar months (Māsa):\n\n• Clue 1: 'The harvest observations occur in Kārtika, exactly following the autumnal equinox month of Āśvina.'\n• Clue 2: 'Mārgaśīrṣa immediately succeeds Kārtika as early frost sets in.'\n\nArrange these three months in correct chronological order:",
			"options": [
				"A) Āśvina → Kārtika → Mārgaśīrṣa",
				"B) Kārtika → Āśvina → Mārgaśīrṣa",
				"C) Mārgaśīrṣa → Āśvina → Kārtika",
				"D) Āśvina → Mārgaśīrṣa → Kārtika"
			],
			"correct": 0,
			"explanation": "The standard calendar sequence runs: Āśvina (7th month) → Kārtika (8th month) → Mārgaśīrṣa (9th month)."
		},
		"hard": {
			"title": "Solstitial Ayana Deduction",
			"mechanic": "Deduction of Missing Solar Cardinal Points",
			"question": "Reconstruct a torn astronomical ledger documenting the solstitial year (Ayanas):\n\n• Clue 1: 'The Uttarāyana (Northern solar progress) commences at the Winter Solstice in month α and spans 6 solar months.'\n• Clue 2: 'The Dakṣiṇāyana (Southern solar progress) commences at the Summer Solstice in month β.'\n• Clue 3: 'Month α coincides with the winter month Māgha, while Month β precedes the heavy monsoons in Āṣāḍha.'\n\nWhich deduction correctly restores the lost solar turning points?",
			"options": [
				"A) α = Māgha (Winter Solstice), β = Āṣāḍha (Summer Solstice); each Ayana spans 3 Ritus (6 months)",
				"B) α = Caitra (Spring Equinox), β = Āśvina (Autumn Equinox); each Ayana spans 2 Ritus (4 months)",
				"C) α = Śravaṇa (Monsoon), β = Phālguna (Spring); each Ayana spans 4 Ritus (8 months)",
				"D) α = Vaiśākha (Summer), β = Kārtika (Autumn); each Ayana spans 1 Ritu (2 months)"
			],
			"correct": 0,
			"explanation": "Classical Indian astronomy divides the year into two Ayanas of 6 months each: Uttarāyana begins at the Winter Solstice (Māgha) and Dakṣiṇāyana begins at the Summer Solstice (Āṣāḍha)."
		}
	},
	"medicine": {
		"title": "Medicine — Physician's Kit",
		"description": "Historical apparatus, manuscript preservation, and classical herbal preparation sequences.",
		"easy": {
			"title": "Dispensary Apparatus Selection",
			"mechanic": "Historical Tool Identification",
			"question": "In Nalanda's Chikitsa (medical) hall, a Vaidya needs to pulverize dry medicinal barks and roots into a fine therapeutic powder (Churna). Which classical tool is used?",
			"options": [
				"A) Shalaka (Metallic probe for ocular diagnostics)",
				"B) Khalva Yantra (Stone/Bronze Mortar and Pestle)",
				"C) Shringa (Suction horn)",
				"D) Sandamsha Yantra (Surgical forceps)"
			],
			"correct": 1,
			"explanation": "The Khalva Yantra (mortar and pestle) is the foundational Ayurvedic apparatus for grinding raw botanical substances into fine Churna."
		},
		"medium": {
			"title": "Manuscript Preservation Kit",
			"mechanic": "Tool Assembly with Distractors",
			"question": "A student in the medical archive must assemble the 3 core items for writing and safeguarding palm-leaf medical texts (Taadpatra Granthas):",
			"options": [
				"A) Seasoned palm leaves, iron stylus (Lekhani), and natural neem/turmeric anti-insect preservative oil",
				"B) Copper needles, sheepskin parchment, and acidic gall ink",
				"C) Wet clay tablets, wooden wedge, and beeswax coating",
				"D) Woven papyrus, goose quill, and animal bone adhesive"
			],
			"correct": 0,
			"explanation": "Taadpatra manuscripts were inscribed using an iron stylus (Lekhani) upon seasoned Palmyra leaves and coated with neem and turmeric oils to repel pests and moisture."
		},
		"hard": {
			"title": "Classical Formulation Sequence",
			"mechanic": "Multi-Step Process Arrangement",
			"question": "Reconstruct the historical 4-step preparation and preservation sequence for a classical herbal medicated oil (Sneha Kalpana / Taila Paka):",
			"options": [
				"A) 1. Grind herbs into Kalka paste → 2. Combine with liquid (Drava) and base oil → 3. Gentle boiling until moisture evaporates (Paka Siddhi) → 4. Filter and seal in clean jar",
				"B) 1. Boil raw oil at high heat → 2. Add dry roots directly → 3. Freeze mixture → 4. Strain immediately",
				"C) 1. Sun-dry raw leaves → 2. Pack in unwashed cloth → 3. Submerge in river water → 4. Boil with honey",
				"D) 1. Mix herbs with charcoal → 2. Dissolve in hot milk → 3. Filter through sand → 4. Store in open sunlight"
			],
			"correct": 0,
			"explanation": "Classical Sneha Kalpana strictly follows the 4-step ratio: Kalka (herb paste) + Drava (decoction/water) + Sneha (oil), simmered gently until moisture completely evaporates (Paka Siddhi), followed by fine filtration."
		}
	},
	"philosophy": {
		"title": "Philosophy — Contradictory Manuscript",
		"description": "Analyze arguments, identify logical fallacies (Hetvābhāsa), and resolve philosophical contradictions.",
		"easy": {
			"title": "Direct Contradiction Identification",
			"mechanic": "Premise Inconsistency Check",
			"question": "Examine two conflicting statements from a debate scroll:\n\n• Statement 1: 'All knowledge obtained through direct perception (Pratyaksha) is eternal and changeless.'\n• Statement 2: 'All physical objects perceived in the world are impermanent (Anitya) and constantly changing.'\n\nWhat is the logical contradiction?",
			"options": [
				"A) Statement 1 claims perception produces unchanging knowledge, whereas Statement 2 asserts perceived objects are continually changing",
				"B) Both statements agree that knowledge cannot be attained",
				"C) Statement 1 relates only to sound while Statement 2 relates only to taste",
				"D) There is no contradiction; both statements assert identical truths"
			],
			"correct": 0,
			"explanation": "If the perceived world is intrinsically impermanent and changing (Anitya), direct perception of changing objects cannot produce eternal, changeless knowledge."
		},
		"medium": {
			"title": "Conflicting Premise in Argument",
			"mechanic": "Argument Evaluation & Conflict Detection",
			"question": "Analyze the three premises in a debater's thesis on causality:\n\n1. 'Every effect requires an antecedent material and efficient cause (Satkāryavāda).'\n2. 'Clay, water, and the potter's wheel are necessary causes for creating a clay pot.'\n3. 'A finished clay pot can spontaneously materialize out of void without any prior causes.'\n\nWhich premise creates an irreconcilable logical conflict?",
			"options": [
				"A) Premise 3 directly violates Premise 1 by asserting an uncaused spontaneous effect",
				"B) Premise 2 conflicts with Premise 1 by identifying physical tools",
				"C) Premise 1 is faulty because causes never precede effects",
				"D) All three premises are logically harmonious and valid"
			],
			"correct": 0,
			"explanation": "Premise 3 asserts that an effect can arise without any prior cause, directly contradicting the core axiom of Premise 1."
		},
		"hard": {
			"title": "Fallacy Identification & Rectification",
			"mechanic": "Hetvābhāsa (Fallacy) & Syllogistic Correction",
			"question": "Examine the fallacious thesis: 'Sound is eternal because it is produced by clapping two wooden blocks together.'\n\nIdentify the formal flaw (Hetvābhāsa) and select the correct philosophical resolution:",
			"options": [
				"A) Flaw: Contradictory Reason (Viruddha)—production by action proves impermanence, not eternity. Resolution: Sound is impermanent because it is a created effect (Kṛtakatva).",
				"B) Flaw: Irrelevant Subject (Asiddha). Resolution: Wooden blocks cannot generate audible sound.",
				"C) Flaw: Circular Reasoning (Ātmāśraya). Resolution: Sound is eternal simply because it is sound.",
				"D) Flaw: Unproven Example (Sādhyasama). Resolution: Clapping proves sound exists without creation."
			],
			"correct": 0,
			"explanation": "In Indian logic (Nyāya/Buddhist Hetuvidyā), citing 'produced by effort' (Kṛtakatva) to prove 'eternity' is a Viruddha fallacy, because being produced invariably proves impermanence (Anityatva)."
		}
	}
}

static func get_challenge(domain: String, difficulty: String) -> Dictionary:
	var dom = domain.to_lower().strip_edges()
	var diff = difficulty.to_lower().strip_edges()
	if CHALLENGES.has(dom):
		var dom_dict = CHALLENGES[dom]
		if dom_dict.has(diff):
			return dom_dict[diff]
	return {}
