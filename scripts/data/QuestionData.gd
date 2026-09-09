class_name QuestionData
extends Object

const DOMAINS: Dictionary = {
	"merchant": {
		"title": "Nalanda Knowledge",
		"intro": "Answer these questions about Nalanda and ancient Indian education.",
		"questions": [
			{
				"question": "What was Nalanda primarily known for?",
				"options": ["A military fort", "A center of higher learning", "A large marketplace", "A royal palace"],
				"answer": 1
			},
			{
				"question": "Nalanda Mahavihara was located in which present-day Indian state?",
				"options": ["Uttar Pradesh", "Bihar", "Madhya Pradesh", "Odisha"],
				"answer": 1
			},
			{
				"question": "Which of these was an important part of life at Nalanda?",
				"options": ["Learning and scholarly debate", "Training large armies", "Shipbuilding", "Mining"],
				"answer": 0
			},
			{
				"question": "Which ancient Indian scholar is strongly associated with mathematics and astronomy?",
				"options": ["Aryabhata", "Kalidasa", "Sushruta", "Panini"],
				"answer": 0
			},
			{
				"question": "What was one important feature of Nalanda?",
				"options": ["It attracted scholars and students from different regions", "It was only open to kings", "It was primarily a military academy", "It was a major seaport"],
				"answer": 0
			},
			{
				"question": "What was the name of the great library at Nalanda?",
				"options": ["Dharmaganja", "Takshashila", "Vikramashila", "Sanchi"],
				"answer": 0
			},
			{
				"question": "Which famous Chinese scholar spent several years studying at Nalanda?",
				"options": ["Xuanzang", "Confucius", "Laozi", "Sun Tzu"],
				"answer": 0
			},
			{
				"question": "What role did the Gatekeeper Scholar (Dvārapāla) play at Nalanda?",
				"options": ["Tested applicants in debate before admission", "Collected road taxes", "Guarded royal treasures", "Trained horses"],
				"answer": 0
			},
			{
				"question": "Who was the renowned Abbot and teacher of Xuanzang at Nalanda?",
				"options": ["Shilabhadra", "Chanakya", "Varahamihira", "Patanjali"],
				"answer": 0
			},
			{
				"question": "Which subjects were studied alongside philosophy at Nalanda?",
				"options": ["Mathematics, Medicine, Astronomy, and Logic", "Archery, Sailing, and Blacksmithing", "Gladiator fighting only", "Mining and Carpentry only"],
				"answer": 0
			}
		]
	},
	"mathematics": {
		"title": "Mathematics (Gaṇita)",
		"intro": "If mathematics is your path, let us see whether you understand the foundations.",
		"questions": [
			{
				"question": "In classical India, what was the science of mathematics known as?",
				"options": ["Gaṇita", "Ayurveda", "Natya", "Silpa"],
				"answer": 0
			},
			{
				"question": "What does the decimal place-value system allow us to do?",
				"options": ["Give digits different values depending on their position", "Draw celestial maps", "Measure body temperature", "Predict ocean tides"],
				"answer": 0
			},
			{
				"question": "Which famous treatise was composed by Aryabhata in 499 CE?",
				"options": ["Āryabhaṭīya", "Charaka Samhita", "Brāhmasphuṭasiddhānta", "Arthashastra"],
				"answer": 0
			},
			{
				"question": "What accurate approximation of Pi (π) was formulated by Aryabhata?",
				"options": ["3.1416 (62832 / 20000)", "3.0000", "4.1250", "2.7182"],
				"answer": 0
			},
			{
				"question": "Which 7th-century mathematician first treated Zero as an operable number with complete arithmetic rules?",
				"options": ["Brahmagupta", "Kalidasa", "Sushruta", "Panini"],
				"answer": 0
			},
			{
				"question": "What is 25 + 17?",
				"options": ["32", "42", "52", "38"],
				"answer": 1
			},
			{
				"question": "If a scholar has 4 manuscripts and receives 3 more, how many do they have in total?",
				"options": ["6", "7", "8", "12"],
				"answer": 1
			},
			{
				"question": "What is 3 × 6?",
				"options": ["12", "15", "18", "21"],
				"answer": 2
			},
			{
				"question": "Which ancient algorithm did Aryabhata develop to solve linear indeterminate equations?",
				"options": ["Kuṭṭaka method", "Calculus limits", "Binary search", "Pythagorean triples only"],
				"answer": 0
			},
			{
				"question": "Which 7th-century mathematician created a famous rational approximation formula for the sine function?",
				"options": ["Bhāskara I", "Chanakya", "Charaka", "Nāgārjuna"],
				"answer": 0
			}
		]
	},
	"astronomy": {
		"title": "Astronomy (Jyotiṣa)",
		"intro": "If astronomy is your path, let us see whether you understand the movements of the cosmos.",
		"questions": [
			{
				"question": "What did ancient Indian scholars observe to measure time, calendars, and seasons?",
				"options": ["Movements of Sun, Moon, planets, and stars", "Growth of tree bark", "Ocean fish migration only", "Mountain heights"],
				"answer": 0
			},
			{
				"question": "What revolutionary astronomical principle was proposed by Aryabhata in 499 CE?",
				"options": ["The Earth is spherical and rotates daily on its axis", "The Earth is stationary and flat", "Stars orbit the ocean", "Sun revolves around the Moon"],
				"answer": 0
			},
			{
				"question": "According to ancient Indian astronomy, why does the Moon shine?",
				"options": ["It reflects light from the Sun", "It produces its own internal fire", "It absorbs starlight only", "It is made of glowing gold"],
				"answer": 0
			},
			{
				"question": "Which ancient instrument used a vertical staff to measure solar shadows and cardinal directions?",
				"options": ["Śaṅku (Gnomon)", "Microscope", "Compass needle", "Telescope lens"],
				"answer": 0
			},
			{
				"question": "How many lunar mansions (Nakṣatras) did ancient Indian astronomy divide the ecliptic sky into?",
				"options": ["27 (or 28)", "12", "365", "64"],
				"answer": 0
			},
			{
				"question": "Which famous northern constellation was known in India as the Saptarṣi?",
				"options": ["Great Bear / Big Dipper (Seven Sages)", "Orion the Hunter", "Southern Cross", "Cassiopeia"],
				"answer": 0
			},
			{
				"question": "Which stationary star was used by ancient navigators to locate true North?",
				"options": ["Dhruva (Polaris / North Star)", "Sirius", "Betelgeuse", "Vega"],
				"answer": 0
			},
			{
				"question": "Which polymath authored the Pañcasiddhāntikā and Bṛhat Saṁhitā?",
				"options": ["Varāhamihira", "Charaka", "Sushruta", "Panini"],
				"answer": 0
			},
			{
				"question": "How did Aryabhata explain solar and lunar eclipses?",
				"options": ["Geometric shadows of Earth and Moon", "Demons swallowing celestial bodies", "Seasonal cloud coverings", "Solar fire extinguishing"],
				"answer": 0
			},
			{
				"question": "Which of these is a star, not a planet?",
				"options": ["Sun", "Mars", "Jupiter", "Venus"],
				"answer": 0
			}
		]
	},
	"medicine": {
		"title": "Medicine (Āyurveda)",
		"intro": "If medicine is your path, let us see whether you understand the art of healing and balance.",
		"questions": [
			{
				"question": "What is the literal meaning of the word 'Āyurveda'?",
				"options": ["Science / Knowledge of Life", "Book of Herbs", "Secret Remedies", "Song of Health"],
				"answer": 0
			},
			{
				"question": "Which classical text on internal medicine is associated with Acharya Charaka?",
				"options": ["Charaka Saṃhitā", "Natya Shastra", "Arthashastra", "Ashtadhyayi"],
				"answer": 0
			},
			{
				"question": "Acharya Sushruta is celebrated worldwide as the ancient pioneer of which medical field?",
				"options": ["Surgery (Śalyatantra)", "Astronomy", "Architecture", "Metal casting"],
				"answer": 0
			},
			{
				"question": "Which surgical innovation was famously pioneered by Sushruta?",
				"options": ["Rhinoplasty (reconstructive nasal surgery)", "Open heart surgery", "X-ray imaging", "Laser eye correction"],
				"answer": 0
			},
			{
				"question": "According to Ayurveda, health is maintained through the dynamic balance of which three doshas?",
				"options": ["Vāta, Pitta, and Kapha", "Gold, Silver, and Copper", "Fire, Ice, and Lightning", "Solid, Liquid, and Gas"],
				"answer": 0
			},
			{
				"question": "Which sacred herb is renowned in Ayurveda for respiratory support, immunity, and fever relief?",
				"options": ["Tulasī (Holy Basil)", "Granite stone", "Copper ore", "Sandalwood bark only"],
				"answer": 0
			},
			{
				"question": "Which medicinal plant is widely celebrated for its antibacterial, antifungal, and blood-purifying properties?",
				"options": ["Nīma (Neem)", "Iron", "Gold", "Charcoal"],
				"answer": 0
			},
			{
				"question": "What is Dinacaryā in the Ayurvedic tradition?",
				"options": ["Daily lifestyle and hygiene routine", "Annual temple festival", "Surgical instrument", "Type of herbal tea"],
				"answer": 0
			},
			{
				"question": "What was the fundamental approach of an Ayurvedic physician before prescribing treatment?",
				"options": ["Detailed clinical observation of patient constitution and signs", "Immediate surgery without examination", "Random herbal mixing", "Ignoring diet and lifestyle"],
				"answer": 0
			},
			{
				"question": "Which rich antioxidant fruit forms the foundation of Ayurvedic Rasāyana (rejuvenative) formulas?",
				"options": ["Āmalakī (Amla / Indian Gooseberry)", "Pineapple", "Dry hay", "Castor root only"],
				"answer": 0
			}
		]
	},
	"philosophy": {
		"title": "Philosophy (Darśana) & Logic",
		"intro": "If philosophy is your path, let us see whether you understand the art of debate and reasoning.",
		"questions": [
			{
				"question": "What is the meaning of the Sanskrit term 'Darśana'?",
				"options": ["Direct vision / View of reality", "Blind memorization", "Silent meditation only", "Written law book"],
				"answer": 0
			},
			{
				"question": "In classical Indian universities like Nalanda, what was 'Vāda'?",
				"options": ["An honest, structured debate seeking truth", "A physical combat tournament", "A musical performance", "A trade negotiation"],
				"answer": 0
			},
			{
				"question": "In Nyāya logic (Hetuvidyā), what is 'Pratyakṣa'?",
				"options": ["Direct sensory perception", "Indirect rumor", "Unproven belief", "Superstition"],
				"answer": 0
			},
			{
				"question": "What is 'Anumāna' in the Indian logical tradition?",
				"options": ["Logical inference (e.g. inferring fire from smoke)", "Poetic rhyming", "Blind assumption", "Physical measurement only"],
				"answer": 0
			},
			{
				"question": "Which philosopher founded the Madhyamaka (Middle Way) school of Buddhist philosophy?",
				"options": ["Nāgārjuna", "Charaka", "Aryabhata", "Varahamihira"],
				"answer": 0
			},
			{
				"question": "Who was the revered Abbot of Nalanda who taught Yogācāra philosophy to Xuanzang in the 7th century?",
				"options": ["Shilabhadra", "Chanakya", "Panini", "Patanjali"],
				"answer": 0
			},
			{
				"question": "Why did scholars at Nalanda emphasize the detection of logical fallacies (Hetvābhāsa)?",
				"options": ["To identify faulty reasoning and defend truth", "To win prizes in games", "To intimidate younger students", "To avoid studying"],
				"answer": 0
			},
			{
				"question": "What is Pratītyasamutpāda, taught in the philosophy of Nāgārjuna?",
				"options": ["Interdependent origination (everything arises dependent on causes)", "Eternal unchanging matter", "Random chaos without cause", "Destruction of all thought"],
				"answer": 0
			},
			{
				"question": "Which famous Buddhist logician composed influential treatises on perception and inference?",
				"options": ["Dharmakīrti", "Kalidasa", "Sushruta", "Bhaskara"],
				"answer": 0
			},
			{
				"question": "If a speaker makes a philosophical assertion, what must a true scholar look for?",
				"options": ["Valid evidence (Pramāṇa) and sound logical reasons", "Whether the speaker is wealthy", "Loudness of voice", "Accept it without questioning"],
				"answer": 0
			}
		]
	}
}

static func get_domain_info(domain_id: String) -> Dictionary:
	var key := domain_id.to_lower().strip_edges()
	if key == "math" or key == "gaṇita" or key == "ganita":
		key = "mathematics"
	elif key == "astro" or key == "jyotiṣa" or key == "jyotisha":
		key = "astronomy"
	elif key == "med" or key == "āyurveda" or key == "ayurveda":
		key = "medicine"
	elif key == "phil" or key == "logic" or key == "darśana" or key == "darshana" or key == "tarka":
		key = "philosophy"
		
	if DOMAINS.has(key):
		return DOMAINS[key]
	return {}

static func get_questions(domain_id: String) -> Array:
	var info := get_domain_info(domain_id)
	return info.get("questions", [])

static func get_domain_title(domain_id: String) -> String:
	var info := get_domain_info(domain_id)
	return info.get("title", "Unknown Domain")

static func get_domain_intro(domain_id: String) -> String:
	var info := get_domain_info(domain_id)
	return info.get("intro", "")
