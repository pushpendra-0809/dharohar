class_name MedicineCases
extends Node

static func get_cases() -> Array:
	return [
		{
			"id": 1,
			"title": "Sun Travel & Fatigue",
			"description": "A traveller has been walking under the intense afternoon sun for many hours across the Bihar plains. He feels overheated, parched, and fatigued.",
			"clues": [
				"Long exposure to heat",
				"Thirst and dehydration",
				"Fatigue and weakness"
			],
			"available_herbs": ["Tulsi", "Neem", "Ginger", "Turmeric", "Amla", "Ashoka"],
			"correct_answers": ["Amla", "Tulsi"],
			"max_selections": 2,
			"hint": "Look for cooling fruit berries and sacred restorative leaves.",
			"explanation": "In historical treatises, Amla was valued for its cooling properties and Tulsi for restoring vital energy."
		},
		{
			"id": 2,
			"title": "Sluggish Digestion",
			"description": "A scholar studying late in the library after a heavy meal experiences stomach heaviness, sluggish digestion, and mild nausea.",
			"clues": [
				"Heavy meal discomfort",
				"Sluggish digestion",
				"Mild nausea"
			],
			"available_herbs": ["Tulsi", "Neem", "Ginger", "Turmeric", "Amla", "Ashoka"],
			"correct_answers": ["Ginger", "Turmeric"],
			"max_selections": 2,
			"hint": "Warming rhizomes were traditionally chosen to ignite digestive fire.",
			"explanation": "Ancient scholars recorded Ginger and Turmeric as warming rhizomes that aid digestion."
		},
		{
			"id": 3,
			"title": "Skin & Bitter Cleansing",
			"description": "A pilgrim arriving at the university gate suffers from skin irritation caused by trail dust and seeks traditional herbal purification.",
			"clues": [
				"Skin irritation from trail dust",
				"Need for bitter cleansing",
				"External herbal wash preparation"
			],
			"available_herbs": ["Tulsi", "Neem", "Ginger", "Turmeric", "Amla", "Ashoka"],
			"correct_answers": ["Neem", "Turmeric"],
			"max_selections": 2,
			"hint": "Bitter leaves and golden roots were noted in ancient texts for skin purification.",
			"explanation": "Neem's bitter leaves and Turmeric's purifying root were widely documented in ancient Nalanda texts."
		},
		{
			"id": 4,
			"title": "Seasonal Rejuvenation",
			"description": "As winter transitions to spring, several young scholars feel general weakness and seasonal discomfort during early morning chants.",
			"clues": [
				"Seasonal change discomfort",
				"General bodily weakness",
				"Immunity and vigor support"
			],
			"available_herbs": ["Tulsi", "Neem", "Ginger", "Turmeric", "Amla", "Ashoka"],
			"correct_answers": ["Tulsi", "Ginger", "Amla"],
			"max_selections": 3,
			"hint": "A balanced combination of leaves, warming root, and vitamin fruit.",
			"explanation": "Tulsi, Ginger, and Amla formed a classic Ayurvedic trio for seasonal vigor."
		},
		{
			"id": 5,
			"title": "Scholar Exhaustion & Purification",
			"description": "A senior monk preparing for a major debate experiences deep fatigue, overheated blood, and physical exhaustion.",
			"clues": [
				"Mental exhaustion after manuscript study",
				"Bitter blood purification requirement",
				"Soothing bark decoction"
			],
			"available_herbs": ["Tulsi", "Neem", "Ginger", "Turmeric", "Amla", "Ashoka"],
			"correct_answers": ["Tulsi", "Neem", "Ashoka"],
			"max_selections": 3,
			"hint": "Combine bitter cleansing leaves, cooling tree bark, and sacred restorative herbs.",
			"explanation": "Scholars relied on Neem for purification, Ashoka bark for soothing balance, and Tulsi for mental clarity."
		}
	]
