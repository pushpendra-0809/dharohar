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

# Teacher2 & Puzzle State
var teacher2_puzzle_started: bool = false
var teacher2_puzzle_completed: bool = false
var teacher2_domain: String = ""
var teacher2_collected_pieces: Array = []
var teacher2_piece_positions: Dictionary = {}
var teacher2_piece_order: Array = []
var teacher2_current_target_index: int = 0
var knowledge_entries: Array = []

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

func start_teacher2_puzzle(domain: String) -> void:
	teacher2_domain = domain
	teacher2_puzzle_started = true
	
	if teacher2_piece_positions.is_empty():
		_generate_randomized_puzzle_pieces()
		
	quest_state_changed.emit()

func _generate_randomized_puzzle_pieces() -> void:
	teacher2_piece_positions.clear()
	teacher2_collected_pieces.clear()
	
	# Fixed deterministic/randomized valid walkable positions across Nalanda and Nalanda University
	var nalanda_valid_spots: Array = [
		Vector2(120, 220), Vector2(350, 480), Vector2(580, 220), Vector2(820, 380), Vector2(950, 180)
	]
	var univ_valid_spots: Array = [
		Vector2(180, 180), Vector2(420, 450), Vector2(650, 220), Vector2(880, 450), Vector2(980, 220)
	]
	
	nalanda_valid_spots.shuffle()
	univ_valid_spots.shuffle()
	
	# Order 1..9 shuffled for collection order
	var order: Array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	order.shuffle()
	teacher2_piece_order = order
	teacher2_current_target_index = 0
	
	# Distribute 5 pieces in Nalanda, 4 pieces in University
	for i in range(5):
		var p_id: int = order[i]
		teacher2_piece_positions[p_id] = {"map": "nalanda", "pos": nalanda_valid_spots[i]}
		
	for i in range(4):
		var p_id: int = order[5 + i]
		teacher2_piece_positions[p_id] = {"map": "university", "pos": univ_valid_spots[i]}

func collect_puzzle_piece(piece_id: int) -> void:
	if not teacher2_collected_pieces.has(piece_id):
		teacher2_collected_pieces.append(piece_id)
		
		# Advance target index if current target was collected
		if teacher2_current_target_index < teacher2_piece_order.size():
			var cur_target_id: int = teacher2_piece_order[teacher2_current_target_index]
			if cur_target_id == piece_id:
				while teacher2_current_target_index < teacher2_piece_order.size() and teacher2_collected_pieces.has(teacher2_piece_order[teacher2_current_target_index]):
					teacher2_current_target_index += 1
					
		quest_state_changed.emit()

func get_current_puzzle_target() -> Dictionary:
	if not teacher2_puzzle_started or teacher2_piece_order.is_empty():
		return {}
		
	for i in range(teacher2_piece_order.size()):
		var p_id: int = teacher2_piece_order[i]
		if not teacher2_collected_pieces.has(p_id):
			if teacher2_piece_positions.has(p_id):
				var info: Dictionary = teacher2_piece_positions[p_id].duplicate()
				info["id"] = p_id
				return info
				
	return {}

func complete_teacher2_puzzle() -> void:
	teacher2_puzzle_completed = true
	teacher2_puzzle_started = false
	add_knowledge_entry(
		"Nalanda Sealing",
		"History",
		"Terracotta sealings found at Nalanda provide evidence of the institution's organized monastic and scholarly life. Some feature the Dharmachakra and deer, while inscriptions identify the community associated with the great monastery."
	)
	quest_state_changed.emit()

func add_knowledge_entry(title: String, category: String, desc: String) -> void:
	knowledge_entries.append({
		"title": title,
		"category": category,
		"description": desc
	})
