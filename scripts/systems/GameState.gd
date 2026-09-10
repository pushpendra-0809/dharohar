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
var has_played_medicine_cutscene: bool = false
var has_played_philosophy_cutscene: bool = false
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

# Step 13: Stupa Building Challenges State
var stupa_challenges: Dictionary = {
	"mathematics": {"easy": false, "medium": false, "hard": false},
	"astronomy": {"easy": false, "medium": false, "hard": false},
	"medicine": {"easy": false, "medium": false, "hard": false},
	"philosophy": {"easy": false, "medium": false, "hard": false}
}
var stupa_scroll_earned: bool = false
var stupa_mastery_completed: bool = false
var stupa_story_choice: String = ""
var stupa_story_exp_claimed: bool = false

func complete_stupa_story_chapter(choice_id: String = "") -> void:
	stupa_story_choice = choice_id
	stupa_scroll_earned = true
	stupa_mastery_completed = true
	if not stupa_story_exp_claimed:
		stupa_story_exp_claimed = true
		add_exp(100)
	_check_and_update_three_scrolls()
	quest_state_changed.emit()


const STUPA_EXP_REWARDS: Dictionary = {
	"easy": 25,
	"medium": 35,
	"hard": 50
}
var stupa_exp_claimed: Dictionary = {}

func is_stupa_challenge_completed(domain: String, difficulty: String) -> bool:
	var dom = domain.to_lower()
	var diff = difficulty.to_lower()
	if stupa_challenges.has(dom) and stupa_challenges[dom].has(diff):
		return stupa_challenges[dom][diff]
	return false

func is_stupa_difficulty_unlocked(domain: String, difficulty: String) -> bool:
	var dom = domain.to_lower()
	var diff = difficulty.to_lower()
	if not stupa_challenges.has(dom):
		return false
	if diff == "easy":
		return true
	elif diff == "medium":
		return stupa_challenges[dom].get("easy", false)
	elif diff == "hard":
		return stupa_challenges[dom].get("medium", false)
	return false

func complete_stupa_challenge(domain: String, difficulty: String) -> void:
	var dom = domain.to_lower()
	var diff = difficulty.to_lower()
	if not stupa_challenges.has(dom) or not stupa_challenges[dom].has(diff):
		return
		
	stupa_challenges[dom][diff] = true
	
	# Award EXP once per challenge
	var reward_key: String = "stupa_" + dom + "_" + diff
	if not stupa_exp_claimed.get(reward_key, false):
		stupa_exp_claimed[reward_key] = true
		var exp_amt: int = STUPA_EXP_REWARDS.get(diff, 25)
		add_exp(exp_amt)
		
	# Check if all 4 domains have completed hard
	if are_all_stupa_hard_challenges_completed():
		if not stupa_scroll_earned:
			stupa_scroll_earned = true
			stupa_mastery_completed = true
			
	quest_state_changed.emit()

func are_all_stupa_hard_challenges_completed() -> bool:
	for dom in ["mathematics", "astronomy", "medicine", "philosophy"]:
		if not stupa_challenges.get(dom, {}).get("hard", false):
			return false
	return true

func get_stupa_completed_count() -> int:
	var count: int = 0
	for dom in stupa_challenges:
		for diff in stupa_challenges[dom]:
			if stupa_challenges[dom][diff]:
				count += 1
	return count

func get_stupa_hard_completed_count() -> int:
	var count: int = 0
	for dom in ["mathematics", "astronomy", "medicine", "philosophy"]:
		if stupa_challenges.get(dom, {}).get("hard", false):
			count += 1
	return count

# Step 14: Library Building Challenges State
var library_challenges: Dictionary = {
	"mathematics": {"easy": false, "medium": false, "hard": false},
	"astronomy": {"easy": false, "medium": false, "hard": false},
	"medicine": {"easy": false, "medium": false, "hard": false},
	"philosophy": {"easy": false, "medium": false, "hard": false}
}
var library_scroll_earned: bool = false
var library_mastery_completed: bool = false
var library_complete: bool = false
var library_story_choice: String = ""
var library_story_exp_claimed: bool = false

func complete_library_story_chapter(choice_id: String = "") -> void:
	library_story_choice = choice_id
	library_scroll_earned = true
	library_mastery_completed = true
	library_complete = true
	if not library_story_exp_claimed:
		library_story_exp_claimed = true
		add_exp(100)
	_check_and_update_three_scrolls()
	quest_state_changed.emit()


const LIBRARY_EXP_REWARDS: Dictionary = {
	"easy": 25,
	"medium": 35,
	"hard": 50
}
var library_exp_claimed: Dictionary = {}

func is_library_challenge_completed(domain: String, difficulty: String) -> bool:
	var dom = domain.to_lower()
	var diff = difficulty.to_lower()
	if library_challenges.has(dom) and library_challenges[dom].has(diff):
		return library_challenges[dom][diff]
	return false

func is_library_difficulty_unlocked(domain: String, difficulty: String) -> bool:
	var dom = domain.to_lower()
	var diff = difficulty.to_lower()
	if not library_challenges.has(dom):
		return false
	if diff == "easy":
		return true
	elif diff == "medium":
		return library_challenges[dom].get("easy", false)
	elif diff == "hard":
		return library_challenges[dom].get("medium", false)
	return false

func complete_library_challenge(domain: String, difficulty: String) -> void:
	var dom = domain.to_lower()
	var diff = difficulty.to_lower()
	if not library_challenges.has(dom) or not library_challenges[dom].has(diff):
		return
		
	library_challenges[dom][diff] = true
	
	# Award EXP once per challenge
	var reward_key: String = "library_" + dom + "_" + diff
	if not library_exp_claimed.get(reward_key, false):
		library_exp_claimed[reward_key] = true
		var exp_amt: int = LIBRARY_EXP_REWARDS.get(diff, 25)
		add_exp(exp_amt)
		
	# Check if all 4 domains have completed hard
	if are_all_library_hard_challenges_completed():
		if not library_scroll_earned:
			library_scroll_earned = true
			library_mastery_completed = true
			library_complete = true
			
	quest_state_changed.emit()

func are_all_library_hard_challenges_completed() -> bool:
	for dom in ["mathematics", "astronomy", "medicine", "philosophy"]:
		if not library_challenges.get(dom, {}).get("hard", false):
			return false
	return true

func get_library_completed_count() -> int:
	var count: int = 0
	for dom in library_challenges:
		for diff in library_challenges[dom]:
			if library_challenges[dom][diff]:
				count += 1
	return count

func get_library_hard_completed_count() -> int:
	var count: int = 0
	for dom in ["mathematics", "astronomy", "medicine", "philosophy"]:
		if library_challenges.get(dom, {}).get("hard", false):
			count += 1
	return count


# Step 15: Vihara Building Challenges State
var vihara_challenges: Dictionary = {
	"mathematics": {"easy": false, "medium": false, "hard": false},
	"astronomy": {"easy": false, "medium": false, "hard": false},
	"medicine": {"easy": false, "medium": false, "hard": false},
	"philosophy": {"easy": false, "medium": false, "hard": false}
}
var vihara_scroll_earned: bool = false
var vihara_mastery_completed: bool = false
var vihara_complete: bool = false
var vihara_story_choice: String = ""
var vihara_story_exp_claimed: bool = false

func complete_vihara_story_chapter(choice_id: String = "") -> void:
	vihara_story_choice = choice_id
	vihara_scroll_earned = true
	vihara_mastery_completed = true
	vihara_complete = true
	if not vihara_story_exp_claimed:
		vihara_story_exp_claimed = true
		add_exp(100)
	_check_and_update_three_scrolls()
	quest_state_changed.emit()

func _check_and_update_three_scrolls() -> void:
	if has_all_three_scrolls():
		three_scrolls_collected = true


const VIHARA_EXP_REWARDS: Dictionary = {
	"easy": 25,
	"medium": 35,
	"hard": 50
}
var vihara_exp_claimed: Dictionary = {}

func is_vihara_challenge_completed(domain: String, difficulty: String) -> bool:
	var dom = domain.to_lower()
	var diff = difficulty.to_lower()
	if vihara_challenges.has(dom) and vihara_challenges[dom].has(diff):
		return vihara_challenges[dom][diff]
	return false

func is_vihara_difficulty_unlocked(domain: String, difficulty: String) -> bool:
	var dom = domain.to_lower()
	var diff = difficulty.to_lower()
	if not vihara_challenges.has(dom):
		return false
	if diff == "easy":
		return true
	elif diff == "medium":
		return vihara_challenges[dom].get("easy", false)
	elif diff == "hard":
		return vihara_challenges[dom].get("medium", false)
	return false

func complete_vihara_challenge(domain: String, difficulty: String) -> void:
	var dom = domain.to_lower()
	var diff = difficulty.to_lower()
	if not vihara_challenges.has(dom) or not vihara_challenges[dom].has(diff):
		return
		
	vihara_challenges[dom][diff] = true
	
	# Award EXP once per challenge
	var reward_key: String = "vihara_" + dom + "_" + diff
	if not vihara_exp_claimed.get(reward_key, false):
		vihara_exp_claimed[reward_key] = true
		var exp_amt: int = VIHARA_EXP_REWARDS.get(diff, 25)
		add_exp(exp_amt)
		
	# Check if all 4 domains have completed hard
	if are_all_vihara_hard_challenges_completed():
		if not vihara_scroll_earned:
			vihara_scroll_earned = true
			vihara_mastery_completed = true
			vihara_complete = true
			
	quest_state_changed.emit()

func are_all_vihara_hard_challenges_completed() -> bool:
	for dom in ["mathematics", "astronomy", "medicine", "philosophy"]:
		if not vihara_challenges.get(dom, {}).get("hard", false):
			return false
	return true

func get_vihara_completed_count() -> int:
	var count: int = 0
	for dom in vihara_challenges:
		for diff in vihara_challenges[dom]:
			if vihara_challenges[dom][diff]:
				count += 1
	return count

func get_vihara_hard_completed_count() -> int:
	var count: int = 0
	for dom in ["mathematics", "astronomy", "medicine", "philosophy"]:
		if vihara_challenges.get(dom, {}).get("hard", false):
			count += 1
	return count

# Step 16: Overall Building Progression & Mastery Helpers
func get_total_scrolls_earned() -> int:
	var count: int = 0
	if stupa_scroll_earned or stupa_mastery_completed:
		count += 1
	if library_scroll_earned or library_mastery_completed or library_complete:
		count += 1
	if vihara_scroll_earned or vihara_mastery_completed or vihara_complete:
		count += 1
	return count

func has_all_three_scrolls() -> bool:
	var s_done = stupa_scroll_earned or stupa_mastery_completed
	var l_done = library_scroll_earned or library_mastery_completed or library_complete
	var v_done = vihara_scroll_earned or vihara_mastery_completed or vihara_complete
	return s_done and l_done and v_done

func is_building_complete(building: String) -> bool:
	match building.to_lower().strip_edges():
		"stupa":
			return are_all_stupa_hard_challenges_completed()
		"library":
			return are_all_library_hard_challenges_completed()
		"vihara":
			return are_all_vihara_hard_challenges_completed()
		_:
			return false

func get_building_hard_count(building: String) -> int:
	match building.to_lower().strip_edges():
		"stupa":
			return get_stupa_hard_completed_count()
		"library":
			return get_library_hard_completed_count()
		"vihara":
			return get_vihara_hard_completed_count()
		_:
			return 0

func is_building_scroll_earned(building: String) -> bool:
	match building.to_lower().strip_edges():
		"stupa":
			return stupa_scroll_earned or stupa_mastery_completed
		"library":
			return library_scroll_earned or library_mastery_completed or library_complete
		"vihara":
			return vihara_scroll_earned or vihara_mastery_completed or vihara_complete
		_:
			return false

# Step 17: Three Scrolls & Final Mastery Unlock State
var three_scrolls_collected: bool = false
var final_mastery_unlocked: bool = false

func unlock_final_mastery() -> void:
	if has_all_three_scrolls():
		three_scrolls_collected = true
		final_mastery_unlocked = true
		quest_state_changed.emit()

# Step 18: Final Mastery Progression State
var final_mastery_complete: bool = false
var final_mastery_exp_claimed: bool = false
var nalanda_complete: bool = false
var nalanda_completion_reward_claimed: bool = false

var final_mastery_stages: Dictionary = {
	"mathematics": false,
	"astronomy": false,
	"medicine": false,
	"philosophy": false,
	"integrated": false
}

func is_final_mastery_stage_complete(stage_id: String) -> bool:
	return final_mastery_stages.get(stage_id.to_lower(), false)

func complete_final_mastery_stage(stage_id: String) -> void:
	var s_id = stage_id.to_lower()
	if final_mastery_stages.has(s_id):
		final_mastery_stages[s_id] = true
		
	if are_all_final_mastery_stages_complete():
		complete_final_mastery()
	else:
		quest_state_changed.emit()

func get_final_mastery_completed_count() -> int:
	var count: int = 0
	for s_id in final_mastery_stages:
		if final_mastery_stages[s_id]:
			count += 1
	return count

func are_all_final_mastery_stages_complete() -> bool:
	for s_id in ["mathematics", "astronomy", "medicine", "philosophy", "integrated"]:
		if not final_mastery_stages.get(s_id, false):
			return false
	return true

func is_experience_unlocked(exp_id: String) -> bool:
	match exp_id.to_lower().strip_edges():
		"nalanda", "1", "experience_1":
			return true
		"hampi", "2", "experience_2":
			return nalanda_complete
		_:
			return false

func complete_nalanda_experience() -> void:
	nalanda_complete = true
	if not nalanda_completion_reward_claimed:
		nalanda_completion_reward_claimed = true
		add_exp(150) # Final Nalanda Grand Experience Completion Reward
	quest_state_changed.emit()

func complete_final_mastery() -> void:
	final_mastery_complete = true
	if not final_mastery_exp_claimed:
		final_mastery_exp_claimed = true
		add_exp(100) # Final Mastery Capstone Reward
	quest_state_changed.emit()


func serialize_building_progression() -> Dictionary:
	return {
		"stupa": {
			"challenges": stupa_challenges.duplicate(true),
			"scroll_earned": stupa_scroll_earned,
			"mastery_completed": stupa_mastery_completed,
			"story_choice": stupa_story_choice,
			"story_exp_claimed": stupa_story_exp_claimed,
			"exp_claimed": stupa_exp_claimed.duplicate(true)
		},
		"library": {
			"challenges": library_challenges.duplicate(true),
			"scroll_earned": library_scroll_earned,
			"mastery_completed": library_mastery_completed,
			"story_choice": library_story_choice,
			"story_exp_claimed": library_story_exp_claimed,
			"complete": library_complete,
			"exp_claimed": library_exp_claimed.duplicate(true)
		},
		"vihara": {
			"challenges": vihara_challenges.duplicate(true),
			"scroll_earned": vihara_scroll_earned,
			"mastery_completed": vihara_mastery_completed,
			"story_choice": vihara_story_choice,
			"story_exp_claimed": vihara_story_exp_claimed,
			"complete": vihara_complete,
			"exp_claimed": vihara_exp_claimed.duplicate(true)
		},
		"three_scrolls_collected": three_scrolls_collected,
		"final_mastery_unlocked": final_mastery_unlocked,
		"final_mastery_complete": final_mastery_complete,
		"final_mastery_exp_claimed": final_mastery_exp_claimed,
		"nalanda_complete": nalanda_complete,
		"nalanda_completion_reward_claimed": nalanda_completion_reward_claimed,
		"final_mastery_stages": final_mastery_stages.duplicate(true),
		"player_exp": player_exp,
		"player_level": player_level,
		"total_accumulated_exp": total_accumulated_exp
	}

func deserialize_building_progression(data: Dictionary) -> void:
	if data.has("stupa"):
		var s = data["stupa"]
		stupa_challenges = s.get("challenges", stupa_challenges)
		stupa_scroll_earned = s.get("scroll_earned", false)
		stupa_mastery_completed = s.get("mastery_completed", false)
		stupa_story_choice = s.get("story_choice", "")
		stupa_story_exp_claimed = s.get("story_exp_claimed", false)
		stupa_exp_claimed = s.get("exp_claimed", {})
		
	if data.has("library"):
		var l = data["library"]
		library_challenges = l.get("challenges", library_challenges)
		library_scroll_earned = l.get("scroll_earned", false)
		library_mastery_completed = l.get("mastery_completed", false)
		library_story_choice = l.get("story_choice", "")
		library_story_exp_claimed = l.get("story_exp_claimed", false)
		library_complete = l.get("complete", false)
		library_exp_claimed = l.get("exp_claimed", {})
		
	if data.has("vihara"):
		var v = data["vihara"]
		vihara_challenges = v.get("challenges", vihara_challenges)
		vihara_scroll_earned = v.get("scroll_earned", false)
		vihara_mastery_completed = v.get("mastery_completed", false)
		vihara_story_choice = v.get("story_choice", "")
		vihara_story_exp_claimed = v.get("story_exp_claimed", false)
		vihara_complete = v.get("complete", false)
		vihara_exp_claimed = v.get("exp_claimed", {})
		
	three_scrolls_collected = data.get("three_scrolls_collected", false)
	final_mastery_unlocked = data.get("final_mastery_unlocked", false)
	final_mastery_complete = data.get("final_mastery_complete", false)
	final_mastery_exp_claimed = data.get("final_mastery_exp_claimed", false)
	nalanda_complete = data.get("nalanda_complete", false)
	nalanda_completion_reward_claimed = data.get("nalanda_completion_reward_claimed", false)
	final_mastery_stages = data.get("final_mastery_stages", final_mastery_stages)
		
	if data.has("player_exp"):
		player_exp = data["player_exp"]
	if data.has("player_level"):
		player_level = data["player_level"]
	if data.has("total_accumulated_exp"):
		total_accumulated_exp = data["total_accumulated_exp"]
		
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
	if is_dev:
		return true
	var dom: String = selected_domain.to_lower().strip_edges()
	if "math" in dom or "gaṇita" in dom:
		return math_puzzle_completed
	elif "astro" in dom or "jyotiṣa" in dom:
		return astronomy_puzzle_completed
	elif "med" in dom or "cikitsā" in dom or "ayur" in dom:
		return medicine_puzzle_completed
	elif "phil" in dom or "darśana" in dom or "nyāya" in dom or "hetuvidyā" in dom:
		return philosophy_puzzle_completed
	return math_puzzle_completed or medicine_puzzle_completed or astronomy_puzzle_completed or philosophy_puzzle_completed

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
	has_played_medicine_cutscene = true
	has_played_philosophy_cutscene = true
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
	stupa_scroll_earned = false
	stupa_mastery_completed = false
	stupa_exp_claimed.clear()
	for dom in stupa_challenges:
		stupa_challenges[dom]["easy"] = false
		stupa_challenges[dom]["medium"] = false
		stupa_challenges[dom]["hard"] = false
	library_scroll_earned = false
	library_mastery_completed = false
	library_complete = false
	library_exp_claimed.clear()
	for dom in library_challenges:
		library_challenges[dom]["easy"] = false
		library_challenges[dom]["medium"] = false
		library_challenges[dom]["hard"] = false
	vihara_scroll_earned = false
	vihara_mastery_completed = false
	vihara_complete = false
	vihara_exp_claimed.clear()
	for dom in vihara_challenges:
		vihara_challenges[dom]["easy"] = false
		vihara_challenges[dom]["medium"] = false
		vihara_challenges[dom]["hard"] = false
	three_scrolls_collected = false
	final_mastery_unlocked = false
	final_mastery_complete = false
	final_mastery_exp_claimed = false
	nalanda_complete = false
	nalanda_completion_reward_claimed = false
	for s_id in final_mastery_stages:
		final_mastery_stages[s_id] = false

	session_exp = 0
	
	use_target_spawn = false
	target_spawn_position = Vector2.ZERO
	pending_arrival_message = []
	is_movement_locked = false
	has_played_nalanda_intro_cutscene = false
	has_played_math_cutscene = false
	has_played_astro_cutscene = false
	has_played_medicine_cutscene = false
	has_played_philosophy_cutscene = false
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
