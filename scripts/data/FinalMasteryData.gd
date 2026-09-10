class_name FinalMasteryData
extends RefCounted

const STAGES: Array[Dictionary] = [
	{
		"id": "mathematics",
		"domain": "Mathematics",
		"subtitle": "Stage 1 of 5 — University Planning & Resource Distribution",
		"question": "Nalanda's Mahavihara is preparing a 60-day residential academic session for 120 visiting scholars across 4 departments (30 scholars each):\n\n• Each scholar requires 1.5 measures of food per day.\n• The Astronomy and Medicine departments require an additional 10 measures of lighting oil and 15 bundles of herbs each for laboratory research over the session.\n• A mandatory 10% emergency safety buffer on total food measures must be stored in the granary.\n\nCalculate the total food measures (including 10% safety buffer) and research supplies to be approved:",
		"options": [
			"A) 11,880 food measures | 20 oil measures | 30 herb bundles",
			"B) 10,800 food measures | 10 oil measures | 15 herb bundles",
			"C) 12,000 food measures | 40 oil measures | 60 herb bundles",
			"D) 9,720 food measures | 20 oil measures | 30 herb bundles"
		],
		"correct": 0,
		"explanation": "Base food: 120 scholars × 60 days × 1.5 = 10,800 measures. 10% reserve: 10,800 × 0.10 = 1,080. Total food = 11,880 measures. 2 research departments require 2 × 10 = 20 oil and 2 × 15 = 30 herbs.",
		"hint": "Calculate the base food consumption for 120 scholars over 60 days, then add the 10% reserve. Remember that research supplies apply to 2 departments."
	},
	{
		"id": "astronomy",
		"domain": "Astronomy",
		"subtitle": "Stage 2 of 5 — Celestial Observation & Chronological Deduction",
		"question": "Nalanda's rooftop observatory records three synchronized sky observations:\n\n1. Log A: The solar noon shadow of the gnomon is shortening daily, confirming the sun's northward progress (Uttarāyana).\n2. Log B: The Moon reaches full illumination (Pūrṇimā) directly in conjunction with the Maghā Nakshatra.\n3. Log C: At nightfall, Bṛhaspati (Jupiter) culminates high in the south, while Śukra (Venus) sets 2 hours after sunset in the west.\n\nSynthesizing these observations, determine the precise lunar-solar month and planetary alignment:",
		"options": [
			"A) Month of Māgha during Uttarāyana; Jupiter in high nocturnal transit and Venus serving as the Evening Star (Sandhyā Tārā)",
			"B) Month of Āṣāḍha during Dakṣiṇāyana; Venus rising as the Morning Star",
			"C) Month of Kārtika during Autumn Equinox; Jupiter in solar conjunction",
			"D) Month of Caitra during Summer Solstice; Venus in retrograde opposition"
		],
		"correct": 0,
		"explanation": "Full Moon in Maghā defines the month of Māgha. Shortening noon shadows indicate the post-winter-solstice Uttarāyana. A planet visible setting 2 hours after sunset in the west is the Evening Star (Śukra).",
		"hint": "Consider which lunar month is named after the Maghā Nakshatra when full Moon occurs, and what shortening shadows indicate about solar progress."
	},
	{
		"id": "medicine",
		"domain": "Medicine",
		"subtitle": "Stage 3 of 5 — Traditional Knowledge & Seasonal Harmony",
		"question": "During the hot, dry transition to summer (Grīṣma Ritu), several resident scholars present with physical exhaustion, dehydration, and internal heat restlessness (Pitta-Vata aggravation).\n\nFormulate the classical Ayurvedic 3-part restorative regimen combining diet (Ahara), botanical remedy (Aushadha), and conduct (Vihara):",
		"options": [
			"A) Ahara: Cooling sweet-bitter gruels with milk and Ghrita | Aushadha: Chandana (Sandalwood) and Amalaki infusion | Vihara: Resting in shaded, well-ventilated halls during peak noon heat",
			"B) Ahara: Spicy fried peppers and pungent mustard | Aushadha: Dried black pepper paste | Vihara: Intense physical drills under direct noon sunlight",
			"C) Ahara: Heavy sour curd and pickles | Aushadha: Raw iron slag decoction | Vihara: Sleep deprivation",
			"D) Ahara: Complete fasting without water | Aushadha: Mineral salts | Vihara: Exposure to dry winds"
		],
		"correct": 0,
		"explanation": "Classical treatises prescribe sweet, cooling, easily digestible foods (Ghrita, milk), cooling botanical infusions (Amalaki, Chandana), and avoiding harsh midday solar exposure to pacify Pitta during Grīṣma.",
		"hint": "Recall the principles of seasonal harmony (Ritu Charya): hot and dry conditions require cooling, nourishing, and hydrating counter-measures."
	},
	{
		"id": "philosophy",
		"domain": "Philosophy",
		"subtitle": "Stage 4 of 5 — Dialectical Debate & Epistemological Defense",
		"question": "In the debate courtyard, an opponent argues: 'Knowledge consists only of isolated, momentary flickers of awareness (Kshanikavada); therefore, memory (Smriti) and cumulative learning over time are impossible illusions.'\n\nWhich philosophical refutation (Khandana) rigorously defends educational continuity and recognition (Pratyabhijñā)?",
		"options": [
			"A) Memory and cumulative learning necessitate a continuous cognitive continuum (Saṃskāra-santāna); if awareness were completely disconnected moment-to-moment, one could never recognize that 'the teacher speaking now is the same one who taught yesterday'",
			"B) Memory is an inexplicable miracle that requires no logical justification",
			"C) The opponent should be disqualified because learning is obvious to common sense",
			"D) Learning does not exist; students merely guess answers correctly by random chance"
		],
		"correct": 0,
		"explanation": "Classical Indian epistemology demonstrates that memory (Smṛti) and recognition (Pratyabhijñā) prove unified cognitive continuity through impressions (Saṃskāras); discrete isolated moments cannot synthesize past and present learning.",
		"hint": "Think about how recognition (Pratyabhijñā) connects past learning with present perception through latent cognitive impressions (Saṃskāras)."
	},
	{
		"id": "integrated",
		"domain": "Cross-Domain Synthesis",
		"subtitle": "Stage 5 of 5 — The Nalanda Master Synthesis",
		"question": "Nalanda's Council of Acharyas must execute the Grand Convocation & Manuscript Expedition involving all four disciplines:\n\n• Mathematics: Budget provisions for 300 delegates and preserve 500 palm-leaf manuscripts.\n• Astronomy: Choose the optimal dry celestial window avoiding monsoon rains (Varṣā).\n• Medicine: Formulate pest-repellent oils and restorative nutrition for scribes.\n• Philosophy: Structure the inaugural debate on the unity of valid knowledge (Pramāṇa-samuccaya).\n\nSelect the master plan harmonizing all four disciplines:",
		"options": [
			"A) Schedule in the dry autumn month of Āśvina (Astro); budget 4,500 food measures and 50 vials of neem-turmeric oil (Math & Med); apply anti-insect herbal coatings to manuscripts (Med); and inaugurate with formal epistemological inquiry (Philosophy)",
			"B) Hold the convocation during torrential monsoon in open fields; allocate zero food reserves; use untreated wet leaves; and ban philosophical debate",
			"C) Cancel manuscript preservation and exhaust all resources on decorative banners alone",
			"D) Disband the four disciplines into completely isolated rival schools with zero collaboration"
		],
		"correct": 0,
		"explanation": "A master of Nalanda understands that celestial timing (Astronomy), logistical allocation (Mathematics), organic preservation and health (Medicine), and dialectical debate (Philosophy) must unite as one interconnected body of knowledge.",
		"hint": "A comprehensive plan must integrate accurate seasonal timing, rigorous resource budgeting, effective botanical preservation, and open philosophical inquiry."
	}
]

static func get_stage_count() -> int:
	return STAGES.size()

static func get_stage(index: int) -> Dictionary:
	if index >= 0 and index < STAGES.size():
		return STAGES[index]
	return {}
