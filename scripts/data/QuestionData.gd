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
			}
		]
	},
	"mathematics": {
		"title": "Mathematics",
		"intro": "If mathematics is your path, let us see whether you understand the foundations.",
		"questions": [
			{
				"question": "What is 25 + 17?",
				"options": ["32", "42", "52", "38"],
				"answer": 1
			},
			{
				"question": "If one student has 4 manuscripts and another has 3, how many do they have together?",
				"options": ["6", "7", "8", "12"],
				"answer": 1
			},
			{
				"question": "What does the place-value system allow us to do?",
				"options": ["Give digits different values depending on their position", "Draw maps", "Measure temperature", "Identify stars"],
				"answer": 0
			},
			{
				"question": "Which scholar is strongly associated with ancient Indian mathematics and astronomy?",
				"options": ["Aryabhata", "Charaka", "Sushruta", "Kalidasa"],
				"answer": 0
			},
			{
				"question": "What is 3 × 6?",
				"options": ["12", "15", "18", "21"],
				"answer": 2
			}
		]
	},
	"astronomy": {
		"title": "Astronomy",
		"intro": "If astronomy is your path, let us see whether you understand the movements of the cosmos.",
		"questions": [
			{
				"question": "Which of these is a star?",
				"options": ["Moon", "Sun", "Earth", "Mars"],
				"answer": 1
			},
			{
				"question": "Which scholar is famous for important work in Indian astronomy?",
				"options": ["Aryabhata", "Charaka", "Sushruta", "Panini"],
				"answer": 0
			},
			{
				"question": "What do astronomers primarily study?",
				"options": ["Celestial objects and phenomena", "Plants", "Human diseases", "Architecture"],
				"answer": 0
			},
			{
				"question": "Which of these is a planet?",
				"options": ["Moon", "Sun", "Mars", "Polaris"],
				"answer": 2
			},
			{
				"question": "Why was observing the sky important to ancient scholars?",
				"options": ["To understand celestial movements and develop calendars", "To build weapons", "To make pottery", "To grow forests"],
				"answer": 0
			}
		]
	},
	"medicine": {
		"title": "Medicine",
		"intro": "If medicine is your path, let us see whether you understand the art of healing and balance.",
		"questions": [
			{
				"question": "Which ancient Indian medical text is associated with Charaka?",
				"options": ["Charaka Samhita", "Arthashastra", "Natya Shastra", "Ashtadhyayi"],
				"answer": 0
			},
			{
				"question": "Sushruta is particularly associated with:",
				"options": ["Surgery", "Astronomy", "Mathematics", "Architecture"],
				"answer": 0
			},
			{
				"question": "What was an important focus of Ayurveda?",
				"options": ["Health and maintaining balance in the body", "Building temples", "Studying stars", "Military strategy"],
				"answer": 0
			},
			{
				"question": "Which of these would be most relevant to a physician?",
				"options": ["Understanding medicinal plants", "Mapping constellations", "Building bridges", "Studying warfare"],
				"answer": 0
			},
			{
				"question": "Which of these is a plant?",
				"options": ["Neem", "Iron", "Copper", "Granite"],
				"answer": 0
			}
		]
	},
	"philosophy": {
		"title": "Philosophy",
		"intro": "If philosophy is your path, let us see whether you understand the art of debate and reasoning.",
		"questions": [
			{
				"question": "What does philosophy generally involve?",
				"options": ["Examining ideas and questions about knowledge, reality and ethics", "Building houses", "Growing crops", "Measuring rainfall"],
				"answer": 0
			},
			{
				"question": "What is a debate?",
				"options": ["A structured exchange of different viewpoints", "A type of farming", "A mathematical symbol", "A building technique"],
				"answer": 0
			},
			{
				"question": "Why would scholars engage in debate?",
				"options": ["To examine and challenge ideas", "To prepare food", "To construct roads", "To trade goods"],
				"answer": 0
			},
			{
				"question": "Which skill is especially useful in philosophical debate?",
				"options": ["Logical reasoning", "Sword fighting", "Painting", "Farming"],
				"answer": 0
			},
			{
				"question": "If someone makes a claim, what should a good scholar do?",
				"options": ["Examine the reasoning and evidence behind it", "Accept it immediately", "Ignore it", "Change the subject"],
				"answer": 0
			}
		]
	}
}

static func get_domain_info(domain_id: String) -> Dictionary:
	var key := domain_id.to_lower()
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
