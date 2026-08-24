class_name MedicinePuzzleUI
extends CanvasLayer

signal puzzle_completed()
signal puzzle_closed()

@onready var color_rect: ColorRect = $ColorRect
@onready var panel_container: Control = $PanelContainer
@onready var title_label: Label = $PanelContainer/TitleLabel
@onready var case_header_label: Label = $PanelContainer/CaseHeaderLabel
@onready var case_description_label: Label = $PanelContainer/CaseBox/CaseDescriptionLabel
@onready var clues_container: VBoxContainer = $PanelContainer/CluesBox/CluesContainer
@onready var herbs_grid_container: GridContainer = $PanelContainer/HerbsGridContainer
@onready var slots_container: HBoxContainer = $PanelContainer/SlotsContainer
@onready var feedback_label: Label = $PanelContainer/FeedbackLabel
@onready var explanation_label: Label = $PanelContainer/ExplanationLabel
@onready var submit_button: Button = $PanelContainer/SubmitButton
@onready var reset_button: Button = $PanelContainer/ResetButton
@onready var hint_button: Button = $PanelContainer/HintButton
@onready var close_button: Button = $PanelContainer/CloseButton
@onready var info_button: Button = $PanelContainer/InfoButton
@onready var puzzle_info_panel = $PuzzleInfoPanel

var cases: Array = []
var current_case_index: int = 0
var selected_herbs: Array = []
var is_solved: bool = false
var is_processing_answer: bool = false

func _ready() -> void:
	visible = false
	if color_rect:
		color_rect.visible = false
	if panel_container:
		panel_container.visible = false
		
	cases = load("res://scripts/puzzles/MedicineCases.gd").get_cases()
	
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
		puzzle_info_panel.show_info("medicine")

func open_puzzle() -> void:
	visible = true
	if color_rect:
		color_rect.visible = true
	if panel_container:
		panel_container.visible = true
		
	is_solved = false
	current_case_index = 0
	selected_herbs.clear()
	
	if GameState:
		GameState.lock_player_movement()
		
	_load_case(current_case_index)

func close_puzzle() -> void:
	visible = false
	if color_rect:
		color_rect.visible = false
	if panel_container:
		panel_container.visible = false
		
	if GameState:
		GameState.unlock_player_movement()
	puzzle_closed.emit()

func _load_case(idx: int) -> void:
	if idx < 0 or idx >= cases.size():
		return
		
	is_processing_answer = false
	if submit_button:
		submit_button.disabled = false
		
	selected_herbs.clear()
	var c_data: Dictionary = cases[idx]
	
	if case_header_label:
		case_header_label.text = "CASE " + str(idx + 1) + " / " + str(cases.size()) + " — " + c_data.get("title", "")
		
	if case_description_label:
		case_description_label.text = c_data.get("description", "")
		
	if clues_container:
		for child in clues_container.get_children():
			child.queue_free()
			
		var clues: Array = c_data.get("clues", [])
		for clue_text in clues:
			var lbl: Label = Label.new()
			lbl.text = "• " + str(clue_text)
			lbl.add_theme_color_override("font_color", Color(0.92, 0.85, 0.72, 1.0))
			lbl.add_theme_font_size_override("font_size", 15)
			clues_container.add_child(lbl)
			
	if feedback_label:
		feedback_label.text = ""
	if explanation_label:
		explanation_label.text = ""
		
	_setup_herb_cards(c_data.get("available_herbs", []))
	_update_slots_display(c_data.get("max_selections", 2))

func _setup_herb_cards(available_herbs: Array) -> void:
	if not herbs_grid_container:
		return
		
	for child in herbs_grid_container.get_children():
		child.queue_free()
		
	for herb_name in available_herbs:
		var card_btn: Button = Button.new()
		card_btn.custom_minimum_size = Vector2(90, 75)
		
		var vbox: VBoxContainer = VBoxContainer.new()
		vbox.anchors_preset = Control.PRESET_FULL_RECT
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		
		# Herb Texture Icon
		var tex_rect: TextureRect = TextureRect.new()
		tex_rect.custom_minimum_size = Vector2(40, 40)
		tex_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tex_rect.texture_filter = Control.TEXTURE_FILTER_NEAREST
		
		var tex_path: String = "res://Puzzle Assets/Medicine/Herbs/" + herb_name.to_lower() + ".png"
		if ResourceLoader.exists(tex_path):
			tex_rect.texture = load(tex_path)
		vbox.add_child(tex_rect)
		
		var name_lbl: Label = Label.new()
		name_lbl.text = herb_name
		name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_lbl.add_theme_font_size_override("font_size", 14)
		vbox.add_child(name_lbl)
		
		card_btn.add_child(vbox)
		card_btn.pressed.connect(func(): _on_herb_card_pressed(herb_name, card_btn))
		herbs_grid_container.add_child(card_btn)

func _on_herb_card_pressed(herb_name: String, btn: Button) -> void:
	if current_case_index >= cases.size():
		return
		
	var c_data: Dictionary = cases[current_case_index]
	var max_sel: int = c_data.get("max_selections", 2)
	
	if herb_name in selected_herbs:
		selected_herbs.erase(herb_name)
		btn.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		if selected_herbs.size() < max_sel:
			selected_herbs.append(herb_name)
			btn.modulate = Color(0.6, 1.0, 0.6, 1.0)
		else:
			if feedback_label:
				feedback_label.text = "Maximum " + str(max_sel) + " herbs allowed for this case."
				feedback_label.add_theme_color_override("font_color", Color(0.95, 0.75, 0.25, 1.0))
				
	_update_slots_display(max_sel)

func _update_slots_display(max_sel: int) -> void:
	if not slots_container:
		return
		
	for child in slots_container.get_children():
		child.queue_free()
		
	for i in range(max_sel):
		var slot_panel: PanelContainer = PanelContainer.new()
		slot_panel.custom_minimum_size = Vector2(110, 36)
		var lbl: Label = Label.new()
		if i < selected_herbs.size():
			lbl.text = "🌿 " + str(selected_herbs[i])
			lbl.add_theme_color_override("font_color", Color(0.96, 0.85, 0.42, 1.0))
		else:
			lbl.text = "[ Empty Slot ]"
			lbl.add_theme_color_override("font_color", Color(0.55, 0.48, 0.38, 1.0))
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		slot_panel.add_child(lbl)
		slots_container.add_child(slot_panel)

func _on_reset_pressed() -> void:
	selected_herbs.clear()
	if current_case_index < cases.size():
		var c_data: Dictionary = cases[current_case_index]
		_setup_herb_cards(c_data.get("available_herbs", []))
		_update_slots_display(c_data.get("max_selections", 2))
	if feedback_label:
		feedback_label.text = ""
	if explanation_label:
		explanation_label.text = ""

func _on_hint_pressed() -> void:
	if current_case_index < cases.size():
		var c_data: Dictionary = cases[current_case_index]
		if feedback_label:
			feedback_label.text = "HINT: " + c_data.get("hint", "")
			feedback_label.add_theme_color_override("font_color", Color(0.96, 0.78, 0.28, 1.0))

func _on_submit_pressed() -> void:
	if is_processing_answer or current_case_index >= cases.size():
		return
		
	var c_data: Dictionary = cases[current_case_index]
	var targets: Array = c_data.get("correct_answers", [])
	
	# Check if selected_herbs matches targets (regardless of order)
	var is_correct: bool = (selected_herbs.size() == targets.size())
	if is_correct:
		for herb in targets:
			if not (herb in selected_herbs):
				is_correct = false
				break
				
	if is_correct:
		is_processing_answer = true
		if submit_button:
			submit_button.disabled = true
			
		if feedback_label:
			feedback_label.text = "Correct! You matched the clues with the intended herbal knowledge."
			feedback_label.add_theme_color_override("font_color", Color(0.28, 0.85, 0.35, 1.0))
		if explanation_label:
			explanation_label.text = c_data.get("explanation", "")
			
		get_tree().create_timer(1.8).timeout.connect(func():
			current_case_index += 1
			if current_case_index < cases.size():
				_load_case(current_case_index)
			else:
				_on_all_cases_completed()
		)
	else:
		if feedback_label:
			feedback_label.text = "Not quite. Review the clues and try again."
			feedback_label.add_theme_color_override("font_color", Color(0.95, 0.32, 0.28, 1.0))

func _on_all_cases_completed() -> void:
	is_solved = true
	if GameState:
		if GameState.has_method("complete_medicine_puzzle"):
			GameState.complete_medicine_puzzle()
			
	if feedback_label:
		feedback_label.text = "Excellent! You have explored the herbal knowledge of the scholars."
		feedback_label.add_theme_color_override("font_color", Color(0.96, 0.78, 0.28, 1.0))
		
	puzzle_completed.emit()
	get_tree().create_timer(1.8).timeout.connect(func(): close_puzzle())

func _on_close_pressed() -> void:
	close_puzzle()
