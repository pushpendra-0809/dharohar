class_name MedicineMasteryData
extends RefCounted

# ==============================================================================
# DHAROHAR 1.0 — MEDICINE MASTERY (3 LEVELS)
# ==============================================================================
# Level 1: The Healer's Eye (Patient Observation & Symptom Extraction)
# Level 2: The Right Remedy (Herb Selection, Formulation & Ancient Preparation Method)
# Level 3: The Healer's Final Case (Comprehensive Diagnosis, Rasayana & Pathya Counsel)
# ==============================================================================

const LEVELS: Array[Dictionary] = [
	{
		"id": "healers_eye",
		"level_number": 1,
		"title": "The Healer's Eye",
		"nav_label": "1. The Healer's Eye",
		"subtitle": "Level 1 of 3 — Patient Observation & Clinical Symptom Recognition",
		"instructions": "Examine the patient's visible presentation, listen to their complaints, and extract the exact matching symptoms into the Healer's Notes.",
		"complete_quote": "Observation is the first pillar of Chikitsa. Before any herb is touched, the patient must be understood.",
		"cases": [
			{
				"title": "Case 1: The Weary Pilgrim",
				"patient_desc": "A traveler from the southern plains arrives at the Nalanda dispensary after weeks on the trail. They appear drained, their posture is drooping, face is unusually pale, and they speak with a faint, weary voice.",
				"visible_signs": "• Pallor and loss of natural radiance\n• Severe fatigue and heavy limbs\n• Inability to sustain physical exertion",
				"symptom_pool": [
					{"id": "fatigue", "name": "Deep Physical Fatigue", "is_relevant": true},
					{"id": "pallor", "name": "Pale Complexion (Panduta)", "is_relevant": true},
					{"id": "weakness", "name": "General Body Weakness (Daurbalya)", "is_relevant": true},
					{"id": "high_fever", "name": "High Burning Fever (Jwara)", "is_relevant": false},
					{"id": "burning_rash", "name": "Severe Red Skin Rash", "is_relevant": false}
				],
				"required_symptoms": ["fatigue", "pallor", "weakness"],
				"explanation": "The pilgrim presents classical signs of Dhatukshaya (tissue depletion and exhaustion) characterized by fatigue, pallor, and muscular weakness without infectious fever.",
				"hint": "Focus on the patient's exhaustion, paleness, and weakness. There is no fever or skin rash mentioned."
			},
			{
				"title": "Case 2: The Scribe with Digestive Torpor",
				"patient_desc": "A dedicated library scribe reports discomfort after simple meals. They feel constant heaviness in the epigastrium, low digestive fire (Mandaagni), lack of appetite, and sluggishness throughout study sessions.",
				"visible_signs": "• Heaviness in the abdomen after light food\n• Complete lack of natural appetite (Aruchi)\n• Dull digestive fire with lethargy",
				"symptom_pool": [
					{"id": "sluggish_fire", "name": "Sluggish Digestive Fire (Mandaagni)", "is_relevant": true},
					{"id": "heaviness", "name": "Abdominal Heaviness (Gaurava)", "is_relevant": true},
					{"id": "loss_appetite", "name": "Loss of Appetite (Aruchi)", "is_relevant": true},
					{"id": "extreme_thirst", "name": "Intense Excessive Thirst (Trishna)", "is_relevant": false},
					{"id": "joint_pain", "name": "Sharp Knee Joint Swelling", "is_relevant": false}
				],
				"required_symptoms": ["sluggish_fire", "heaviness", "loss_appetite"],
				"explanation": "The scribe suffers from Kapha-induced Mandaagni with digestive stagnation, causing abdominal heaviness and anorexia without unquenchable thirst or joint pathology.",
				"hint": "Select the three signs directly related to the scribe's slow digestion, heaviness, and lost appetite."
			},
			{
				"title": "Case 3: The Scholar with Ocular Heat & Strain",
				"patient_desc": "After weeks of late-night manuscript copying under oil lamps, a scholar complains of burning in the eyes, sharp sensitivity to sunlight, dryness, and restless agitated sleep.",
				"visible_signs": "• Burning and irritation in both eyes (Netra Daha)\n• High photophobia and dryness\n• Irritation and disrupted sleep cycle",
				"symptom_pool": [
					{"id": "eye_burning", "name": "Burning Sensation in Eyes (Netra Daha)", "is_relevant": true},
					{"id": "eye_strain", "name": "Visual Strain & Dryness (Shushkakshipaka)", "is_relevant": true},
					{"id": "restlessness", "name": "Mental Heat & Restless Sleep", "is_relevant": true},
					{"id": "productive_cough", "name": "Heavy Phlegm & Chest Cough", "is_relevant": false},
					{"id": "nausea", "name": "Persistent Morning Nausea", "is_relevant": false}
				],
				"required_symptoms": ["eye_burning", "eye_strain", "restlessness"],
				"explanation": "Alochataka Pitta aggravation and Vata dryness from prolonged nocturnal strain produce ocular burning, fatigue, and restless heat without pulmonary symptoms.",
				"hint": "Identify the symptoms of ocular burning, light sensitivity/strain, and nighttime restlessness."
			}
		]
	},
	{
		"id": "right_remedy",
		"level_number": 2,
		"title": "The Right Remedy",
		"nav_label": "2. The Right Remedy",
		"subtitle": "Level 2 of 3 — Herbal Selection, Formulation & Classical Preparation",
		"instructions": "Stand at the ancient apothecary bench. Select the specific synergistic herbs for the diagnosed condition and choose the proper classical preparation method.",
		"complete_quote": "An herb without proper preparation is like knowledge without discernment. The method unlocks the healing power.",
		"cases": [
			{
				"title": "Preparation 1: Vitality & Strength Restorative",
				"diagnosis_summary": "Condition: Dhatukshaya & Physical Debility (Deep exhaustion in the weary traveler).",
				"target_goal": "Select 3 nourishing Balya (strength-promoting) herbs and the suitable preparation technique.",
				"available_herbs": [
					{"id": "ashwagandha", "name": "Ashwagandha (Withania)", "prop": "Nourishing root that builds Ojas & strength", "is_correct": true},
					{"id": "shatavari", "name": "Shatavari (Asparagus)", "prop": "Cooling tonic for vitality & tissues", "is_correct": true},
					{"id": "gokshura", "name": "Gokshura (Tribulus)", "prop": "Rejuvenator for physical stamina", "is_correct": true},
					{"id": "kutaki", "name": "Kutaki (Picrorhiza)", "prop": "Intensely bitter purgative", "is_correct": false},
					{"id": "bhallataka", "name": "Bhallataka (Marking Nut)", "prop": "Caustic heating irritant", "is_correct": false}
				],
				"required_herbs": ["ashwagandha", "shatavari", "gokshura"],
				"preparation_methods": [
					{"id": "churna", "label": "Fine Micro-Powder (Sukshma Churna) with Warm Milk & Ghee", "is_correct": true},
					{"id": "fermented_asava", "label": "Heavy Alcoholic Fermentation (Asava)", "is_correct": false},
					{"id": "cold_wash", "label": "External Saline Rinse", "is_correct": false}
				],
				"explanation": "Ashwagandha, Shatavari, and Gokshura form the classical triad of Rasayana herbs. Finely powdered into Churna and taken with warm milk (Ksheera), they rebuild vital Ojas and muscle vigor.",
				"hint": "Select the three nourishing tonic herbs (Ashwagandha, Shatavari, Gokshura) and choose the warm milk Churna formulation."
			},
			{
				"title": "Preparation 2: Digestive Fire (Deepana-Pachana) Elixir",
				"diagnosis_summary": "Condition: Mandaagni & Abdominal Stagnation (Sluggish digestion & heavy belly in the scribe).",
				"target_goal": "Select 3 aromatic carminative herbs and the classical hot extraction method.",
				"available_herbs": [
					{"id": "shunthi", "name": "Shunthi (Dry Ginger)", "prop": "Kindles Agni without aggravating bile", "is_correct": true},
					{"id": "maricha", "name": "Maricha (Black Pepper)", "prop": "Pungent stimulant that clears Kapha", "is_correct": true},
					{"id": "pippali", "name": "Pippali (Long Pepper)", "prop": "Deep digestive activator & bio-enhancer", "is_correct": true},
					{"id": "sariva", "name": "Sariva (Indian Sarsaparilla)", "prop": "Sweet cooling blood purifier", "is_correct": false},
					{"id": "chandan", "name": "Chandan (Sandalwood)", "prop": "Heavy sedative cooling wood", "is_correct": false}
				],
				"required_herbs": ["shunthi", "maricha", "pippali"],
				"preparation_methods": [
					{"id": "kashaya", "label": "Boiled Decoction (Kashaya / Kwatha) reduced to one-fourth", "is_correct": true},
					{"id": "cold_paste", "label": "Raw Frozen Pulp", "is_correct": false},
					{"id": "oil_enema", "label": "Heavy Unctuous Enema", "is_correct": false}
				],
				"explanation": "The Trikatu formulation (Shunthi, Maricha, Pippali) boiled as a hot decoction (Kwatha) directly stimulates digestive enzymes and dispels accumulated metabolic toxins (Ama).",
				"hint": "Combine the three pungent digestive spices (Trikatu: Shunthi, Maricha, Pippali) with a boiled reduction decoction (Kwatha)."
			},
			{
				"title": "Preparation 3: Ocular Heat & Eye Strain Soothing Ghee",
				"diagnosis_summary": "Condition: Pitta Eye Heat & Nocturnal Strain (Burning visual fatigue in the scholar).",
				"target_goal": "Select 3 cooling, Pitta-pacifying eye herbs and the classical medicated ghee method.",
				"available_herbs": [
					{"id": "triphala", "name": "Amalaki / Triphala", "prop": "Supreme Chakshushya (eye-nourishing) Rasayana", "is_correct": true},
					{"id": "yashtimadhu", "name": "Yashtimadhu (Licorice)", "prop": "Sweet, soothing cooling anti-inflammatory", "is_correct": true},
					{"id": "daruharidra", "name": "Daruharidra (Tree Turmeric)", "prop": "Potent ocular tonic that clears deep heat", "is_correct": true},
					{"id": "hingu", "name": "Hingu (Asafoetida)", "prop": "Intensely pungent and heating resin", "is_correct": false},
					{"id": "chitraka", "name": "Chitraka (Leadwort)", "prop": "Caustic internal fire stimulator", "is_correct": false}
				],
				"required_herbs": ["triphala", "yashtimadhu", "daruharidra"],
				"preparation_methods": [
					{"id": "ghrita", "label": "Medicated Ghee (Siddha Ghrita) prepared by slow simmering", "is_correct": true},
					{"id": "dry_smoke", "label": "Astringent Smoke Inhalation (Dhuma)", "is_correct": false},
					{"id": "vinegar_wash", "label": "Fermented Acidic Rinse", "is_correct": false}
				],
				"explanation": "Triphala, Yashtimadhu, and Daruharidra cooked slowly with pure cow ghee (Ghrita) create the classical Triphala Ghrita, pacifying Alochaka Pitta and soothing strained ocular tissues.",
				"hint": "Choose the eye-rejuvenating herbs (Triphala, Yashtimadhu, Daruharidra) and select Medicated Ghee (Ghrita)."
			}
		]
	},
	{
		"id": "final_case",
		"level_number": 3,
		"title": "The Healer's Final Case",
		"nav_label": "3. Final Case",
		"subtitle": "Level 3 of 3 — Comprehensive Diagnosis, Formulation, Vehicle & Pathya Counsel",
		"instructions": "Analyze the master physician's clinical dossier from the Nalanda Arogyashala. Stamp all 5 clinical parameters into your Healer's Ledger and submit the final treatment protocol.",
		"complete_quote": "You did not simply remember remedies. You observed carefully, connected what you saw with what you had learned, and chose your response with purpose. That is the beginning of a true healer's understanding.",
		"scenario": {
			"title": "CLINICAL DOSSIER — THE SENIOR SCHOLAR OF DHARMAGANJA",
			"context": "A senior scholar of the Dharmaganja library, having spent consecutive rainy seasons in intense philosophical composition and debate, presents to the hospital. He experiences severe mental exhaustion, chronic insomnia, dryness of tongue, trembling fingers, and intermittent poor digestion with nervousness. His pulse is irregular and rapid (Vata dominant with secondary Pitta heat). He urgently requires a restorative, neuro-protective, and harmonizing treatment plan before the grand congregation.",
			"fields": [
				{
					"key": "diagnosis",
					"title": "1. Primary Dosha Diagnosis",
					"options": [
						"Kapha Congestion with Heavy Stagnation",
						"Vata-Pitta Aggravation with Manasika Shrama (Mental Strain)",
						"Acute Pitta Jwara (Infectious High Fever)",
						"Isolated Raktadushti (Blood Toxin Excess)"
					],
					"correct": 1,
					"clue": "Tremors, insomnia, dryness, and anxiety indicate severe Vata disturbance with secondary Pitta mental heat."
				},
				{
					"key": "formulation",
					"title": "2. Prescribed Classical Formulation",
					"options": [
						"Brahmi-Ashwagandha Medhya Rasayana",
						"Tikta Ghritha Eye Irrigation",
						"Hingwashtaka Churna with Salt",
						"Kasisadi Lepa (External Paste)"
					],
					"correct": 0,
					"clue": "Medhya Rasayana herbs specifically nourish intellect, memory, nervous tissue (Majja), and sleep."
				},
				{
					"key": "herbs",
					"title": "3. Core Herbal Composition",
					"options": [
						"Haritaki + Bibhitaki + Amalaki (Triphala)",
						"Brahmi + Ashwagandha + Shankhpushpi + Yashtimadhu",
						"Kutaja + Bilva + Dhataki",
						"Musta + Ativisha + Shunthi"
					],
					"correct": 1,
					"clue": "Brahmi, Ashwagandha, and Shankhpushpi form the foremost Medhya (brain-tonic) and adaptogenic synergy."
				},
				{
					"key": "vehicle",
					"title": "4. Preparation & Vehicle (Anupana)",
					"options": [
						"Cold Fermented Vinegar at Midnight",
						"Warm Decoction infused with Medicated Ghee (Ghrita) & Milk",
						"Raw Dry Powder washed down with Cold Well Water",
						"High-Alcohol Pungent Tincture on Empty Stomach"
					],
					"correct": 1,
					"clue": "Ghee and warm milk pacify Vata, carry herbs across tissue barriers, and restore vitality (Ojas)."
				},
				{
					"key": "pathya",
					"title": "5. Vaidya's Dietary & Lifestyle Counsel (Pathya)",
					"options": [
						"Fasting for 3 days and cold midnight baths",
						"Warm unctuous meals, daily Abhyanga (warm oil massage) & restful sleep",
						"Pungent mustard dishes and late night debates",
						"Vigorous running and dry roasted grains"
					],
					"correct": 1,
					"clue": "Vata requires warm, unctuous nourishing food, gentle oil massage (Abhyanga), and restorative stillness."
				}
			],
			"synthesis": {
				"title": "THE HEALER'S DECISION IS CORRECT",
				"summary": "Your comprehensive Ayurvedic treatment protocol achieves perfect clinical harmony:\n\n• [b]Vata-Pitta Diagnosis[/b] accurately identifies the root mental exhaustion and nervous depletion.\n• [b]Medhya Rasayana[/b] with [b]Brahmi, Ashwagandha & Shankhpushpi[/b] rejuvenates higher cognitive faculties and calms the restless nervous system (Majja Dhatu).\n• [b]Medicated Ghee & Warm Milk[/b] serves as the optimal lipophilic Anupana, delivering herbal actives deep into brain tissues.\n• [b]Pathya Regimen[/b] with warm Abhyanga and unctuous diet stabilizes Vata, ensuring lasting recovery.",
				"quote": "True Chikitsa is not the suppression of a complaint, but the restoration of harmony between Body, Mind, and Nature."
			}
		}
	}
]

static func get_level_count() -> int:
	return LEVELS.size()

static func get_level(idx: int) -> Dictionary:
	if idx >= 0 and idx < LEVELS.size():
		return LEVELS[idx]
	return {}

static func get_level_by_id(level_id: String) -> Dictionary:
	var l_id: String = level_id.to_lower().strip_edges()
	for lvl in LEVELS:
		if str(lvl.get("id", "")).to_lower() == l_id:
			return lvl
	return {}
