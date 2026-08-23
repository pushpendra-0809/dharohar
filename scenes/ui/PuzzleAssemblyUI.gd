class_name PuzzleAssemblyUI
extends CanvasLayer

signal assembly_completed()
signal assembly_closed()

@onready var panel_container: Control = $PanelContainer
@onready var title_texture: TextureRect = $PanelContainer/TitleTexture
@onready var domain_icon_texture: TextureRect = $PanelContainer/DomainIconTexture
@onready var clue_label: Label = $PanelContainer/ClueLabel
@onready var grid_container: GridContainer = $PanelContainer/GridContainer
@onready var complete_texture: TextureRect = $PanelContainer/CompleteTexture
@onready var close_button: Button = $PanelContainer/CloseButton

var current_grid: Array = [6, 2, 9, 4, 1, 7, 3, 5, 8] # Scrambled default
var selected_slot_index: int = -1
var is_completed: bool = false

func _ready() -> void:
	visible = false
	if close_button and not close_button.pressed.is_connected(_on_close_pressed):
		close_button.pressed.connect(_on_close_pressed)
		
	if complete_texture:
		complete_texture.visible = false

func open_puzzle() -> void:
	visible = true
	is_completed = false
	selected_slot_index = -1
	
	if complete_texture:
		complete_texture.visible = false
		
	if GameState:
		GameState.lock_player_movement()
		_setup_domain_clues(GameState.teacher2_domain)
		
	_setup_grid_slots()

func close_puzzle() -> void:
	visible = false
	if GameState:
		GameState.unlock_player_movement()
	assembly_closed.emit()

func _setup_domain_clues(domain: String) -> void:
	var icon_path: String = "res://assets/puzzles/teacher2/icons/mathematics.png"
	var clue_text: String = ""
	
	match domain.to_lower():
		"mathematics":
			icon_path = "res://assets/puzzles/teacher2/icons/mathematics.png"
			clue_text = "Clue: Numbers follow structure. Align pieces 1 through 9 in numerical order."
		"astronomy":
			icon_path = "res://assets/puzzles/teacher2/icons/astronomy.png"
			clue_text = "Clue: Celestial movement follows orbit. Align the Dharmachakra and solar positions."
		"medicine":
			icon_path = "res://assets/puzzles/teacher2/icons/medicine.png"
			clue_text = "Clue: Balance of elements restores harmony. Match the physical sealing contours."
		"philosophy", "philosophy_logic", "philosophy & logic":
			icon_path = "res://assets/puzzles/teacher2/icons/philosophy_logic.png"
			clue_text = "Clue: Claim -> Evidence -> Conclusion. Arrange fragments into a unified seal."
		_:
			icon_path = "res://assets/puzzles/teacher2/icons/mathematics.png"
			clue_text = "Clue: Numbers follow structure. Align pieces 1 through 9 in numerical order."
			
	if ResourceLoader.exists(icon_path):
		var tex: Texture2D = load(icon_path)
		if domain_icon_texture and tex:
			domain_icon_texture.texture = tex
			
	if clue_label:
		clue_label.text = clue_text

func _setup_grid_slots() -> void:
	if not grid_container:
		return
		
	for child in grid_container.get_children():
		child.queue_free()
		
	for i in range(current_grid.size()):
		var p_id: int = current_grid[i]
		var btn: TextureButton = TextureButton.new()
		btn.custom_minimum_size = Vector2(80, 80)
		btn.ignore_texture_size = true
		btn.stretch_mode = TextureButton.STRETCH_SCALE
		
		var tex_path: String = "res://assets/puzzles/teacher2/puzzle_pieces/seal_piece_" + ("%02d" % p_id) + ".png"
		if ResourceLoader.exists(tex_path):
			btn.texture_normal = load(tex_path)
			
		var slot_idx: int = i
		btn.pressed.connect(func(): _on_slot_clicked(slot_idx))
		grid_container.add_child(btn)

func _on_slot_clicked(slot_idx: int) -> void:
	if is_completed:
		return
		
	if selected_slot_index == -1:
		selected_slot_index = slot_idx
		_highlight_slot(slot_idx, true)
	else:
		if selected_slot_index != slot_idx:
			# Swap pieces in current_grid
			var temp: int = current_grid[selected_slot_index]
			current_grid[selected_slot_index] = current_grid[slot_idx]
			current_grid[slot_idx] = temp
			
		_highlight_slot(selected_slot_index, false)
		selected_slot_index = -1
		_setup_grid_slots()
		_check_win_condition()

func _highlight_slot(slot_idx: int, highlight: bool) -> void:
	if grid_container and slot_idx < grid_container.get_child_count():
		var btn: Control = grid_container.get_child(slot_idx)
		if btn:
			btn.modulate = Color(1.3, 1.2, 0.7, 1.0) if highlight else Color(1, 1, 1, 1)

func _check_win_condition() -> void:
	var target_grid: Array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	var is_correct: bool = true
	for i in range(current_grid.size()):
		if current_grid[i] != target_grid[i]:
			is_correct = false
			break
			
	if is_correct:
		is_completed = true
		if complete_texture:
			complete_texture.visible = true
			
		if GameState:
			GameState.complete_teacher2_puzzle()
			
		assembly_completed.emit()
		
		# Close UI after short delay to trigger Teacher2 dialogue
		get_tree().create_timer(1.2).timeout.connect(func(): close_puzzle())

func _on_close_pressed() -> void:
	close_puzzle()
