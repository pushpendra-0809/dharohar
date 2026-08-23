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
		if target_node:
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
	if target_node:
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
	if not player:
		player = get_node_or_null("../Player")
		if not player:
			var tree := get_tree()
			if tree and tree.current_scene:
				player = tree.current_scene.get_node_or_null("Player")

func _sync_with_game_state() -> void:
	if not GameState:
		return
		
	if GameState.teacher2_puzzle_completed:
		clear_objective()
	elif GameState.teacher2_puzzle_started:
		var target_info: Dictionary = GameState.get_current_puzzle_target()
		if not target_info.is_empty():
			var p_id: int = target_info.get("id", 1)
			var map_name: String = target_info.get("map", "nalanda")
			var pos: Vector2 = target_info.get("pos", Vector2.ZERO)
			
			var tree := get_tree()
			var cur_scene_name: String = tree.current_scene.name if tree and tree.current_scene else ""
			var is_target_on_cur_map: bool = false
			
			if map_name == "nalanda" and (cur_scene_name == "Nalanda" or cur_scene_name == "Nalanda_Map"):
				is_target_on_cur_map = true
			elif map_name == "university" and cur_scene_name == "Nalanda_University":
				is_target_on_cur_map = true
				
			if is_target_on_cur_map:
				set_objective("puzzle_piece_" + str(p_id), pos, "Find Puzzle Piece #" + str(p_id) + " (Nalanda Sealing)", null)
			else:
				if cur_scene_name == "Nalanda" or cur_scene_name == "Nalanda_Map":
					var entrance: Node2D = get_node_or_null("../UniversityEntrance")
					var ent_pos: Vector2 = entrance.global_position if entrance else Vector2(1098, 191)
					set_objective("go_to_university", ent_pos, "Travel to Nalanda University for Piece #" + str(p_id), entrance)
				else:
					var exit_node: Node2D = get_node_or_null("../UniversityExit")
					var exit_pos: Vector2 = exit_node.global_position if exit_node else Vector2(65, 370)
					set_objective("go_to_nalanda", exit_pos, "Travel to Nalanda Map for Piece #" + str(p_id), exit_node)
		else:
			# All 9 pieces collected -> lead to Teacher2 in Nalanda University at (477, 318)!
			var t2: Node2D = get_node_or_null("../Teacher2")
			var t2_pos: Vector2 = t2.global_position if t2 else Vector2(477, 318)
			set_objective("assemble_sealing", t2_pos, "Return to Teacher Acharya to Reconstruct Sealing", t2)
	elif GameState.has_visited_university:
		clear_objective()
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

func _on_quest_state_changed() -> void:
	_sync_with_game_state()
