class_name MathematicsMasteryData
extends RefCounted

# ==============================================================================
# DHAROHAR 1.0 — MATHEMATICS MASTERY (3 LEVELS)
# ==============================================================================
# Level 1: The Numbers (5 tasks — sequence/number recognition)
# Level 2: The Scholar's Calculation (5 tasks — practical arithmetic distribution)
# Level 3: The Final Problem (Multi-step Nalanda logistical reasoning)
# ==============================================================================

const LEVELS: Array[Dictionary] = [
	{
		"id": "numbers",
		"level_number": 1,
		"title": "The Numbers",
		"nav_label": "1. The Numbers",
		"subtitle": "Level 1 of 3 — Number Recognition & Sequence Thinking",
		"concept": "Ancient Sequence & Decimal Progression",
		"instructions": "Examine the mathematical sequence on the scholar's slate and select the tile that completes the progression.",
		"complete_quote": "You recognized the pattern. But numbers are useful only when we know how to apply them.",
		"tasks": [
			{
				"prompt": "Identify the number that completes this fundamental sequence:",
				"sequence_display": "2   ⟶   4   ⟶   6   ⟶   [ ? ]",
				"rule_hint": "Pattern: Step increases by +2 each transition",
				"options": ["7", "8", "9", "10"],
				"correct": 1,
				"explanation": "Adding 2 to 6 yields 8. The sequence follows an arithmetic step of +2.",
				"hint": "Look at the difference between each pair: 4 - 2 = 2, 6 - 4 = 2."
			},
			{
				"prompt": "Identify the missing value in this quinquennial count:",
				"sequence_display": "5   ⟶   10   ⟶   15   ⟶   [ ? ]",
				"rule_hint": "Pattern: Multiples of 5 (Step +5)",
				"options": ["18", "20", "25", "30"],
				"correct": 1,
				"explanation": "Adding 5 to 15 gives 20 (the fourth multiple of 5).",
				"hint": "Notice that each number increases by 5."
			},
			{
				"prompt": "Determine the next term in the triple progression:",
				"sequence_display": "3   ⟶   6   ⟶   9   ⟶   [ ? ]",
				"rule_hint": "Pattern: Multiples of 3 (Step +3)",
				"options": ["10", "11", "12", "15"],
				"correct": 2,
				"explanation": "Adding 3 to 9 yields 12 (3 × 4 = 12).",
				"hint": "The sequence increments by 3 at every stage."
			},
			{
				"prompt": "Determine the subsequent decimal decade (Dasa-vriddhi):",
				"sequence_display": "10   ⟶   20   ⟶   30   ⟶   [ ? ]",
				"rule_hint": "Pattern: Multiples of 10 (Decimal place increments)",
				"options": ["35", "40", "45", "50"],
				"correct": 1,
				"explanation": "Incrementing by 10 from 30 gives 40 (Chatvarimshat).",
				"hint": "Add 10 to 30 to find the next decade."
			},
			{
				"prompt": "Identify the next number in the quadruple sequence:",
				"sequence_display": "4   ⟶   8   ⟶   12   ⟶   [ ? ]",
				"rule_hint": "Pattern: Multiples of 4 (Step +4)",
				"options": ["14", "16", "18", "20"],
				"correct": 1,
				"explanation": "Adding 4 to 12 results in 16 (4 × 4 = 16).",
				"hint": "Each stone count rises by exactly 4."
			}
		]
	},
	{
		"id": "calculation",
		"level_number": 2,
		"title": "The Scholar's Calculation",
		"nav_label": "2. The Scholar's Calculation",
		"subtitle": "Level 2 of 3 — Practical Resource Distribution & Arithmetic",
		"concept": "Equitable Allocation & Foundational Arithmetic",
		"instructions": "Solve the practical Nalanda logistical calculations to ensure all students and halls receive exact provisions.",
		"complete_quote": "You can calculate. But mastery is not simply finding an answer. It is knowing how to use that answer.",
		"tasks": [
			{
				"prompt": "A senior scholar has 48 palm-leaf manuscripts and wishes to distribute them equally among 6 student circles.

How many manuscripts does each student circle receive?",
				"ledger_title": "📜 MANUSCRIPT DISTRIBUTION LEDGER",
				"ledger_data": "📦 Total Manuscripts: 48    |    👥 Student Circles: 6",
				"ledger_formula": "48 ÷ 6 = ?",
				"algebraic_operation": "Let x = manuscripts per circle\n6 · x = 48   ⟹   x = 48 ÷ 6 = 8",
				"algebraic_formula": "📐 Algebraic Formula: Total Manuscripts ÷ Student Circles = 48 ÷ 6 = 8",
				"options": ["6 manuscripts", "8 manuscripts", "10 manuscripts", "12 manuscripts"],
				"correct": 1,
				"explanation": "48 divided equally among 6 circles gives exactly 8 manuscripts per circle (48 ÷ 6 = 8).",
				"hint": "Recall which number multiplied by 6 equals 48."
			},
			{
				"prompt": "The university repository has 35 wooden writing boards. 15 boards are already in active use by senior scribes.

How many writing boards remain available?",
				"ledger_title": "✍️ WRITING BOARD INVENTORY",
				"ledger_data": "📋 Total Boards: 35    |    ✍️ In Active Use: 15",
				"ledger_formula": "35 − 15 = ?",
				"algebraic_operation": "Let x = available writing boards\nx + 15 = 35   ⟹   x = 35 − 15 = 20",
				"algebraic_formula": "📐 Algebraic Formula: Total Boards − Boards In Use = 35 − 15 = 20",
				"options": ["15 boards", "20 boards", "25 boards", "30 boards"],
				"correct": 1,
				"explanation": "35 total boards minus 15 in use leaves exactly 20 available boards (35 − 15 = 20).",
				"hint": "Subtract 15 from 35."
			},
			{
				"prompt": "6 study groups each require 8 writing boards for their morning treatise drafting.

How many writing boards are needed in total?",
				"ledger_title": "🏛️ STUDY GROUP PROVISIONING",
				"ledger_data": "👥 Study Groups: 6    |    📋 Boards Per Group: 8",
				"ledger_formula": "6 × 8 = ?",
				"algebraic_operation": "Let x = total writing boards needed\nx = 6 × 8   ⟹   x = 48",
				"algebraic_formula": "📐 Algebraic Formula: Study Groups × Boards Per Group = 6 × 8 = 48",
				"options": ["42 boards", "48 boards", "54 boards", "56 boards"],
				"correct": 1,
				"explanation": "6 groups of 8 boards require 48 boards in total (6 × 8 = 48).",
				"hint": "Multiply 6 by 8."
			},
			{
				"prompt": "4 study halls in the monastery each require 7 brass oil lamps for evening research.

How many lamps are required in total?",
				"ledger_title": "🪔 STUDY HALL ILLUMINATION",
				"ledger_data": "🏛️ Study Halls: 4    |    🪔 Lamps Per Hall: 7",
				"ledger_formula": "4 × 7 = ?",
				"algebraic_operation": "Let x = total lamps required\nx = 4 × 7   ⟹   x = 28",
				"algebraic_formula": "📐 Algebraic Formula: Study Halls × Lamps Per Hall = 4 × 7 = 28",
				"options": ["24 lamps", "28 lamps", "32 lamps", "35 lamps"],
				"correct": 1,
				"explanation": "4 study halls each needing 7 lamps require 28 lamps altogether (4 × 7 = 28).",
				"hint": "Multiply 4 by 7."
			},
			{
				"prompt": "The university granary has 72 measures of barley grain to be divided equally over 9 weeks of study.

How many measures are consumed each week?",
				"ledger_title": "🌾 MONASTERY GRANARY ALLOCATION",
				"ledger_data": "📦 Total Grain: 72 Measures    |    ⏳ Study Duration: 9 Weeks",
				"ledger_formula": "72 ÷ 9 = ?",
				"algebraic_operation": "Let x = grain consumed per week\n9 · x = 72   ⟹   x = 72 ÷ 9 = 8",
				"algebraic_formula": "📐 Algebraic Formula: Total Grain ÷ Study Duration = 72 ÷ 9 = 8",
				"options": ["6 measures", "7 measures", "8 measures", "9 measures"],
				"correct": 2,
				"explanation": "72 measures divided equally over 9 weeks yields 8 measures per week (72 ÷ 9 = 8).",
				"hint": "Think: what number multiplied by 9 gives 72?"
			}
		]
	},
	{
		"id": "final_problem",
		"level_number": 3,
		"title": "The Final Problem",
		"nav_label": "3. The Final Problem",
		"subtitle": "Level 3 of 3 — Multi-Step Practical Logistical Synthesis",
		"concept": "Multi-Step Logistical Reasoning & Synthesis",
		"instructions": "Solve the comprehensive Nalanda campus logistics problem through a structured multi-step reasoning workspace.",
		"complete_quote": "You did not simply remember the numbers. You understood them. You used them to solve a real problem. That is the beginning of mastery.",
		"problem_pool": [
			{
				"id": "boards_problem",
				"title": "University Writing Board Provisioning",
				"context": "Nalanda University is organizing 6 new academic circles. Each circle requires 8 wooden writing boards for their scripture studies. The repository currently holds 18 writing boards in storage.",
				"target_question": "How many additional writing boards must the carpenter craft?",
				"step1": {
					"title": "STEP 1: Calculate Total Writing Boards Required",
					"prompt": "Calculate the total number of writing boards needed for all 6 circles (6 circles × 8 boards each):",
					"formula_display": "6 Circles × 8 Boards = [ ? ]",
					"options": ["42 boards", "48 boards", "54 boards", "56 boards"],
					"correct": 1,
					"value": 48,
					"explanation": "6 groups × 8 boards = 48 total boards required."
				},
				"step2": {
					"title": "STEP 2: Deduct Available Repository Stock",
					"prompt": "Subtract the 18 writing boards already available in storage from the total required:",
					"formula_display": "48 Required − 18 In Storage = [ ? ]",
					"options": ["26 boards", "28 boards", "30 boards", "32 boards"],
					"correct": 2,
					"value": 30,
					"explanation": "48 total needed − 18 in storage = 30 additional boards needed."
				},
				"summary": {
					"final_answer": "30 Additional Writing Boards",
					"breakdown": "Total Required: 48 Boards  |  In Storage: 18 Boards  |  Crafting Order: 30 Boards\nSynthesis Formula: (6 × 8) − 18 = 30"
				}
			},
			{
				"id": "manuscript_problem",
				"title": "Scholarly Manuscript Distribution",
				"context": "5 senior scholars each require 7 palm-leaf treatises for comparative philosophy research. The monastery library has already transcribed 12 treatises.",
				"target_question": "How many additional treatises must the scribes transcribe?",
				"step1": {
					"title": "STEP 1: Calculate Total Treatises Required",
					"prompt": "Calculate the total treatises needed for all 5 scholars (5 scholars × 7 treatises each):",
					"formula_display": "5 Scholars × 7 Treatises = [ ? ]",
					"options": ["30 treatises", "35 treatises", "40 treatises", "42 treatises"],
					"correct": 1,
					"value": 35,
					"explanation": "5 scholars × 7 treatises = 35 total treatises required."
				},
				"step2": {
					"title": "STEP 2: Deduct Transcribed Treatises",
					"prompt": "Subtract the 12 treatises already prepared in the library from the total required:",
					"formula_display": "35 Required − 12 Prepared = [ ? ]",
					"options": ["21 treatises", "23 treatises", "25 treatises", "27 treatises"],
					"correct": 1,
					"value": 23,
					"explanation": "35 total needed − 12 prepared = 23 additional treatises needed."
				},
				"summary": {
					"final_answer": "23 Additional Treatises",
					"breakdown": "Total Required: 35 Treatises  |  Prepared: 12 Treatises  |  Transcription Order: 23 Treatises\nSynthesis Formula: (5 × 7) − 12 = 23"
				}
			},
			{
				"id": "lamp_problem",
				"title": "Monastery Illumination Logistics",
				"context": "4 study chambers each require 9 brass oil lamps for night lectures. The university steward has gathered 7 lamps from the courtyard.",
				"target_question": "How many additional brass lamps must be procured from the artisans?",
				"step1": {
					"title": "STEP 1: Calculate Total Lamps Required",
					"prompt": "Calculate the total lamps needed across all 4 study chambers (4 chambers × 9 lamps each):",
					"formula_display": "4 Chambers × 9 Lamps = [ ? ]",
					"options": ["32 lamps", "36 lamps", "38 lamps", "40 lamps"],
					"correct": 1,
					"value": 36,
					"explanation": "4 chambers × 9 lamps = 36 total lamps required."
				},
				"step2": {
					"title": "STEP 2: Deduct Available Lamps",
					"prompt": "Subtract the 7 lamps already gathered from the total required:",
					"formula_display": "36 Required − 7 Available = [ ? ]",
					"options": ["27 lamps", "28 lamps", "29 lamps", "31 lamps"],
					"correct": 2,
					"value": 29,
					"explanation": "36 total needed − 7 available = 29 additional lamps needed."
				},
				"summary": {
					"final_answer": "29 Additional Brass Lamps",
					"breakdown": "Total Required: 36 Lamps  |  Available: 7 Lamps  |  Procurement Order: 29 Lamps\nSynthesis Formula: (4 × 9) − 7 = 29"
				}
			}
		]
	}
]

static func get_level_count() -> int:
	return LEVELS.size()

static func get_level(index: int) -> Dictionary:
	if index >= 0 and index < LEVELS.size():
		return LEVELS[index]
	return {}

static func get_level_by_id(level_id: String) -> Dictionary:
	var l_id := level_id.to_lower().strip_edges()
	for lvl in LEVELS:
		if lvl.get("id", "").to_lower() == l_id:
			return lvl
	return {}
