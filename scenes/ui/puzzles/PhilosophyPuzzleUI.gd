class_name PhilosophyPuzzleUI
extends CanvasLayer

signal puzzle_completed()
signal puzzle_closed()

@onready var color_rect: ColorRect = $ColorRect
@onready var panel_container: Control = $PanelContainer
@onready var title_label: Label = $PanelContainer/TitleLabel
@onready var round_header_label: Label = $PanelContainer/RoundHeaderLabel
@onready var question_label: Label = $PanelContainer/QuestionBox/QuestionLabel
@onready var claim_label: Label = $PanelContainer/QuestionBox/ClaimLabel
@onready var arguments_container: VBoxContainer = $PanelContainer/ArgumentsBox/LayoutVBox/ArgumentsContainer
@onready var counterargument_box: Panel = $PanelContainer/CounterargumentBox
@onready var counterargument_label: Label = $PanelContainer/CounterargumentBox/LayoutVBox/CounterargumentLabel
@onready var responses_container: VBoxContainer = $PanelContainer/ResponsesBox/LayoutVBox/ResponsesContainer
@onready var feedback_label: Label = $PanelContainer/FeedbackLabel
@onready var explanation_label: Label = $PanelContainer/ExplanationLabel
@onready var submit_button: Button = $PanelContainer/SubmitButton
@onready var reset_button: Button = $PanelContainer/ResetButton
@onready var hint_button: Button = $PanelContainer/HintButton
@onready var close_button: Button = $PanelContainer/CloseButton
@onready var info_button: Button = $PanelContainer/InfoButton
@onready var puzzle_info_panel = $PuzzleInfoPanel

var rounds: Array = []
var current_round_index: int = 0
var selected_argument_index: int = -1
var selected_response_index: int = -1
var is_solved: bool = false
var is_processing_answer: bool = false

func _ready() -> void:
	visible = false
	if color_rect:
		color_rect.visible = false
	if panel_container:
		panel_container.visible = false
		
	rounds = load("res://scripts/puzzles/PhilosophyRounds.gd").get_rounds()
	
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
		puzzle_info_panel.show_info("philosophy")

func open_puzzle() -> void:
	visible = true
	if color_rect:
		color_rect.visible = true
	if panel_container:
		panel_container.visible = true
		
	is_solved = false
	is_processing_answer = false
	current_round_index = 0
	selected_argument_index = -1
	selected_response_index = -1
	
	if GameState:
		GameState.lock_player_movement()
		
	_load_round(current_round_index)

func close_puzzle() -> void:
	visible = false
	if color_rect:
		color_rect.visible = false
	if panel_container:
		panel_container.visible = false
		
	if GameState:
		GameState.unlock_player_movement()
	puzzle_closed.emit()

func _load_round(idx: int) -> void:
	if idx < 0 or idx >= rounds.size():
		return
		
	is_processing_answer = false
	if submit_button:
		submit_button.disabled = false
		
	selected_argument_index = -1
	selected_response_index = -1
	
	var r_data: Dictionary = rounds[idx]
	
	if round_header_label:
		round_header_label.text = "ROUND " + str(idx + 1) + " / " + str(rounds.size()) + " — " + r_data.get("title", "")
		
	if question_label:
		question_label.text = "QUESTION: " + r_data.get("question", "")
	if claim_label:
		claim_label.text = "CLAIM: " + r_data.get("claim", "")
		
	if counterargument_box:
		counterargument_box.visible = true
	if counterargument_label:
		counterargument_label.text = "[ Select an argument on the left to reveal the counterargument ]"
		counterargument_label.add_theme_color_override("font_color", Color(0.65, 0.58, 0.48, 1.0))
		
	if feedback_label:
		feedback_label.text = ""
	if explanation_label:
		explanation_label.text = ""
		
	_setup_argument_cards(r_data.get("arguments", []))
	_setup_response_cards(r_data.get("responses", []))

func _setup_argument_cards(arguments: Array) -> void:
	if not arguments_container:
		return
		
	for child in arguments_container.get_children():
		child.queue_free()
		
	for i in range(arguments.size()):
		var text: String = arguments[i]
		var btn: Button = Button.new()
		btn.custom_minimum_size = Vector2(0, 32)
		btn.text = "A" + str(i + 1) + ": " + text
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.add_theme_font_size_override("font_size", 12.5)
		
		var idx_copy: int = i
		btn.pressed.connect(func(): _on_argument_card_pressed(idx_copy))
		arguments_container.add_child(btn)

func _setup_response_cards(responses: Array) -> void:
	if not responses_container:
		return
		
	for child in responses_container.get_children():
		child.queue_free()
		
	for i in range(responses.size()):
		var text: String = responses[i]
		var btn: Button = Button.new()
		btn.custom_minimum_size = Vector2(0, 32)
		btn.text = "R" + str(i + 1) + ": " + text
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.add_theme_font_size_override("font_size", 12.5)
		
		var idx_copy: int = i
		btn.pressed.connect(func(): _on_response_card_pressed(idx_copy))
		responses_container.add_child(btn)

func _on_argument_card_pressed(idx: int) -> void:
	if is_processing_answer:
		return
		
	selected_argument_index = idx
	
	# Highlight selected argument card
	var children: Array = arguments_container.get_children()
	for i in range(children.size()):
		if i == idx:
			children[i].modulate = Color(0.6, 1.0, 0.6, 1.0)
		else:
			children[i].modulate = Color(1.0, 1.0, 1.0, 1.0)
			
	# Update counterargument text
	if current_round_index < rounds.size():
		var r_data: Dictionary = rounds[current_round_index]
		if counterargument_label:
			counterargument_label.text = r_data.get("counterargument", "")
			counterargument_label.add_theme_color_override("font_color", Color(0.95, 0.88, 0.78, 1.0))

func _on_response_card_pressed(idx: int) -> void:
	if is_processing_answer:
		return
		
	selected_response_index = idx
	
	# Highlight selected response card
	var children: Array = responses_container.get_children()
	for i in range(children.size()):
		if i == idx:
			children[i].modulate = Color(0.6, 1.0, 0.6, 1.0)
		else:
			children[i].modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_reset_pressed() -> void:
	if is_processing_answer:
		return
		
	selected_argument_index = -1
	selected_response_index = -1
	
	if arguments_container:
		for child in arguments_container.get_children():
			child.modulate = Color(1.0, 1.0, 1.0, 1.0)
			
	if responses_container:
		for child in responses_container.get_children():
			child.modulate = Color(1.0, 1.0, 1.0, 1.0)
			
	if counterargument_label:
		counterargument_label.text = "[ Select an argument on the left to reveal the counterargument ]"
		counterargument_label.add_theme_color_override("font_color", Color(0.65, 0.58, 0.48, 1.0))
		
	if feedback_label:
		feedback_label.text = ""
	if explanation_label:
		explanation_label.text = ""

func _on_hint_pressed() -> void:
	if current_round_index < rounds.size():
		var r_data: Dictionary = rounds[current_round_index]
		if feedback_label:
			feedback_label.text = "HINT: " + r_data.get("hint", "")
			feedback_label.add_theme_color_override("font_color", Color(0.96, 0.78, 0.28, 1.0))

func _on_submit_pressed() -> void:
	if is_processing_answer or current_round_index >= rounds.size():
		return
		
	if selected_argument_index < 0 or selected_response_index < 0:
		if feedback_label:
			feedback_label.text = "Please select both an argument and a response before submitting."
			feedback_label.add_theme_color_override("font_color", Color(0.95, 0.75, 0.25, 1.0))
		return
		
	var r_data: Dictionary = rounds[current_round_index]
	var target_arg: int = r_data.get("correct_argument_index", 0)
	var target_resp: int = r_data.get("correct_response_index", 0)
	
	var is_correct: bool = (selected_argument_index == target_arg) and (selected_response_index == target_resp)
	
	if is_correct:
		is_processing_answer = true
		if submit_button:
			submit_button.disabled = true
			
		if feedback_label:
			feedback_label.text = "Well reasoned. You considered the argument carefully."
			feedback_label.add_theme_color_override("font_color", Color(0.28, 0.85, 0.35, 1.0))
		if explanation_label:
			explanation_label.text = r_data.get("explanation", "")
			
		get_tree().create_timer(1.8).timeout.connect(func():
			current_round_index += 1
			if current_round_index < rounds.size():
				_load_round(current_round_index)
			else:
				_on_all_rounds_completed()
		)
	else:
		if feedback_label:
			feedback_label.text = "Not quite. Think carefully about which response addresses the argument."
			feedback_label.add_theme_color_override("font_color", Color(0.95, 0.32, 0.28, 1.0))

func _on_all_rounds_completed() -> void:
	is_solved = true
	if GameState:
		if GameState.has_method("complete_philosophy_puzzle"):
			GameState.complete_philosophy_puzzle()
			
	if feedback_label:
		feedback_label.text = "Excellent. You have demonstrated thoughtful reasoning."
		feedback_label.add_theme_color_override("font_color", Color(0.96, 0.78, 0.28, 1.0))
		
	puzzle_completed.emit()
	get_tree().create_timer(1.8).timeout.connect(func(): close_puzzle())

func _on_close_pressed() -> void:
	close_puzzle()
