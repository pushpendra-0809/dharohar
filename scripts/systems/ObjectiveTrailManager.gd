class_name ObjectiveTrailManager
extends Node2D

signal objective_changed(id: String, dest_pos: Vector2, text: String)
signal objective_cleared()

# Active Objective Data
var active_objective_id: String = ""
var destination_position: Vector2 = Vector2.ZERO
var objective_text: String = ""
var target_node: Node2D = null
var is_active: bool = false
var is_trail_visible: bool = true

# Player reference
var player: Node2D = null

# Pathfinding & Trail Rendering
var astar: AStarGrid2D = null
var current_path_points: PackedVector2Array = PackedVector2Array()
var sampled_trail_points: PackedVector2Array = PackedVector2Array()
var last_calc_player_pos: Vector2 = Vector2(-9999, -9999)
var time_passed: float = 0.0

# Distance threshold to hide trail when player arrives at destination (in pixels)
const ARRIVAL_DISTANCE: float = 55.0

# Grid parameters
const CELL_SIZE: Vector2i = Vector2i(16, 16)
const GRID_SIZE: Vector2i = Vector2i(90, 50)

# Visual colors (Dharohar terracotta, gold, dark brown)
const COLOR_GOLD: Color = Color(0.96, 0.78, 0.28, 0.95)
const COLOR_TERRACOTTA: Color = Color(0.82, 0.38, 0.22, 0.95)
const COLOR_DARK_BROWN: Color = Color(0.22, 0.14, 0.07, 0.95)

func _ready() -> void:
	z_index = 5
	_setup_astar_grid()
	
	if GameState:
		if not GameState.quest_state_changed.is_connected(_on_quest_state_changed):
			GameState.quest_state_changed.connect(_on_quest_state_changed)
			
	call_deferred("_sync_with_game_state")

func _process(delta: float) -> void:
	time_passed += delta
	if not is_active:
		visible = false
		return
		
	_check_player_node()
	
	if player:
		if target_node and is_instance_valid(target_node):
			destination_position = target_node.global_position
			
		var curr_pos: Vector2 = player.global_position
		var dist_to_dest: float = curr_pos.distance_to(destination_position)
		
		# Auto-hide trail when player arrives at destination
		if dist_to_dest <= ARRIVAL_DISTANCE:
			is_trail_visible = false
			visible = false
		else:
			is_trail_visible = true
			visible = true
			
		if is_trail_visible and curr_pos.distance_to(last_calc_player_pos) > 25.0:
			recalculate_path()
			
	queue_redraw()

func set_objective(id: String, dest_pos: Vector2, text: String, target: Node2D = null) -> void:
	active_objective_id = id
	destination_position = dest_pos
	objective_text = text
	target_node = target
	is_active = true
	is_trail_visible = true
	visible = true
	last_calc_player_pos = Vector2(-9999, -9999)
	
	recalculate_path()
	objective_changed.emit(id, dest_pos, text)

func update_objective(id: String, dest_pos: Vector2, text: String, target: Node2D = null) -> void:
	set_objective(id, dest_pos, text, target)

func clear_objective() -> void:
	active_objective_id = ""
	destination_position = Vector2.ZERO
	objective_text = ""
	target_node = null
	is_active = false
	is_trail_visible = false
	visible = false
	current_path_points.clear()
	sampled_trail_points.clear()
	
	queue_redraw()
	objective_cleared.emit()

func recalculate_path() -> void:
	if not is_active:
		return
		
	_check_player_node()
	if not player:
		return
		
	var start_pos: Vector2 = player.global_position
	if target_node and is_instance_valid(target_node):
		destination_position = target_node.global_position
		
	last_calc_player_pos = start_pos
	
	var start_cell: Vector2i = _pos_to_cell(start_pos)
	var end_cell: Vector2i = _pos_to_cell(destination_position)
	
	if astar:
		var grid_path: PackedVector2Array = astar.get_point_path(start_cell, end_cell)
		if grid_path.size() > 0:
			current_path_points = grid_path
		else:
			current_path_points = PackedVector2Array([start_pos, destination_position])
	else:
		current_path_points = PackedVector2Array([start_pos, destination_position])
		
	_sample_trail_points()
	queue_redraw()

func _sample_trail_points() -> void:
	sampled_trail_points.clear()
	if current_path_points.size() < 2:
		return
		
	var step_distance: float = 24.0
	var accumulated: float = 0.0
	
	for i in range(current_path_points.size() - 1):
		var p1: Vector2 = current_path_points[i]
		var p2: Vector2 = current_path_points[i + 1]
		var seg_len: float = p1.distance_to(p2)
		
		if seg_len == 0:
			continue
			
		var dir: Vector2 = (p2 - p1).normalized()
		var d: float = step_distance - accumulated
		
		while d <= seg_len:
			var sample_pt: Vector2 = p1 + dir * d
			sampled_trail_points.append(sample_pt)
			d += step_distance
			
		accumulated = seg_len - (d - step_distance)

func _draw() -> void:
	if not is_active or not is_trail_visible or sampled_trail_points.size() == 0:
		return
		
	# 1. Draw compact terracotta-gold diamonds along trail
	for i in range(sampled_trail_points.size()):
		var pt: Vector2 = sampled_trail_points[i]
		var pulse: float = sin(time_passed * 4.0 - i * 0.35) * 0.12 + 1.0
		var size: float = 3.2 * pulse
		
		# Dark brown shadow/border diamond
		var border_pts: PackedVector2Array = PackedVector2Array([
			pt + Vector2(0, -size - 1.0),
			pt + Vector2(size + 1.0, 0),
			pt + Vector2(0, size + 1.0),
			pt + Vector2(-size - 1.0, 0)
		])
		draw_colored_polygon(border_pts, COLOR_DARK_BROWN)
		
		# Terracotta-gold inner diamond
		var inner_color: Color = COLOR_GOLD if i % 2 == 0 else COLOR_TERRACOTTA
		var inner_pts: PackedVector2Array = PackedVector2Array([
			pt + Vector2(0, -size),
			pt + Vector2(size, 0),
			pt + Vector2(0, size),
			pt + Vector2(-size, 0)
		])
		draw_colored_polygon(inner_pts, inner_color)

	# 2. Draw destination marker
	var bob_offset: float = sin(time_passed * 3.5) * 3.5
	var dest_pt: Vector2 = destination_position + Vector2(0, -20.0 + bob_offset)
	
	# Outer terracotta diamond marker
	var m_size: float = 6.5
	var m_border: PackedVector2Array = PackedVector2Array([
		dest_pt + Vector2(0, -m_size - 1.5),
		dest_pt + Vector2(m_size + 1.5, 0),
		dest_pt + Vector2(0, m_size + 1.5),
		dest_pt + Vector2(-m_size - 1.5, 0)
	])
	draw_colored_polygon(m_border, COLOR_DARK_BROWN)
	
	var m_inner: PackedVector2Array = PackedVector2Array([
		dest_pt + Vector2(0, -m_size),
		dest_pt + Vector2(m_size, 0),
		dest_pt + Vector2(0, m_size),
		dest_pt + Vector2(-m_size, 0)
	])
	draw_colored_polygon(m_inner, COLOR_GOLD)

func _setup_astar_grid() -> void:
	astar = AStarGrid2D.new()
	astar.region = Rect2i(0, 0, GRID_SIZE.x, GRID_SIZE.y)
	astar.cell_size = Vector2(CELL_SIZE.x, CELL_SIZE.y)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.update()
	
	# Mark Pond collision area (around 196, 453) as solid obstacle
	var pond_cell_min: Vector2i = _pos_to_cell(Vector2(100, 375))
	var pond_cell_max: Vector2i = _pos_to_cell(Vector2(290, 530))
	for x in range(pond_cell_min.x, pond_cell_max.x + 1):
		for y in range(pond_cell_min.y, pond_cell_max.y + 1):
			if _is_cell_valid(Vector2i(x, y)):
				astar.set_point_solid(Vector2i(x, y), true)
				
	# Mark Cliff obstacle area (around X: 520..680, Y: 100..450) as solid obstacle
	var cliff_cell_min: Vector2i = _pos_to_cell(Vector2(520, 100))
	var cliff_cell_max: Vector2i = _pos_to_cell(Vector2(680, 450))
	for x in range(cliff_cell_min.x, cliff_cell_max.x + 1):
		for y in range(cliff_cell_min.y, cliff_cell_max.y + 1):
			if _is_cell_valid(Vector2i(x, y)):
				astar.set_point_solid(Vector2i(x, y), true)

func _pos_to_cell(pos: Vector2) -> Vector2i:
	var cx: int = int(clamp(pos.x / CELL_SIZE.x, 0, GRID_SIZE.x - 1))
	var cy: int = int(clamp(pos.y / CELL_SIZE.y, 0, GRID_SIZE.y - 1))
	return Vector2i(cx, cy)

func _is_cell_valid(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < GRID_SIZE.x and cell.y >= 0 and cell.y < GRID_SIZE.y

func _check_player_node() -> void:
	if not player or not is_instance_valid(player):
		player = get_node_or_null("../Player")
		if not player:
			var tree := get_tree()
			if tree and tree.current_scene:
				player = tree.current_scene.get_node_or_null("Player")

func _sync_with_game_state() -> void:
	if not GameState:
		return
		
	# 1. Check for Active Side Quests First
	if GameState.has_method("is_side_quest_active"):
		for q_id in ["farmer_provisions", "scribe_manuscript", "stupa_caretaker", "vihara_supplies", "missing_student", "scholar_question"]:
			if GameState.is_side_quest_active(q_id):
				_sync_side_quest(q_id)
				return
				
	# 2. Main Storyline Progression Flow
	if GameState.has_visited_university:
		if GameState.teacher2_convo_started or GameState.math_puzzle_completed or GameState.medicine_puzzle_completed or GameState.astronomy_puzzle_completed or GameState.philosophy_puzzle_completed:
			clear_objective()
		else:
			var t2: Node2D = get_node_or_null("../Teacher2")
			var t2_pos: Vector2 = t2.global_position if t2 else Vector2(292, 309)
			set_objective("meet_teacher2", t2_pos, "Meet the Teacher", t2)
	elif GameState.teacher_admitted:
		var univ_ent: Node2D = get_node_or_null("../UniversityEntrance")
		var target_pos: Vector2 = univ_ent.global_position if univ_ent else Vector2(1098, 191)
		set_objective("proceed_to_university", target_pos, "Proceed to Nalanda University", univ_ent)
	elif GameState.water_quest_completed or GameState.university_location_revealed:
		var teacher: Node2D = get_node_or_null("../Teacher")
		var teacher_pos: Vector2 = teacher.global_position if teacher else Vector2(998, 497)
		set_objective("meet_teacher", teacher_pos, "Meet the Teacher", teacher)
	elif GameState.has_water:
		var merch: Node2D = get_node_or_null("../Merchant")
		var merch_pos: Vector2 = merch.global_position if merch else Vector2(487, 109)
		set_objective("return_water", merch_pos, "Return the water to the Merchant", merch)
	elif GameState.merchant_water_quest_started:
		var pond: Node2D = get_node_or_null("../Pond")
		var pond_pos: Vector2 = pond.global_position if pond else Vector2(196, 453)
		set_objective("collect_water", pond_pos, "Collect water from the nearby pond", pond)
	else:
		var merch: Node2D = get_node_or_null("../Merchant")
		var merch_pos: Vector2 = merch.global_position if merch else Vector2(487, 109)
		set_objective("meet_merchant", merch_pos, "Meet the merchant", merch)

func _sync_side_quest(q_id: String) -> void:
	match q_id:
		"farmer_provisions":
			var q: Dictionary = GameState.side_quests["farmer_provisions"]
			var prog: int = q.get("progress", 0)
			var tgt: int = q.get("target", 3)
			if prog < tgt:
				var next_item: Node2D = _find_nearest_quest_item("farmer_provisions")
				if next_item:
					set_objective("collect_provision", next_item.global_position, "Collect provision (" + str(prog) + "/3)", next_item)
				else:
					var elder: Node2D = get_node_or_null("../NPC_FarmerElder")
					var elder_pos: Vector2 = elder.global_position if elder else Vector2(536, 475)
					set_objective("return_elder", elder_pos, "Return to the Village Elder", elder)
			else:
				var elder: Node2D = get_node_or_null("../NPC_FarmerElder")
				var elder_pos: Vector2 = elder.global_position if elder else Vector2(536, 475)
				set_objective("return_elder", elder_pos, "Return to the Village Elder", elder)

		"scribe_manuscript":
			var is_deliv: bool = GameState.is_manuscript_delivered()
			if not is_deliv:
				# Check if already inside innerLibrary.tscn
				var inner_desk: Node2D = get_node_or_null("../InteractionPoint_LibraryDesk")
				if inner_desk:
					set_objective("deliver_manuscript_inner", inner_desk.global_position, "Deliver manuscript to Library Desk", inner_desk)
				else:
					# In university scene -> lead to LibraryEntrance
					var lib_ent: Node2D = get_node_or_null("../LibraryEntrance")
					if lib_ent:
						set_objective("enter_library", lib_ent.global_position, "Enter Dharmaganja Library to deliver manuscript", lib_ent)
					else:
						# In village nalanda.tscn -> lead to University Entrance
						var univ_gate: Node2D = get_node_or_null("../UniversityEntrance")
						if not univ_gate:
							univ_gate = get_node_or_null("../InteractionPoint_Gate")
						var gate_pos: Vector2 = univ_gate.global_position if univ_gate else Vector2(1098, 191)
						set_objective("go_to_library", gate_pos, "Enter University towards Library", univ_gate)
			else:
				# Check if still inside innerLibrary.tscn -> lead to LibraryExit
				var lib_exit: Node2D = get_node_or_null("../LibraryExit")
				if lib_exit:
					set_objective("exit_library", lib_exit.global_position, "Exit Library to return to Scribe", lib_exit)
				else:
					# Outside in university or village
					var scribe: Node2D = get_node_or_null("../NPC_Scribe")
					if scribe:
						set_objective("return_scribe", scribe.global_position, "Return to the Scribe", scribe)
					else:
						var exit_node: Node2D = get_node_or_null("../UniversityExit")
						var exit_pos: Vector2 = exit_node.global_position if exit_node else Vector2(347, 566)
						set_objective("exit_to_scribe", exit_pos, "Return to Scribe via Gate Exit", exit_node)

		"stupa_caretaker":
			var q: Dictionary = GameState.side_quests["stupa_caretaker"]
			var prog: int = q.get("progress", 0)
			var tgt: int = q.get("target", 3)
			if prog < tgt:
				var next_item: Node2D = _find_nearest_quest_item("stupa_caretaker")
				if next_item:
					set_objective("collect_stupa_item", next_item.global_position, "Collect Stupa item (" + str(prog) + "/3)", next_item)
				else:
					var caretaker: Node2D = get_node_or_null("../NPC_StupaCaretaker")
					var c_pos: Vector2 = caretaker.global_position if caretaker else Vector2(843, 331)
					set_objective("return_stupa", c_pos, "Return to the Stupa Caretaker", caretaker)
			else:
				var caretaker: Node2D = get_node_or_null("../NPC_StupaCaretaker")
				var c_pos: Vector2 = caretaker.global_position if caretaker else Vector2(843, 331)
				set_objective("return_stupa", c_pos, "Return to the Stupa Caretaker", caretaker)

		"vihara_supplies":
			var q: Dictionary = GameState.side_quests["vihara_supplies"]
			var prog: int = q.get("progress", 0)
			var tgt: int = q.get("target", 3)
			if prog < tgt:
				var next_item: Node2D = _find_nearest_quest_item("vihara_supplies")
				if next_item:
					set_objective("collect_vihara_item", next_item.global_position, "Collect Vihara supply (" + str(prog) + "/3)", next_item)
				else:
					var worker: Node2D = get_node_or_null("../NPC_ViharaWorker")
					var w_pos: Vector2 = worker.global_position if worker else Vector2(242, 160)
					set_objective("return_vihara", w_pos, "Return to the Vihara Worker", worker)
			else:
				var worker: Node2D = get_node_or_null("../NPC_ViharaWorker")
				var w_pos: Vector2 = worker.global_position if worker else Vector2(242, 160)
				set_objective("return_vihara", w_pos, "Return to the Vihara Worker", worker)

		"missing_student":
			var is_found: bool = GameState.is_missing_student_found()
			if not is_found:
				var young_stud: Node2D = get_node_or_null("../NPC_YoungStudent")
				var y_pos: Vector2 = young_stud.global_position if young_stud else Vector2(734, 290)
				set_objective("find_student", y_pos, "Find the missing student", young_stud)
			else:
				var senior: Node2D = get_node_or_null("../NPC_SeniorStudent")
				var s_pos: Vector2 = senior.global_position if senior else Vector2(444, 368.8)
				set_objective("return_senior", s_pos, "Return to the Senior Student", senior)

		"scholar_question":
			var scholar: Node2D = get_node_or_null("../NPC_Scholar")
			if scholar:
				set_objective("talk_scholar", scholar.global_position, "Talk to the Scholar", scholar)
			else:
				# In university scene -> lead to LibraryEntrance
				var lib_ent: Node2D = get_node_or_null("../LibraryEntrance")
				if lib_ent:
					set_objective("enter_library_scholar", lib_ent.global_position, "Enter Dharmaganja Library to meet Scholar", lib_ent)
				else:
					var univ_gate: Node2D = get_node_or_null("../UniversityEntrance")
					var gate_pos: Vector2 = univ_gate.global_position if univ_gate else Vector2(1098, 191)
					set_objective("go_to_library_scholar", gate_pos, "Enter University towards Library", univ_gate)

func _find_nearest_quest_item(q_id: String) -> Node2D:
	_check_player_node()
	var player_pos: Vector2 = player.global_position if player else Vector2.ZERO
	var best_node: Node2D = null
	var best_dist: float = 999999.0
	
	for item in get_tree().get_nodes_in_group("pickup_items"):
		if item is Node2D and item.visible and "quest_id" in item and item.quest_id == q_id:
			if "item_id" in item and not GameState.is_quest_item_collected(item.item_id):
				var d: float = player_pos.distance_to(item.global_position)
				if d < best_dist:
					best_dist = d
					best_node = item
					
	return best_node

func _on_quest_state_changed() -> void:
	_sync_with_game_state()
