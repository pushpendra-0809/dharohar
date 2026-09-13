class_name LibraryChallengeData
extends Node

const DOMAIN_INFO: Dictionary = {
	"mathematics": {
		"name": "Mathematics",
		"hindi_name": "Ganita (Mathematics)",
		"title": "MATHEMATICS — THE LOST ARYABHATIYA FOLIO",
		"subject": "Mathematics & Astronomy Calculations",
		"symbol": "🔢",
		"target_title": "Aryabhatiya: Ganitapada",
		"scholar_clue": "Search for the classical treatise on place-value progression (Sthanat Sthanam Dasha-gunam) and zero authored in the Kusumapura tradition.",
		"description": "Investigate ancient mathematical folios on decimal place-value, geometry, and root extractions."
	},
	"astronomy": {
		"name": "Astronomy",
		"hindi_name": "Khagola (Astronomy)",
		"title": "ASTRONOMY — THE LOST GNOMON SHADOW RECORD",
		"subject": "Astronomical Timekeeping & Solar Observation",
		"symbol": "☀️",
		"target_title": "Ghati-Chhaya Vivarana",
		"scholar_clue": "Search for the Nalanda observational record on vertical gnomon (Shanku) shadow progression from dawn to midday.",
		"description": "Investigate celestial observation folios on planetary orbits, solar timekeeping, and lunar mansions."
	},
	"medicine": {
		"name": "Medicine",
		"hindi_name": "Ayurveda (Medicine)",
		"title": "MEDICINE — THE LOST TRIPHALA RASAYANA FOLIO",
		"subject": "Classical Ayurvedic Herbal Formulations",
		"symbol": "🌿",
		"target_title": "Rasayana Tantra: Triphala Kalpana",
		"scholar_clue": "Search for the Charaka tradition manuscript on the three sacred rejuvenating fruits (Amalaki, Haritaki, Bibhitaki).",
		"description": "Investigate ancient Ayurvedic folios on herbal combinations, dosha balancing, and rasayana rejuvenation."
	},
	"philosophy": {
		"name": "Philosophy",
		"hindi_name": "Nyaya (Logic & Epistemology)",
		"title": "PHILOSOPHY — THE LOST NYAYA SUTRA VARTTIKA",
		"subject": "Deductive Syllogism & Epistemology",
		"symbol": "⚖️",
		"target_title": "Nyaya Sutra Varttika",
		"scholar_clue": "Search for the Gautama tradition manuscript establishing the 5-limbed syllogism (Pancha-Avayava) and invariable concomitance (Vyapti).",
		"description": "Investigate philosophical treatises on valid knowledge (Pramana), deduction, and debate rules."
	}
}

const LEVEL1_MANUSCRIPTS: Dictionary = {
	"mathematics": [
		{
			"id": "m_math_correct",
			"is_correct": true,
			"title": "Aryabhatiya: Ganitapada",
			"author": "Acharya Aryabhata (Kusumapura)",
			"subject": "Mathematics — Decimal Place-Value & Arithmetic",
			"symbol": "🔢",
			"clues": "• Mentions: 'Sthanat sthanam dasha-gunam syat' (tenfold place-value)\n• Outlines square root extraction across even and odd digits\n• Defines circumference ratio approximation 62,832 / 20,000",
			"excerpt": "“Sthanat sthanam dasha-gunam syat.”\nFrom one place to the next, the numerical value increases tenfold. Herein lies the foundation of positional decimal reckoning, calculation of roots, and the geometry of spheres."
		},
		{
			"id": "m_math_dist1",
			"is_correct": false,
			"title": "Sulba Sutras of Baudhayana",
			"author": "Vedic Altar Geometer Tradition",
			"subject": "Geometry — Sacred Altar Construction",
			"symbol": "📐",
			"clues": "• Focuses on rope measurements (Sulba) for sacrificial hearths\n• Geometric transformation of squares into circles\n• No mention of decimal place-value or zero",
			"excerpt": "“The diagonal cord of an oblong produces both areas that its horizontal and vertical sides make separately.” (Focuses on altar geometry, not decimal arithmetic)."
		},
		{
			"id": "m_math_dist2",
			"is_correct": false,
			"title": "Pingala Chhandah-shastra",
			"author": "Acharya Pingala",
			"subject": "Combinatorics — Poetic Meter Permutations",
			"symbol": "📜",
			"clues": "• Binary classification of long (Guru) and short (Laghu) syllables\n• Meru Prastara combinatoric mountain\n• Does not cover planetary arithmetic or root extraction",
			"excerpt": "“Binary expansions of Vedic meters produce structured combinatorial arrays known as the Meru Prastara.”"
		}
	],
	"astronomy": [
		{
			"id": "m_astro_correct",
			"is_correct": true,
			"title": "Ghati-Chhaya Vivarana",
			"author": "Nalanda Jyotisha Parishad",
			"subject": "Astronomy — Gnomon Shadow & Solar Timekeeping",
			"symbol": "☀️",
			"clues": "• Outlines vertical Shanku shadow progression across 60 Ghatikas\n• Shortest shadow occurs at exact solar midday (Madhyahna)\n• Cardinal East-West orientation via circular solar bisectors",
			"excerpt": "“A vertical pillar placed at the center of a circular platform reveals solar time. As the sun reaches zenith at midday, the shadow attains its shortest length.”"
		},
		{
			"id": "m_astro_dist1",
			"is_correct": false,
			"title": "Graha-Sphuta Charita",
			"author": "Surya Siddhanta Epicycle Lineage",
			"subject": "Astronomy — Epicyclic Planetary Longitudes",
			"symbol": "🪐",
			"clues": "• Mathematical epicycles of Jupiter, Mars, and Saturn\n• Focuses on planetary speed deviations rather than gnomon shadows\n• Lacks daily shadow timekeeping tables",
			"excerpt": "“Planetary velocity varies as celestial spheres traverse mandaparidhi and shighraparidhi epicycles in the high heavens.”"
		},
		{
			"id": "m_astro_dist2",
			"is_correct": false,
			"title": "Nakshatra Purana Gatha",
			"author": "Mythological Narrative Tradition",
			"subject": "Cosmology — Mythological Lunar Mansions",
			"symbol": "🌌",
			"clues": "• Poetic stories of the 27 sisters of Chandra\n• Mythological allegories rather than astronomical measurement\n• No observational calculations",
			"excerpt": "“King Daksha blessed his twenty-seven daughters, the Nakshatras, to dwell forever in the starry expanse with the Moon.”"
		}
	],
	"medicine": [
		{
			"id": "m_med_correct",
			"is_correct": true,
			"title": "Rasayana Tantra: Triphala Kalpana",
			"author": "Charaka Chikitsa Tradition",
			"subject": "Ayurveda — Rejuvenation & Three Sacred Fruits",
			"symbol": "🌿",
			"clues": "• Triphala: Amalaki (Pitta-cooling), Haritaki (Vata-calming), Bibhitaki (Kapha-clearing)\n• Classical decoction (Kwatha) preparation and dosage\n• Cellular vitality and respiratory balance",
			"excerpt": "“Amalaki, Haritaki, and Bibhitaki in harmonious combination balance the three doshas, cleanse bodily channels, and bestow longevity as a supreme Rasayana.”"
		},
		{
			"id": "m_med_dist1",
			"is_correct": false,
			"title": "Shalya Tantra Samhita",
			"author": "Acharya Sushruta School",
			"subject": "Surgery — Surgical Incisions & Instruments",
			"symbol": "✂️",
			"clues": "• 101 blunt and 20 sharp surgical instruments (Yantras & Shastras)\n• Cauterization and wound suturing techniques\n• Does not cover daily herbal Rasayana tonics",
			"excerpt": "“The surgeon must master incision, excision, scraping, puncturing, and probing with steady hands and sterile steel.”"
		},
		{
			"id": "m_med_dist2",
			"is_correct": false,
			"title": "Agada Tantra: Visha Vijnana",
			"author": "Toxicology Lineage",
			"subject": "Toxicology — Poison Antidotes",
			"symbol": "🐍",
			"clues": "• Antidotes for venomous serpent bites and scorpion stings\n• Emergency mineral preparations\n• Focuses on acute poisoning, not daily rejuvenation",
			"excerpt": "“Immediate application of herbal tourniquets and specific antidotes neutralizes serpent venom in the bloodstream.”"
		}
	],
	"philosophy": [
		{
			"id": "m_phil_correct",
			"is_correct": true,
			"title": "Nyaya Sutra Varttika",
			"author": "Aksapada Gautama Tradition",
			"subject": "Philosophy — Deductive Syllogism & Inference",
			"symbol": "⚖️",
			"clues": "• 5-Limbed Syllogism: Pratijna, Hetu, Udaharana, Upanaya, Nigamana\n• Establishes Vyapti (invariable concomitance) between smoke and fire\n• Refutation of self-contradiction (Vyaghata) in debate",
			"excerpt": "“Anumana (inference) derives its validity from Vyapti — the universal and unconditional concomitance between the sign (Hetu) and the sign-bearer (Sadhya).”"
		},
		{
			"id": "m_phil_dist1",
			"is_correct": false,
			"title": "Lokayata Tattva",
			"author": "Charvaka Materialist Lineage",
			"subject": "Materialism — Denial of Inference",
			"symbol": "🌾",
			"clues": "• Asserts only direct sense perception (Pratyaksha) is valid\n• Denies inference and invisible cause-and-effect\n• Directly opposes the 5-limbed Nyaya method",
			"excerpt": "“Only that which can be directly touched and seen with the eye is real. Inference is merely unproven imagination.”"
		},
		{
			"id": "m_phil_dist2",
			"is_correct": false,
			"title": "Mimamsa Karma Deepika",
			"author": "Jaimini Ritual Lineage",
			"subject": "Ritualism — Vedic Injunctions & Sacrifices",
			"symbol": "🔥",
			"clues": "• Performance rules for seasonal fire offerings\n• Focuses on ritual duty (Dharma) rather than logic proofs\n• Lacks syllogistic debate epistemology",
			"excerpt": "“Vedic ritual injunctions are eternal commands that must be executed with exact procedural fidelity.”"
		}
	]
}

const LEVEL2_STUDY_DATA: Dictionary = {
	"mathematics": {
		"title": "Aryabhata's Place-Value & Mathematical Principles",
		"study_text": "“Sthanat sthanam dasha-gunam syat” — from one place to the next, the numerical value increases tenfold.\n\nIn our classical treatise, digits are classified strictly into odd (Vishma) and even (Sama) places for calculating square roots (Vargamula).\n\nFurthermore, for a circle with a diameter of 20,000 units, the circumference is established as approximately 62,832 units (giving Pi ≈ 3.1416 as an approximate value).\n\nMultiplication by zero yields zero, and zero added to a quantity leaves it unchanged.",
		"questions": [
			{
				"question": "According to the studied manuscript, what rule defines place-value progression across successive columns?",
				"options": [
					"Each successive place increases the numerical value tenfold (Dasha-gunam).",
					"Values increase in powers of 60 only.",
					"Values double from left to right.",
					"Values remain constant across all columns."
				],
				"correct": 0
			},
			{
				"question": "What circumference did Aryabhata specify for a circle with a diameter of 20,000 units?",
				"options": [
					"62,832 units (approximating Pi as 3.1416)",
					"22,000 units (approximating Pi as 3.1428)",
					"31,416 units exactly",
					"60,000 units without remainder"
				],
				"correct": 0
			}
		]
	},
	"astronomy": {
		"title": "Principles of Gnomon Shadow Observation (Shanku-Yantra)",
		"study_text": "A level circular platform is marked with concentric circles (Vritta).\n\nAt exact solar midday (Madhyahna), the sun attains its highest celestial altitude, casting the shortest shadow of the entire day.\n\nThe line connecting the morning shadow touch point on the circle to the afternoon touch point establishes the exact East-West axis (Prachi-Pratichi).\n\nOne full solar day (Ahoratra) is divided into exactly 60 Ghatikas (each Ghatika equal to 24 modern minutes).",
		"questions": [
			{
				"question": "According to the manuscript, when is the vertical gnomon's shadow at its absolute shortest?",
				"options": [
					"At exact solar midday (Madhyahna) when the sun reaches zenith.",
					"At early dawn before the sun rises above the horizon.",
					"At midnight.",
					"At evening twilight (Sandhya)."
				],
				"correct": 0
			},
			{
				"question": "How is one full day (Ahoratra) divided into classical time units in this text?",
				"options": [
					"Into 60 Ghatikas (24 minutes each).",
					"Into 24 modern hours only.",
					"Into 100 Ghati units.",
					"Into 12 solar months."
				],
				"correct": 0
			}
		]
	},
	"medicine": {
		"title": "The Three Sacred Fruits (Triphala) in Classical Ayurveda",
		"study_text": "Triphala combines three fruits in balanced harmony:\n\n1. Amalaki (Emblica officinalis) — cooling in potency (Shita-virya), supremely effective for pacifying Pitta dosha, and rich in rejuvenating Rasayana vitality.\n2. Haritaki (Terminalia chebula) — warming, pacifies Vata, cleanses bodily channels, and supports longevity.\n3. Bibhitaki (Terminalia bellirica) — astringent, pacifies Kapha, and clears respiratory channels.\n\nFor daily vitality, the classical texts advise taking the fine powder with warm honey or ghee in the morning, or with warm water at bedtime.",
		"questions": [
			{
				"question": "Which specific fruit in Triphala is noted for its cooling nature and efficacy in pacifying Pitta dosha?",
				"options": [
					"Amalaki (Emblica officinalis)",
					"Bibhitaki",
					"Haritaki",
					"Neem bark"
				],
				"correct": 0
			},
			{
				"question": "Which triad of fruits constitutes the authentic classical Triphala formulation?",
				"options": [
					"Amalaki, Haritaki, and Bibhitaki",
					"Tulsi, Neem, and Ashwagandha",
					"Ginger, Black Pepper, and Pippali (Trikatu)",
					"Brahmi, Shankhpushpi, and Gotu Kola"
				],
				"correct": 0
			}
		]
	},
	"philosophy": {
		"title": "The Five-Limbed Nyaya Syllogism (Pancha-Avayava)",
		"study_text": "Valid philosophical inference (Anumana) requires five interconnected limbs:\n\n1. Pratijna — the initial proposition or thesis to be proved.\n2. Hetu — the reason or ground that indicates the thesis.\n3. Udaharana — the universal rule illustrated by a familiar example (as in a kitchen hearth).\n4. Upanaya — the application of that universal rule to the subject.\n5. Nigamana — the concluding certainty that confirms the thesis.\n\nThe inviolable foundation of all inference is Vyapti — the universal, unconditional concomitance between the sign (Hetu: smoke) and the sign-bearer (Sadhya: fire).",
		"questions": [
			{
				"question": "What is the term for the universal, unconditional relationship between Hetu (smoke) and Sadhya (fire)?",
				"options": [
					"Vyapti (Invariable Concomitance)",
					"Pratijna",
					"Hetvabhasa",
					"Samsaya"
				],
				"correct": 0
			},
			{
				"question": "What is the third limb in the classical 5-limbed Nyaya syllogism?",
				"options": [
					"Udaharana (Universal Rule & Example)",
					"Nigamana (Conclusion)",
					"Hetu (Reason)",
					"Pratijna (Thesis)"
				],
				"correct": 0
			}
		]
	}
}

const LEVEL3_MYSTERY_DATA: Dictionary = {
	"mathematics": {
		"fragments": [
			{
				"id": "f_math_1",
				"text": "Fragment 1: '...Sthanat sthanam dasha-gunam syat... (Place value tenfold progression)'",
				"is_genuine": true
			},
			{
				"id": "f_math_2",
				"text": "Fragment 2: '...Vargamula vibhaga vishma sama sthana... (Square root odd-even places)'",
				"is_genuine": true
			},
			{
				"id": "f_math_3",
				"text": "Fragment 3: '...Khadira wood altar dimensions 36 paces... (Sulba fire altar geometry)'",
				"is_genuine": false
			},
			{
				"id": "f_math_4",
				"text": "Fragment 4: '...Three doshas aggravated during Varsha ritu... (Ayurvedic seasonal rain)'",
				"is_genuine": false
			}
		],
		"scholar_prompt": "Two transcribed scrolls claim to contain the lost Aryabhatiya manuscript on circumference and diameter. One preserves the true approximation while the other contains an interpolation error.",
		"candidates": [
			{
				"id": "cand_correct",
				"title": "Manuscript A — Authentic Aryabhata Transmission",
				"is_correct": true,
				"text": "Specifies circumference ratio 62,832 / 20,000 as an approximate (Asanna) value for circular perimeter calculation.",
				"explanation": "Correct. Aryabhata explicitly termed this value 'Asanna' (approximated ratio ≈ 3.1416)."
			},
			{
				"id": "cand_flawed",
				"title": "Manuscript B — Interpolated Crude Approximation",
				"is_correct": false,
				"text": "Claims circumference is exactly 3 times the diameter without remainder.",
				"explanation": "Flawed. A crude integer ratio of 3 ignores Aryabhata's high-precision calculation."
			}
		]
	},
	"astronomy": {
		"fragments": [
			{
				"id": "f_astro_1",
				"text": "Fragment 1: '...Madhyahna chhaya laghutama... (Midday shadow is shortest)'",
				"is_genuine": true
			},
			{
				"id": "f_astro_2",
				"text": "Fragment 2: '...Vritta madhye prachi pratichi nirdharana... (East-West axis on circle)'",
				"is_genuine": true
			},
			{
				"id": "f_astro_3",
				"text": "Fragment 3: '...Triphala kwatha filtration using fine cotton cloth... (Herbal filter)'",
				"is_genuine": false
			},
			{
				"id": "f_astro_4",
				"text": "Fragment 4: '...Nyaya syllogism fourth step Upanaya application... (Logic card)'",
				"is_genuine": false
			}
		],
		"scholar_prompt": "Two candidate manuscripts describe gnomon shadow calculation. One accounts for true celestial orientation using equal-altitude bisectors, while the other contradicts empirical sky observation.",
		"candidates": [
			{
				"id": "cand_correct",
				"title": "Manuscript A — Empirical Gnomon Observation",
				"is_correct": true,
				"text": "Accurately determines true North-South meridian using equal-altitude gnomon bisectors on the circular platform.",
				"explanation": "Correct. The equal-altitude shadow method provides true cardinal orientation."
			},
			{
				"id": "cand_flawed",
				"title": "Manuscript B — Uncalibrated Rough Shadow Record",
				"is_correct": false,
				"text": "Assumes midday shadows at all latitudes fall identically regardless of solar declination.",
				"explanation": "Flawed. Shadow length varies with solar declination and observer latitude."
			}
		]
	},
	"medicine": {
		"fragments": [
			{
				"id": "f_med_1",
				"text": "Fragment 1: '...Amalaki shita-virya pitta-shamaka... (Amalaki cooling nature)'",
				"is_genuine": true
			},
			{
				"id": "f_med_2",
				"text": "Fragment 2: '...Haritaki bibhitaki samatva rasayana... (Triphala balanced formulation)'",
				"is_genuine": true
			},
			{
				"id": "f_med_3",
				"text": "Fragment 3: '...Epicycle radius of Mars at apogee in Jyotisha... (Astronomy table)'",
				"is_genuine": false
			},
			{
				"id": "f_med_4",
				"text": "Fragment 4: '...Square root calculation digit division... (Mathematics root)'",
				"is_genuine": false
			}
		],
		"scholar_prompt": "Two candidate manuscripts describe the preparation of herbal Rasayana formulations. One maintains classical Charaka purity, while the other incorporates unpurified mineral toxins.",
		"candidates": [
			{
				"id": "cand_correct",
				"title": "Manuscript A — Pure Charaka Botanical Formulation",
				"is_correct": true,
				"text": "Specifies pure plant-based Triphala decoction with honey and clarified butter according to Charaka Samhita.",
				"explanation": "Correct. Preserves authentic classical herbal formulation without adulteration."
			},
			{
				"id": "cand_flawed",
				"title": "Manuscript B — Adulterated Alchemical Note",
				"is_correct": false,
				"text": "Advocates raw unrefined heavy mineral powders without classical Shodhana detoxification.",
				"explanation": "Flawed. Unpurified mineral compounds are hazardous and contradict classical herbal rasayana safety."
			}
		]
	},
	"philosophy": {
		"fragments": [
			{
				"id": "f_phil_1",
				"text": "Fragment 1: '...Pancha-avayava pramana vishleshana... (Five-limbed proof analysis)'",
				"is_genuine": true
			},
			{
				"id": "f_phil_2",
				"text": "Fragment 2: '...Vyapti sahachara niyamena anumana... (Inference through universal concomitance)'",
				"is_genuine": true
			},
			{
				"id": "f_phil_3",
				"text": "Fragment 3: '...Copper gnomon shadow zenith calculation... (Astronomy shadow)'",
				"is_genuine": false
			},
			{
				"id": "f_phil_4",
				"text": "Fragment 4: '...Haritaki fruit decoction for kapha... (Medicine herb)'",
				"is_genuine": false
			}
		],
		"scholar_prompt": "Two philosophical texts address debate methodology (Vada). One adheres strictly to rigorous evidence and refutation of self-contradiction (Vyaghata), while the other allows subjective assertion without proof.",
		"candidates": [
			{
				"id": "cand_correct",
				"title": "Manuscript A — Classical Nyaya Vada Shastra",
				"is_correct": true,
				"text": "Mandates rigorous 5-limbed demonstration and rejects self-refuting statements (Vyaghata).",
				"explanation": "Correct. Upholds disciplined epistemological standards of the Nalanda councils."
			},
			{
				"id": "cand_flawed",
				"title": "Manuscript B — Sophist Tractate",
				"is_correct": false,
				"text": "Claims subjective assertion alone without Vyapti is sufficient in philosophical assembly.",
				"explanation": "Flawed. Subjective belief without invariable concomitance fails Nyaya standards of valid knowledge."
			}
		]
	}
}

static func get_domain_info(domain: String) -> Dictionary:
	var dom = domain.to_lower()
	return DOMAIN_INFO.get(dom, DOMAIN_INFO["mathematics"])

static func get_level1_manuscripts(domain: String) -> Array:
	var dom = domain.to_lower()
	return LEVEL1_MANUSCRIPTS.get(dom, LEVEL1_MANUSCRIPTS["mathematics"])

static func get_level2_study(domain: String) -> Dictionary:
	var dom = domain.to_lower()
	return LEVEL2_STUDY_DATA.get(dom, LEVEL2_STUDY_DATA["mathematics"])

static func get_level3_mystery(domain: String) -> Dictionary:
	var dom = domain.to_lower()
	return LEVEL3_MYSTERY_DATA.get(dom, LEVEL3_MYSTERY_DATA["mathematics"])
