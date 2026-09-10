class_name ViharaChallengeData
extends RefCounted

const CHALLENGES: Dictionary = {
	"mathematics": {
		"title": "Mathematics — Resource Distribution",
		"description": "Calculate and allocate communal grain, oil, and supplies for Nalanda's resident scholar communities.",
		"easy": {
			"title": "Grain Bundle Distribution",
			"mechanic": "Simple Equal Allocation",
			"question": "In the Vihara dining hall, 12 bundles of harvested grain arrive from surrounding agricultural villages.\n\nIf they must be distributed equally among 4 resident scholar groups (Ganas), how many bundles does each group receive?",
			"options": [
				"A) 2 bundles",
				"B) 3 bundles",
				"C) 4 bundles",
				"D) 6 bundles"
			],
			"correct": 1,
			"explanation": "Equal allocation of 12 grain bundles across 4 groups requires 12 / 4 = 3 bundles per scholar group."
		},
		"medium": {
			"title": "Multi-Supply Allocation",
			"mechanic": "Multi-Resource Allocation with Constraints",
			"question": "The Vihara steward must distribute monthly provisions for 5 monk residential wings. Each wing requires exactly:\n\n• 4 measures of grain\n• 2 flasks of lamp oil\n• 3 cotton robes\n\nHow many total provisions must be drawn from the central storehouse?",
			"options": [
				"A) 20 grain, 10 lamp oil, 15 cotton robes",
				"B) 15 grain, 10 lamp oil, 20 cotton robes",
				"C) 20 grain, 15 lamp oil, 10 cotton robes",
				"D) 25 grain, 10 lamp oil, 15 cotton robes"
			],
			"correct": 0,
			"explanation": "Multiplying by 5 wings: Grain = 5 × 4 = 20, Lamp Oil = 5 × 2 = 10, Cotton Robes = 5 × 3 = 15."
		},
		"hard": {
			"title": "Monastic Retreat Supply Management",
			"mechanic": "Multi-Step Resource Allocation with Buffer Constraints",
			"question": "The Vihara storehouse holds 100 measures of rice for a 30-day retreat under strict management rules:\n\n1. Baseline daily consumption is 2.5 measures per day for resident monks.\n2. An emergency reserve buffer of 15 measures must remain untouched in the granary.\n3. During 5 designated debate feast days, an extra 1 measure per feast day is served to visiting scholars.\n\nCalculate the exact surplus rice remaining for village donation at the end of the 30 days:",
			"options": [
				"A) 5 measures",
				"B) 10 measures",
				"C) 15 measures",
				"D) 0 measures (Deficit)"
			],
			"correct": 0,
			"explanation": "Baseline consumption = 30 × 2.5 = 75 measures. Feast additions = 5 × 1 = 5 measures. Reserved buffer = 15 measures. Total allocated/reserved = 75 + 5 + 15 = 95 measures. Surplus for donation = 100 - 95 = 5 measures."
		}
	},
	"astronomy": {
		"title": "Astronomy — Night Observation",
		"description": "Observe planetary bodies (Grahas), fixed stars, and nocturnal celestial coordinates from the Vihara terrace.",
		"easy": {
			"title": "The Unmoving Celestial Pivot",
			"mechanic": "Stationary Pole Star Identification",
			"question": "A Nalanda scholar observes a solitary bright star in the northern sky that remains stationary throughout the night while all surrounding constellations slowly revolve around it.\n\nWhich celestial landmark is this?",
			"options": [
				"A) Dhruva Tārā (Polaris / North Pole Star)",
				"B) Śukra (Venus / Evening Star)",
				"C) Bṛhaspati (Jupiter)",
				"D) Rāhu (Ascending Lunar Node)"
			],
			"correct": 0,
			"explanation": "Dhruva Tārā (Polaris) sits directly near the celestial pole, serving as the unchanging navigational and astronomical pivot of the night sky."
		},
		"medium": {
			"title": "Wandering Graha Characteristics",
			"mechanic": "Observational Clue Matching",
			"question": "An astronomical ledger from the Vihara observatory records two distinct celestial wanderers (Grahas):\n\n• Object 1: 'Gleams with intense brilliance near the western horizon right after sunset, never straying far from the sun.'\n• Object 2: 'Shines with a steady golden light high in the midnight sky, requiring nearly 12 solar years to transit all 12 Rashis.'\n\nIdentify Objects 1 and 2:",
			"options": [
				"A) Object 1: Śukra (Venus) | Object 2: Bṛhaspati (Jupiter)",
				"B) Object 1: Maṅgala (Mars) | Object 2: Śani (Saturn)",
				"C) Object 1: Budha (Mercury) | Object 2: Ketu (Descending Node)",
				"D) Object 1: Chandra (Moon) | Object 2: Śukra (Venus)"
			],
			"correct": 0,
			"explanation": "Venus (Śukra) is the brightest evening/morning star with an interior orbit close to the sun. Jupiter (Bṛhaspati) has an orbital period of approximately 11.86 solar years (spending about 1 year per zodiac sign)."
		},
		"hard": {
			"title": "Multi-Log Planetary Deduction",
			"mechanic": "Confluence of Astronomical Observations",
			"question": "Analyze three observational logs recorded over 6 months from Nalanda's rooftop observatory:\n\n1. Log A: 'Exhibits retrograde (backward) looping motion against the backdrop of the Chitrā Nakshatra (Spica) for 2 months.'\n2. Log B: 'Displays a distinct reddish hue and traverses the star field faster than Jupiter.'\n3. Log C: 'Takes approximately 687 days (1.88 solar years) to complete a full sidereal orbit through all Nakshatras.'\n\nWhich planetary body (Graha) is precisely identified by these three logs?",
			"options": [
				"A) Aṅgāraka / Maṅgala (Mars)",
				"B) Śani (Saturn)",
				"C) Budha (Mercury)",
				"D) Sūrya (Sun)"
			],
			"correct": 0,
			"explanation": "Mars (Maṅgala / Aṅgāraka) is uniquely distinguished by its red color, prominent retrograde loops, and sidereal orbital period of 687 Earth days."
		}
	},
	"medicine": {
		"title": "Medicine — Herbal Garden",
		"description": "Identify medicinal flora, harvested plant parts, and classical preparation sequences from the Vihara botanical garden.",
		"easy": {
			"title": "Botanical Identification & Use",
			"mechanic": "Plant & Therapeutic Application Match",
			"question": "In the Vihara herbal garden (Aushadhi Vatika), a student collects fresh Tulsi (Holy Basil) leaves.\n\nIn historical Ayurvedic treatises, what is its primary traditional application?",
			"options": [
				"A) Respiratory balance, soothing congestion (Kasa/Shwasa), and vitality infusion",
				"B) Hard bone fracture splinting adhesive",
				"C) Deep surgical anesthesia",
				"D) Mineral smelting catalyst"
			],
			"correct": 0,
			"explanation": "Tulsi (Ocimum sanctum) is celebrated in classical texts for pacifying Kapha and Vata, clearing respiratory passages, and enhancing natural immunity."
		},
		"medium": {
			"title": "Plant Part & Therapeutic Pairing",
			"mechanic": "Botanical Anatomy & Function Matching",
			"question": "A dispensary scholar must pair two classical medicinal plants with their correct anatomical parts and therapeutic roles:\n\n• Plant 1: Ashwagandha (Withania somnifera)\n• Plant 2: Haritaki (Terminalia chebula)\n\nSelect the correct historical pairing:",
			"options": [
				"A) Ashwagandha Root (Rejuvenative Rasayana / vitality tonic) & Haritaki Fruit Pericarp (Digestive cleansing / Tridosha balancing)",
				"B) Ashwagandha Flower (Perfume) & Haritaki Wood (Building timber)",
				"C) Ashwagandha Bark (Fabric dye) & Haritaki Leaf (Leather tanning)",
				"D) Ashwagandha Seed (Lamp fuel) & Haritaki Root (Rope weaving)"
			],
			"correct": 0,
			"explanation": "In classical pharmacopoeia, the root of Ashwagandha serves as a premier strength-giving Rasayana, while the fruit rind of Haritaki is renowned as a master digestive regulator."
		},
		"hard": {
			"title": "Garden-to-Remedy Formulation Protocol",
			"mechanic": "Multi-Step Botanical Preparation Sequence",
			"question": "Reconstruct the complete traditional protocol for preparing a classical restorative cooling paste (Pralepa) to soothe heat exhaustion (Pitta Prakopa):\n\n1. Select the botanical source.\n2. Choose the correct harvested part.\n3. Identify the preparation vehicle (Anupana/Medium).\n4. Specify the application procedure.",
			"options": [
				"A) 1. Chandana (Sandalwood) → 2. Heartwood → 3. Rubbed on stone with Cold water/Rosewater into fine paste → 4. Applied externally to forehead and temples",
				"B) 1. Maricha (Black Pepper) → 2. Seeds → 3. Boiled in mustard oil → 4. Ingested with boiling water",
				"C) 1. Guggulu (Resin) → 2. Bark → 3. Mixed with hot coarse sand → 4. Rubbed on open wounds",
				"D) 1. Bhallataka (Marking Nut) → 2. Raw juice → 3. Direct unpurified application → 4. Bound tightly with wool"
			],
			"correct": 0,
			"explanation": "Classical Pitta-pacifying Pralepa uses cooling Sandalwood (Chandana) heartwood rubbed on a stone slab with pure cold water to form a smooth paste applied topically."
		}
	},
	"philosophy": {
		"title": "Philosophy — Scholar's Debate",
		"description": "Engage in formal dialectical inquiry (Vāda), evaluating claims, counterarguments, and syllogistic reasoning.",
		"easy": {
			"title": "Epistemological Counter-Argument",
			"mechanic": "Logical Refutation Selection",
			"question": "In a philosophical discussion on perception (Pratyaksha), a student claims: 'We only know an object exists if our physical senses touch it right now.'\n\nWhich is the strongest logical counter-response according to classical epistemological reasoning?",
			"options": [
				"A) 'Inference (Anumāna) also proves existence—for instance, observing rising smoke validly proves unseen fire on a distant hill.'",
				"B) 'Nothing can ever be known under any circumstances.'",
				"C) 'Sensory perception is always 100% defective and deceptive.'",
				"D) 'One should simply agree with whichever debater speaks loudest.'"
			],
			"correct": 0,
			"explanation": "Classical Indian epistemology recognizes valid Inference (Anumāna) alongside direct Perception (Pratyaksha); unseen causes are conclusively known through invariable concomitance (Vyāpti)."
		},
		"medium": {
			"title": "Debate Dialectics & Inquiry",
			"mechanic": "Dialectical Method Defense",
			"question": "In a debate on knowledge transmission, an opponent argues: 'Written texts alone are sufficient for true understanding; questioning and oral disputation (Vādatattvavidyā) are redundant.'\n\nWhich response provides the strongest logical refutation?",
			"options": [
				"A) 'Written words convey static statements, but dialectical debate (Vāda) actively resolves doubts (Saṃśaya), exposes hidden fallacies (Hetvābhāsa), and tests practical comprehension.'",
				"B) 'Books should be abandoned entirely because only oral speech matters.'",
				"C) 'Both writing and debating are inferior to random guessing.'",
				"D) 'Debate is useful solely for entertaining crowds and gaining royal favors.'"
			],
			"correct": 0,
			"explanation": "Nalanda's pedagogy emphasized dialectical debate (Vāda) as an active truth-seeking method to systematically eliminate cognitive doubt (Saṃśaya) and verify understanding."
		},
		"hard": {
			"title": "Formal Syllogism & Defeating Upādhi",
			"mechanic": "Multi-Step Syllogistic Validation (Pañcāvayava)",
			"question": "Evaluate the formal 5-step debate syllogism (Pañcāvayava):\n\n1. Pratijñā (Proposition): 'The hillside possesses fire.'\n2. Hetu (Reason): 'Because it possesses smoke.'\n3. Udāharaṇa (Example): 'Whatever has smoke has fire, like a hearth.'\n4. Upanaya (Application): 'This hill is accompanied by smoke.'\n5. Nigamana (Conclusion): 'Therefore, this hill possesses fire.'\n\nAn opponent challenges: 'What if the rising vapor is merely morning mist?' Which critical logical element conclusively defends the validity of the inference?",
			"options": [
				"A) Verifying that the rising vapor arises from combustion and possesses the continuous, billowing quality of true smoke, satisfying unconditional invariable concomitance (Nirupādhika Vyāpti) with fire.",
				"B) Demanding that the opponent climb the mountain to touch the flames directly.",
				"C) Claiming that mist and smoke are identical in all philosophical treatises.",
				"D) Altering the original proposition to discuss water instead of fire."
			],
			"correct": 0,
			"explanation": "A valid inference requires the Reason (Hetu) to be unvitiated by extraneous conditions (Upādhi). Verifying true smoke confirms the unconditional invariable relation (Nirupādhika Vyāpti) with fire."
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
