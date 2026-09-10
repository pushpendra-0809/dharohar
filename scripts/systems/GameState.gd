extends Node

signal player_movement_locked(locked: bool)
signal teacher_state_changed()
signal merchant_state_changed()
signal quest_state_changed()

# Teacher state
var selected_domain: String = ""
var teacher_quiz_score: int = 0
var teacher_quiz_completed: bool = false
var teacher_admitted: bool = false
var teacher_retry_available: bool = true

# Mathematics Puzzle State
var math_puzzle_completed: bool = false

# Medicine Puzzle State
var medicine_puzzle_completed: bool = false

# Astronomy Puzzle State
var astronomy_puzzle_completed: bool = false

# Philosophy Puzzle State
var philosophy_puzzle_completed: bool = false

# Merchant state
var merchant_quiz_score: int = 0
var merchant_quiz_completed: bool = false
var merchant_passed: bool = false
var merchant_retry_available: bool = true
var nalanda_location_revealed: bool = false

# Water Quest state
var merchant_water_quest_started: bool = false
var water_collected: bool = false
var water_quest_completed: bool = false
var university_location_revealed: bool = false
var has_water: bool = false

# University Visited State
var has_visited_university: bool = false
var has_returned_to_nalanda: bool = false
var teacher2_convo_started: bool = false
var has_played_nalanda_intro_cutscene: bool = false
var has_played_math_cutscene: bool = false
var has_played_astro_cutscene: bool = false
var has_shown_nalanda_controls_tutorial: bool = false

# Step 12: Teacher 3 (Mastery Mentor) State
var has_met_teacher3: bool = false
var mastery_challenges_unlocked: bool = false

func mark_teacher2_convo_started() -> void:
	teacher2_convo_started = true
	quest_state_changed.emit()

func mark_teacher3_intro_completed() -> void:
	has_met_teacher3 = true
	mastery_challenges_unlocked = true
	quest_state_changed.emit()

# Scene Transition & Target Spawn Data
var target_spawn_position: Vector2 = Vector2.ZERO
var use_target_spawn: bool = false
var pending_arrival_message: Array = []
var is_movement_locked: bool = false

func set_target_spawn(pos: Vector2, message_seq: Array = []) -> void:
	target_spawn_position = pos
	use_target_spawn = true
	pending_arrival_message = message_seq

func lock_player_movement() -> void:
	is_movement_locked = true
	player_movement_locked.emit(true)

func unlock_player_movement() -> void:
	is_movement_locked = false
	player_movement_locked.emit(false)

func reset_teacher_quiz_state() -> void:
	teacher_quiz_score = 0

func record_teacher_admission(domain: String, score: int) -> void:
	selected_domain = domain
	teacher_quiz_score = score
	teacher_quiz_completed = true
	teacher_admitted = true
	teacher_state_changed.emit()
	quest_state_changed.emit()

func complete_math_puzzle() -> void:
	math_puzzle_completed = true
	quest_state_changed.emit()

func complete_medicine_puzzle() -> void:
	medicine_puzzle_completed = true
	quest_state_changed.emit()

func complete_astronomy_puzzle() -> void:
	astronomy_puzzle_completed = true
	quest_state_changed.emit()

func complete_philosophy_puzzle() -> void:
	philosophy_puzzle_completed = true
	quest_state_changed.emit()

func record_merchant_result(score: int, passed: bool) -> void:
	merchant_quiz_score = score
	merchant_quiz_completed = true
	merchant_passed = passed
	if passed:
		university_location_revealed = true
		nalanda_location_revealed = true
	merchant_state_changed.emit()
	quest_state_changed.emit()

func start_water_quest() -> void:
	merchant_water_quest_started = true
	water_collected = false
	has_water = false
	water_quest_completed = false
	merchant_state_changed.emit()
	quest_state_changed.emit()

func collect_water() -> void:
	water_collected = true
	has_water = true
	quest_state_changed.emit()

func complete_water_quest() -> void:
	water_quest_completed = true
	merchant_water_quest_started = false
	has_water = false
	water_collected = true
	university_location_revealed = true
	nalanda_location_revealed = true
	merchant_passed = true
	merchant_state_changed.emit()
	quest_state_changed.emit()

func mark_university_visited() -> void:
	has_visited_university = true
	quest_state_changed.emit()

# ==============================================================================
# STEP 10: NALANDA SIDE QUESTS STATE SYSTEM
# ==============================================================================
enum QuestStatus {
	NOT_STARTED = 0,
	ACTIVE = 1,
	COMPLETE = 2
}

signal side_quest_state_changed(quest_id: String, new_state: int)
signal side_quest_completed(quest_id: String)

var side_quests: Dictionary = {
	"farmer_provisions": {
		"id": "farmer_provisions",
		"title": "University Provisions",
		"state": QuestStatus.NOT_STARTED,
		"progress": 0,
		"target": 3,
		"collected_items": []
	},
	"scribe_manuscript": {
		"id": "scribe_manuscript",
		"title": "The Right Manuscript",
		"state": QuestStatus.NOT_STARTED,
		"delivered": false
	},
	"stupa_caretaker": {
		"id": "stupa_caretaker",
		"title": "Care for the Stupa",
		"state": QuestStatus.NOT_STARTED,
		"progress": 0,
		"target": 3,
		"collected_items": []
	},
	"vihara_supplies": {
		"id": "vihara_supplies",
		"title": "Vihara Supplies",
		"state": QuestStatus.NOT_STARTED,
		"progress": 0,
		"target": 3,
		"collected_items": []
	},
	"missing_student": {
		"id": "missing_student",
		"title": "The Missing Student",
		"state": QuestStatus.NOT_STARTED,
		"found": false
	},
	"scholar_question": {
		"id": "scholar_question",
		"title": "A Scholar's Question",
		"state": QuestStatus.NOT_STARTED,
		"solved": false
	}
}

func get_side_quest_state(quest_id: String) -> int:
	if side_quests.has(quest_id):
		return side_quests[quest_id].get("state", QuestStatus.NOT_STARTED)
	return QuestStatus.NOT_STARTED

func is_side_quest_active(quest_id: String) -> bool:
	return get_side_quest_state(quest_id) == QuestStatus.ACTIVE

func is_side_quest_complete(quest_id: String) -> bool:
	return get_side_quest_state(quest_id) == QuestStatus.COMPLETE

func start_side_quest(quest_id: String) -> void:
	if side_quests.has(quest_id) and side_quests[quest_id]["state"] == QuestStatus.NOT_STARTED:
		side_quests[quest_id]["state"] = QuestStatus.ACTIVE
		side_quest_state_changed.emit(quest_id, QuestStatus.ACTIVE)
		quest_state_changed.emit()

func collect_quest_item(quest_id: String, item_id: String) -> void:
	if side_quests.has(quest_id) and side_quests[quest_id]["state"] == QuestStatus.ACTIVE:
		var q: Dictionary = side_quests[quest_id]
		var items: Array = q.get("collected_items", [])
		if not items.has(item_id):
			items.append(item_id)
			q["collected_items"] = items
			q["progress"] = items.size()
			side_quest_state_changed.emit(quest_id, QuestStatus.ACTIVE)
			quest_state_changed.emit()

func is_quest_item_collected(item_id: String) -> bool:
	for q_id in side_quests:
		var q: Dictionary = side_quests[q_id]
		if q.has("collected_items"):
			var items: Array = q.get("collected_items", [])
			if items.has(item_id):
				return true
	return false

func deliver_manuscript() -> void:
	if side_quests.has("scribe_manuscript") and side_quests["scribe_manuscript"]["state"] == QuestStatus.ACTIVE:
		side_quests["scribe_manuscript"]["delivered"] = true
		side_quest_state_changed.emit("scribe_manuscript", QuestStatus.ACTIVE)
		quest_state_changed.emit()

func is_manuscript_delivered() -> bool:
	if side_quests.has("scribe_manuscript"):
		return side_quests["scribe_manuscript"].get("delivered", false)
	return false

func find_missing_student() -> void:
	if side_quests.has("missing_student") and side_quests["missing_student"]["state"] == QuestStatus.ACTIVE:
		side_quests["missing_student"]["found"] = true
		side_quest_state_changed.emit("missing_student", QuestStatus.ACTIVE)
		quest_state_changed.emit()

func is_missing_student_found() -> bool:
	if side_quests.has("missing_student"):
		return side_quests["missing_student"].get("found", false)
	return false

func solve_scholar_question() -> void:
	if side_quests.has("scholar_question"):
		side_quests["scholar_question"]["solved"] = true
		side_quest_state_changed.emit("scholar_question", QuestStatus.ACTIVE)
		quest_state_changed.emit()

func is_scholar_question_solved() -> bool:
	if side_quests.has("scholar_question"):
		return side_quests["scholar_question"].get("solved", false)
	return false

func are_teacher2_tasks_completed() -> bool:
	var dev = get_node_or_null("/root/DevModeManager")
	var is_dev: bool = dev != null and dev.dev_mode_enabled
	return is_dev or math_puzzle_completed or medicine_puzzle_completed or astronomy_puzzle_completed or philosophy_puzzle_completed or teacher2_convo_started

const SIDE_QUEST_EXP_REWARDS: Dictionary = {
	"farmer_provisions": 50,
	"scribe_manuscript": 50,
	"stupa_caretaker": 50,
	"vihara_supplies": 50,
	"missing_student": 50,
	"scholar_question": 75
}

var quest_rewards_claimed: Dictionary = {}

# Player Progression & Level System (Step 11)
var player_level: int = 1
var player_exp: int = 0
var total_accumulated_exp: int = 0

signal exp_awarded(amount: int, current_exp: int, exp_required: int, did_level_up: bool)
signal level_up(new_level: int)

func get_exp_required_for_next_level(lvl: int) -> int:
	match lvl:
		1: return 100
		2: return 150
		3: return 200
		4: return 250
		_: return 300 + (lvl - 5) * 50

func add_exp(amount: int) -> void:
	if amount <= 0:
		return
		
	total_accumulated_exp += amount
	player_exp += amount
	exp_changed.emit(player_exp, amount)
	
	var req: int = get_exp_required_for_next_level(player_level)
	var did_level_up: bool = false
	
	while player_exp >= req:
		player_exp -= req
		player_level += 1
		did_level_up = true
		level_up.emit(player_level)
		req = get_exp_required_for_next_level(player_level)
		
	exp_awarded.emit(amount, player_exp, req, did_level_up)

func complete_side_quest(quest_id: String) -> void:
	if side_quests.has(quest_id):
		var was_complete: bool = side_quests[quest_id].get("state", QuestStatus.NOT_STARTED) == QuestStatus.COMPLETE
		side_quests[quest_id]["state"] = QuestStatus.COMPLETE
		
		# Award EXP only once upon completion
		if not was_complete and not quest_rewards_claimed.get(quest_id, false):
			quest_rewards_claimed[quest_id] = true
			var exp_reward: int = SIDE_QUEST_EXP_REWARDS.get(quest_id, 50)
			add_exp(exp_reward)
			
		side_quest_completed.emit(quest_id)
		side_quest_state_changed.emit(quest_id, QuestStatus.COMPLETE)
		quest_state_changed.emit()

func get_active_side_quest_objective() -> String:
	for q_id in ["farmer_provisions", "scribe_manuscript", "stupa_caretaker", "vihara_supplies", "missing_student", "scholar_question"]:
		var q: Dictionary = side_quests[q_id]
		if q.get("state", QuestStatus.NOT_STARTED) == QuestStatus.ACTIVE:
			match q_id:
				"farmer_provisions":
					var prog: int = q.get("progress", 0)
					var tgt: int = q.get("target", 3)
					if prog < tgt:
						return "Collect provisions for Elder (" + str(prog) + "/" + str(tgt) + ")"
					else:
						return "Return the provisions to the Village Elder"
				"scribe_manuscript":
					if not q.get("delivered", false):
						return "Deliver manuscript to the Library Desk"
					else:
						return "Return to the Scribe"
				"stupa_caretaker":
					var prog: int = q.get("progress", 0)
					var tgt: int = q.get("target", 3)
					if prog < tgt:
						return "Collect Stupa items (" + str(prog) + "/" + str(tgt) + ")"
					else:
						return "Return items to the Stupa Caretaker"
				"vihara_supplies":
					var prog: int = q.get("progress", 0)
					var tgt: int = q.get("target", 3)
					if prog < tgt:
						return "Collect Vihara supplies (" + str(prog) + "/" + str(tgt) + ")"
					else:
						return "Return supplies to the Vihara Worker"
				"missing_student":
					if not q.get("found", false):
						return "Find the missing student"
					else:
						return "Return to the Senior Student"
				"scholar_question":
					if not q.get("solved", false):
						return "Solve the Scholar's classification challenge"
					else:
						return "Talk to the Scholar"
	return ""

var session_exp: int = 0
signal exp_changed(new_exp: int, delta: int)

func unlock_all_progression() -> void:
	merchant_passed = true
	merchant_quiz_completed = true
	merchant_quiz_score = 5
	water_quest_completed = true
	water_collected = true
	university_location_revealed = true
	nalanda_location_revealed = true
	
	if selected_domain == "":
		selected_domain = "mathematics"
	teacher_quiz_completed = true
	teacher_admitted = true
	teacher_quiz_score = 5
	
	math_puzzle_completed = true
	astronomy_puzzle_completed = true
	medicine_puzzle_completed = true
	philosophy_puzzle_completed = true
	
	has_visited_university = true
	has_returned_to_nalanda = true
	teacher2_convo_started = true
	has_played_nalanda_intro_cutscene = true
	has_played_math_cutscene = true
	has_played_astro_cutscene = true
	has_shown_nalanda_controls_tutorial = true
	
	for q_id in side_quests:
		side_quests[q_id]["state"] = QuestStatus.COMPLETE
		quest_rewards_claimed[q_id] = true
		if side_quests[q_id].has("progress"):
			side_quests[q_id]["progress"] = side_quests[q_id].get("target", 3)
		if side_quests[q_id].has("delivered"):
			side_quests[q_id]["delivered"] = true
		if side_quests[q_id].has("found"):
			side_quests[q_id]["found"] = true
		if side_quests[q_id].has("solved"):
			side_quests[q_id]["solved"] = true
	player_level = 3
	player_exp = 75
	total_accumulated_exp = 325
	
	merchant_state_changed.emit()
	teacher_state_changed.emit()
	quest_state_changed.emit()

func reset_test_progression() -> void:
	selected_domain = ""
	teacher_quiz_score = 0
	teacher_quiz_completed = false
	teacher_admitted = false
	teacher_retry_available = true
	
	math_puzzle_completed = false
	medicine_puzzle_completed = false
	astronomy_puzzle_completed = false
	philosophy_puzzle_completed = false
	
	merchant_quiz_score = 0
	merchant_quiz_completed = false
	merchant_passed = false
	merchant_retry_available = true
	nalanda_location_revealed = false
	
	merchant_water_quest_started = false
	water_collected = false
	water_quest_completed = false
	university_location_revealed = false
	has_water = false
	
	has_visited_university = false
	has_returned_to_nalanda = false
	teacher2_convo_started = false
	has_met_teacher3 = false
	mastery_challenges_unlocked = false
	session_exp = 0
	
	use_target_spawn = false
	target_spawn_position = Vector2.ZERO
	pending_arrival_message = []
	is_movement_locked = false
	has_played_nalanda_intro_cutscene = false
	has_played_math_cutscene = false
	has_played_astro_cutscene = false
	has_shown_nalanda_controls_tutorial = false
	
	player_level = 1
	player_exp = 0
	total_accumulated_exp = 0
	quest_rewards_claimed.clear()
	for q_id in side_quests:
		side_quests[q_id]["state"] = QuestStatus.NOT_STARTED
		if side_quests[q_id].has("progress"):
			side_quests[q_id]["progress"] = 0
		if side_quests[q_id].has("collected_items"):
			side_quests[q_id]["collected_items"] = []
		if side_quests[q_id].has("delivered"):
			side_quests[q_id]["delivered"] = false
		if side_quests[q_id].has("found"):
			side_quests[q_id]["found"] = false
		if side_quests[q_id].has("solved"):
			side_quests[q_id]["solved"] = false
	
	merchant_state_changed.emit()
	teacher_state_changed.emit()
	quest_state_changed.emit()



