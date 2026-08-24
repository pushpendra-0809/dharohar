class_name MathematicsPuzzleUI
extends CanvasLayer

signal puzzle_completed()
signal puzzle_closed()

@onready var color_rect: ColorRect = $ColorRect
@onready var panel_container: Control = $PanelContainer
@onready var title_label: Label = $PanelContainer/TitleLabel
@onready var category_label: Label = $PanelContainer/CategoryLabel
@onready var question_label: Label = $PanelContainer/QuestionBox/QuestionLabel
@onready var answer_slots_container: HBoxContainer = $PanelContainer/AnswerSlotsContainer
@onready var tiles_grid_container: GridContainer = $PanelContainer/TilesGridContainer
@onready var operators_container: HBoxContainer = $PanelContainer/OperatorsContainer
@onready var feedback_label: Label = $PanelContainer/FeedbackLabel
@onready var submit_button: Button = $PanelContainer/SubmitButton
@onready var reset_button: Button = $PanelContainer/ResetButton
@onready var close_button: Button = $PanelContainer/CloseButton
@onready var info_button: Button = $PanelContainer/InfoButton
@onready var puzzle_info_panel = $PuzzleInfoPanel

var questions: Array = []
var current_question_index: int = 0
var constructed_answer: String = ""
var is_solved: bool = false
var is_processing_answer: bool = false

func _ready() -> void:
	visible = false
	if color_rect:
		color_rect.visible = false
	if panel_container:
		panel_container.visible = false
		
	questions = MathematicsQuestions.get_questions()
	
	if submit_button and not submit_button.pressed.is_connected(_on_submit_pressed):
		submit_button.pressed.connect(_on_submit_pressed)
	if reset_button and not reset_button.pressed.is_connected(_on_reset_pressed):
		reset_button.pressed.connect(_on_reset_pressed)
	if close_button and not close_button.pressed.is_connected(_on_close_pressed):
		close_button.pressed.connect(_on_close_pressed)
	if info_button and not info_button.pressed.is_connected(_on_info_pressed):
		info_button.pressed.connect(_on_info_pressed)

func _on_info_pressed() -> void:
	if puzzle_info_panel and puzzle_info_panel.has_method("show_info"):
		puzzle_info_panel.show_info("math")

func open_puzzle() -> void:
	visible = true
	if color_rect:
		color_rect.visible = true
	if panel_container:
		panel_container.visible = true
		
	is_solved = false
	current_question_index = 0
	constructed_answer = ""
	
	if GameState:
		GameState.lock_player_movement()
		
	_setup_number_and_operator_tiles()
	_load_question(current_question_index)

func close_puzzle() -> void:
	visible = false
	if color_rect:
		color_rect.visible = false
	if panel_container:
		panel_container.visible = false
		
	if GameState:
		GameState.unlock_player_movement()
	puzzle_closed.emit()

func _load_question(idx: int) -> void:
	if idx < 0 or idx >= questions.size():
		return
		
	is_processing_answer = false
	if submit_button:
		submit_button.disabled = false
		
	constructed_answer = ""
	_update_answer_display()
	
	var q_data: Dictionary = questions[idx]
	if category_label:
		category_label.text = "Question " + str(idx + 1) + " of " + str(questions.size()) + " — " + q_data.get("category", "")
	if question_label:
		question_label.text = q_data.get("question", "")
	if feedback_label:
		feedback_label.text = ""

func _setup_number_and_operator_tiles() -> void:
	# 1. Setup Number Tiles 0-9 using standard procedural UI buttons
	if tiles_grid_container:
		for child in tiles_grid_container.get_children():
			child.queue_free()
			
		for i in range(10):
			var num_str: String = str(i)
			var btn: Button = Button.new()
			btn.custom_minimum_size = Vector2(44, 44)
			btn.text = num_str
			btn.pressed.connect(func(): _on_tile_pressed(num_str))
			tiles_grid_container.add_child(btn)

	# 2. Setup Operator Tiles +, -, ×, ÷, = using standard procedural UI buttons
	if operators_container:
		for child in operators_container.get_children():
			child.queue_free()
			
		var ops: Array = ["+", "−", "×", "÷", "="]
		for op in ops:
			var btn: Button = Button.new()
			btn.custom_minimum_size = Vector2(44, 44)
			btn.text = op
			btn.pressed.connect(func(): _on_tile_pressed(op))
			operators_container.add_child(btn)

func _on_tile_pressed(symbol: String) -> void:
	if is_processing_answer:
		return
	if constructed_answer.length() < 12:
		constructed_answer += symbol
		_update_answer_display()

func _update_answer_display() -> void:
	if not answer_slots_container:
		return
		
	for child in answer_slots_container.get_children():
		child.queue_free()
		
	if constructed_answer.is_empty():
		var empty_lbl: Label = Label.new()
		empty_lbl.text = "[ Select tiles to form answer ]"
		empty_lbl.modulate = Color(0.65, 0.55, 0.42, 1.0)
		answer_slots_container.add_child(empty_lbl)
	else:
		for char in constructed_answer:
			var slot_panel: PanelContainer = PanelContainer.new()
			slot_panel.custom_minimum_size = Vector2(38, 38)
			var lbl: Label = Label.new()
			lbl.text = char
			lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			slot_panel.add_child(lbl)
			answer_slots_container.add_child(slot_panel)

func _on_reset_pressed() -> void:
	if is_processing_answer:
		return
	constructed_answer = ""
	_update_answer_display()
	if feedback_label:
		feedback_label.text = ""

func _on_submit_pressed() -> void:
	if is_processing_answer or current_question_index >= questions.size():
		return
		
	var q_data: Dictionary = questions[current_question_index]
	var target: String = q_data.get("target_answer", "")
	
	var is_correct: bool = (constructed_answer.strip_edges() == target) or (constructed_answer.ends_with(target))
	
	if is_correct:
		is_processing_answer = true
		if submit_button:
			submit_button.disabled = true
			
		if feedback_label:
			feedback_label.text = "Correct! Your calculation is accurate."
			feedback_label.add_theme_color_override("font_color", Color(0.28, 0.85, 0.35, 1.0))
			
		get_tree().create_timer(1.2).timeout.connect(func():
			current_question_index += 1
			if current_question_index < questions.size():
				_load_question(current_question_index)
			else:
				_on_all_questions_completed()
		)
	else:
		if feedback_label:
			feedback_label.text = "Not quite. Check your calculation and try again."
			feedback_label.add_theme_color_override("font_color", Color(0.95, 0.32, 0.28, 1.0))

func _on_all_questions_completed() -> void:
	is_solved = true
	if GameState:
		if GameState.has_method("complete_math_puzzle"):
			GameState.complete_math_puzzle()
			
	if feedback_label:
		feedback_label.text = "Success! You have completed the Nalanda Number Challenge."
		feedback_label.add_theme_color_override("font_color", Color(0.96, 0.78, 0.28, 1.0))
		
	puzzle_completed.emit()
	get_tree().create_timer(1.5).timeout.connect(func(): close_puzzle())

func _on_close_pressed() -> void:
	close_puzzle()
