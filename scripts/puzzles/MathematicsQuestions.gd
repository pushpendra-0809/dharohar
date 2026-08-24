class_name MathematicsQuestions
extends Node

static func get_questions() -> Array:
	return [
		{
			"id": 1,
			"title": "Manuscript Calculation",
			"question": "A scholar has 4 bundles of manuscripts. Each bundle contains 12 manuscripts. How many manuscripts does the scholar have in total?",
			"target_answer": "48",
			"equation_hint": "4 × 12 = ?",
			"category": "Multiplication"
		},
		{
			"id": 2,
			"title": "Scroll Assembly",
			"question": "The library received 35 palm-leaf scrolls in the morning and 27 scrolls in the evening. How many scrolls were received in total?",
			"target_answer": "62",
			"equation_hint": "35 + 27 = ?",
			"category": "Addition"
		},
		{
			"id": 3,
			"title": "Monastery Grain Storage",
			"question": "A monastery stored 90 measures of rice. The kitchen used 43 measures for the daily meal. How many measures of rice remain?",
			"target_answer": "47",
			"equation_hint": "90 - 43 = ?",
			"category": "Subtraction"
		},
		{
			"id": 4,
			"title": "Tablet Distribution",
			"question": "A master teacher wishes to distribute 84 clay tablets equally among 7 disciples. How many tablets does each disciple receive?",
			"target_answer": "12",
			"equation_hint": "84 ÷ 7 = ?",
			"category": "Division"
		},
		{
			"id": 5,
			"title": "Monastery Chimes Pattern",
			"question": "Observe the sequence of monastery chimes: 3, 6, 12, 24, __. What is the next number in the pattern?",
			"target_answer": "48",
			"equation_hint": "24 × 2 = ?",
			"category": "Pattern Reasoning"
		}
	]
