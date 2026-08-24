class_name AstronomyPuzzleUI
extends CanvasLayer

signal puzzle_completed()
signal puzzle_closed()

@onready var color_rect: ColorRect = $ColorRect
@onready var panel_container: Control = $PanelContainer
@onready var title_label: Label = $PanelContainer/TitleLabel
@onready var puzzle_header_label: Label = $PanelContainer/PuzzleHeaderLabel
@onready var instructions_label: Label = $PanelContainer/InstructionsLabel
@onready var sky_panel: Control = $PanelContainer/SkyPanel
@onready var clues_container: VBoxContainer = $PanelContainer/CluesBox/CluesContainer
@onready var feedback_label: Label = $PanelContainer/FeedbackLabel
@onready var explanation_label: Label = $PanelContainer/ExplanationLabel
@onready var submit_button: Button = $PanelContainer/SubmitButton
@onready var reset_button: Button = $PanelContainer/ResetButton
@onready var hint_button: Button = $PanelContainer/HintButton
@onready var close_button: Button = $PanelContainer/CloseButton
@onready var info_button: Button = $PanelContainer/InfoButton
@onready var puzzle_info_panel = $PuzzleInfoPanel

var puzzles: Array = []
var current_puzzle_index: int = 0
var star_positions: Array = []
var selected_sequence: Array = []
var star_buttons: Array = []
var is_solved: bool = false
var is_processing_answer: bool = false

func _ready() -> void:
	visible = false
	if color_rect:
		color_rect.visible = false
	if panel_container:
		panel_container.visible = false
		
	puzzles = load("res://scripts/puzzles/AstronomyPuzzles.gd").get_puzzles()
	
	if sky_panel and not sky_panel.draw.is_connected(_on_sky_panel_draw):
		sky_panel.draw.connect(_on_sky_panel_draw)
		
	if submit_button and not submit_button.pressed.is_connected(_on_submit_pressed):
		submit_button.pressed.connect(_on_submit_pressed)
	if reset_button and not reset_button.pressed.is_connected(_on_reset_pressed):
		reset_button.pressed.connect(_on_reset_pressed)
	if hint_button and not hint_button.pressed.is_connected(_on_hint_pressed):
		hint_button.pressed.connect(_on_hint_pressed)
	if close_button and not close_button.pressed.is_connected(_on_close_pressed):
		close_button.pressed.connect(_on_close_pressed)
	if info_button and not info_button.pressed.is_connected(_on_info_pressed):
		info_button.pressed.connect(_on_info_pressed)

func _on_info_pressed() -> void:
	if puzzle_info_panel and puzzle_info_panel.has_method("show_info"):
		puzzle_info_panel.show_info("astronomy")

func open_puzzle() -> void:
	visible = true
	if color_rect:
		color_rect.visible = true
	if panel_container:
		panel_container.visible = true
		
	is_solved = false
	is_processing_answer = false
	current_puzzle_index = 0
	selected_sequence.clear()
	
	if GameState:
		GameState.lock_player_movement()
		
	_load_puzzle(current_puzzle_index)

func close_puzzle() -> void:
	visible = false
	if color_rect:
		color_rect.visible = false
	if panel_container:
		panel_container.visible = false
		
	if GameState:
		GameState.unlock_player_movement()
	puzzle_closed.emit()

func _load_puzzle(idx: int) -> void:
	if idx < 0 or idx >= puzzles.size():
		return
		
	is_processing_answer = false
	if submit_button:
		submit_button.disabled = false
		
	selected_sequence.clear()
	var p_data: Dictionary = puzzles[idx]
	
	if puzzle_header_label:
		puzzle_header_label.text = "PUZZLE " + str(idx + 1) + " / " + str(puzzles.size()) + " — " + p_data.get("title", "")
		
	if instructions_label:
		instructions_label.text = p_data.get("instructions", "")
		
	if clues_container:
		for child in clues_container.get_children():
			child.queue_free()
			
		var clues: Array = p_data.get("clues", [])
		for clue_text in clues:
			var lbl: Label = Label.new()
			lbl.text = str(clue_text)
			lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			lbl.custom_minimum_size = Vector2(230, 0)
			lbl.add_theme_color_override("font_color", Color(0.92, 0.88, 0.72, 1.0))
			lbl.add_theme_font_size_override("font_size", 14)
			clues_container.add_child(lbl)
			
	if feedback_label:
		feedback_label.text = ""
	if explanation_label:
		explanation_label.text = ""
		
	star_positions = p_data.get("star_positions", [])
	_setup_star_buttons()
	if sky_panel:
		sky_panel.queue_redraw()

func _setup_star_buttons() -> void:
	if not sky_panel:
		return
		
	for child in sky_panel.get_children():
		child.queue_free()
	star_buttons.clear()
	
	for i in range(star_positions.size()):
		var pos: Vector2 = star_positions[i]
		var btn: TextureButton = TextureButton.new()
		btn.custom_minimum_size = Vector2(32, 32)
		btn.position = pos - Vector2(16, 16)
		btn.ignore_texture_size = true
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		btn.texture_filter = Control.TEXTURE_FILTER_NEAREST
		
		var star_tex_path: String = "res://Puzzle Assets/Astronomy/Stars/star_bright.png"
		if i >= 4:
			star_tex_path = "res://Puzzle Assets/Astronomy/Stars/star_small.png"
		if ResourceLoader.exists(star_tex_path):
			btn.texture_normal = load(star_tex_path)
			
		var sel_tex_path: String = "res://Puzzle Assets/Astronomy/Stars/star_selected.png"
		if ResourceLoader.exists(sel_tex_path):
			btn.texture_pressed = load(sel_tex_path)
			btn.texture_focused = load(sel_tex_path)
			
		var idx_copy: int = i
		btn.pressed.connect(func(): _on_star_pressed(idx_copy))
		sky_panel.add_child(btn)
		star_buttons.append(btn)

func _on_star_pressed(idx: int) -> void:
	if is_processing_answer:
		return
		
	# Ignore double click on exact same star consecutively
	if selected_sequence.size() > 0 and selected_sequence[selected_sequence.size() - 1] == idx:
		return
		
	selected_sequence.append(idx)
	if sky_panel:
		sky_panel.queue_redraw()
		
	if idx < star_buttons.size():
		star_buttons[idx].modulate = Color(1.0, 0.85, 0.3, 1.0)

func _on_sky_panel_draw() -> void:
	if not sky_panel or selected_sequence.size() < 2:
		return
		
	for i in range(selected_sequence.size() - 1):
		var idx_a: int = selected_sequence[i]
		var idx_b: int = selected_sequence[i + 1]
		
		if idx_a < star_positions.size() and idx_b < star_positions.size():
			var pos_a: Vector2 = star_positions[idx_a]
			var pos_b: Vector2 = star_positions[idx_b]
			sky_panel.draw_line(pos_a, pos_b, Color(0.96, 0.82, 0.28, 0.9), 3.0)
			sky_panel.draw_line(pos_a, pos_b, Color(1.0, 0.95, 0.70, 0.5), 6.0)

func _on_reset_pressed() -> void:
	if is_processing_answer:
		return
	selected_sequence.clear()
	for btn in star_buttons:
		btn.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if sky_panel:
		sky_panel.queue_redraw()
	if feedback_label:
		feedback_label.text = ""
	if explanation_label:
		explanation_label.text = ""

func _on_hint_pressed() -> void:
	if current_puzzle_index < puzzles.size():
		var p_data: Dictionary = puzzles[current_puzzle_index]
		if feedback_label:
			feedback_label.text = "HINT: " + p_data.get("hint", "")
			feedback_label.add_theme_color_override("font_color", Color(0.96, 0.78, 0.28, 1.0))

func _on_submit_pressed() -> void:
	if is_processing_answer or current_puzzle_index >= puzzles.size():
		return
		
	var p_data: Dictionary = puzzles[current_puzzle_index]
	var valid_seqs: Array = p_data.get("valid_sequences", [])
	
	var is_correct: bool = false
	for seq in valid_seqs:
		if selected_sequence == seq:
			is_correct = true
			break
			
	# Fallback check: if selected sequence contains the required star set in order
	if not is_correct and valid_seqs.size() > 0:
		var target_set: Array = valid_seqs[0]
		# Unique list of stars in player selection
		var unique_sel: Array = []
		for s in selected_sequence:
			if not (s in unique_sel):
				unique_sel.append(s)
		var unique_target: Array = []
		for s in target_set:
			if not (s in unique_target):
				unique_target.append(s)
				
		var rev_target: Array = unique_target.duplicate()
		rev_target.reverse()
		if unique_sel == unique_target or unique_sel == rev_target:
			is_correct = true
			
	if is_correct:
		is_processing_answer = true
		if submit_button:
			submit_button.disabled = true
			
		if feedback_label:
			feedback_label.text = "Correct! You observed the pattern carefully."
			feedback_label.add_theme_color_override("font_color", Color(0.28, 0.85, 0.35, 1.0))
		if explanation_label:
			explanation_label.text = p_data.get("explanation", "")
			
		get_tree().create_timer(1.8).timeout.connect(func():
			current_puzzle_index += 1
			if current_puzzle_index < puzzles.size():
				_load_puzzle(current_puzzle_index)
			else:
				_on_all_puzzles_completed()
		)
	else:
		if feedback_label:
			feedback_label.text = "Not quite. Observe the clues and star positions again."
			feedback_label.add_theme_color_override("font_color", Color(0.95, 0.32, 0.28, 1.0))

func _on_all_puzzles_completed() -> void:
	is_solved = true
	if GameState:
		if GameState.has_method("complete_astronomy_puzzle"):
			GameState.complete_astronomy_puzzle()
			
	if feedback_label:
		feedback_label.text = "Excellent! You have learned to observe the sky with the care of a scholar."
		feedback_label.add_theme_color_override("font_color", Color(0.96, 0.78, 0.28, 1.0))
		
	puzzle_completed.emit()
	get_tree().create_timer(1.8).timeout.connect(func(): close_puzzle())

func _on_close_pressed() -> void:
	close_puzzle()
