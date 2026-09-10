class_name FinalMasteryUI
extends CanvasLayer

signal mastery_completed()
signal ui_closed()

@onready var color_rect: ColorRect = $ColorRect
@onready var main_panel: Control = $MainPanel
@onready var close_button: Button = $MainPanel/Header/CloseButton
@onready var title_label: Label = $MainPanel/Header/TitleLabel
@onready var subtitle_label: Label = $MainPanel/Header/SubtitleLabel

# Phase 1: Investigation & Challenge View
@onready var trial_view: Control = $MainPanel/TrialView
@onready var narrative_text: RichTextLabel = $MainPanel/TrialView/NarrativeText
@onready var clues_text: RichTextLabel = $MainPanel/TrialView/CluesText
@onready var prompt_label: Label = $MainPanel/TrialView/PromptLabel
@onready var options_container: VBoxContainer = $MainPanel/TrialView/OptionsContainer
@onready var option_buttons: Array[Button] = [
	$MainPanel/TrialView/OptionsContainer/OptionA,
	$MainPanel/TrialView/OptionsContainer/OptionB,
	$MainPanel/TrialView/OptionsContainer/OptionC
]

# Phase 2: Feedback & Resolution View
@onready var feedback_view: Control = $MainPanel/FeedbackView
@onready var feedback_status: Label = $MainPanel/FeedbackView/FeedbackStatus
@onready var feedback_text: RichTextLabel = $MainPanel/FeedbackView/FeedbackText
@onready var explanation_text: RichTextLabel = $MainPanel/FeedbackView/ExplanationText
@onready var action_button: Button = $MainPanel/FeedbackView/BtnAction

var current_scenario: Dictionary = {}
var is_open: bool = false
var is_passed: bool = false
var _on_complete_callback: Callable = Callable()

func _ready() -> void:
	add_to_group("final_mastery_ui")
	visible = false
	if color_rect:
		color_rect.visible = false
	if main_panel:
		main_panel.visible = false
		
	_setup_button_events()

func _setup_button_events() -> void:
	if close_button and not close_button.pressed.is_connected(close_ui):
		close_button.pressed.connect(close_ui)
		
	for i in range(option_buttons.size()):
		var btn = option_buttons[i]
		if btn and not btn.pressed.is_connected(_on_option_selected.bind(i)):
			btn.pressed.connect(_on_option_selected.bind(i))
			
	if action_button and not action_button.pressed.is_connected(_on_action_button_pressed):
		action_button.pressed.connect(_on_action_button_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if is_open and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close_ui()

func open_ui(on_complete: Callable = Callable()) -> void:
	var chosen_domain: String = GameState.selected_domain if GameState else "mathematics"
	current_scenario = NarrativeMasteryData.get_final_mastery_scenario(chosen_domain)
	_on_complete_callback = on_complete
	
	is_open = true
	visible = true
	if color_rect:
		color_rect.visible = true
	if main_panel:
		main_panel.visible = true
		
	if GameState:
		GameState.lock_player_movement()
		
	_populate_scenario_ui()

func _populate_scenario_ui() -> void:
	if title_label:
		title_label.text = current_scenario.get("title", "Final Mastery Trial").to_upper()
	if subtitle_label:
		subtitle_label.text = current_scenario.get("subtitle", "Demonstrate Mastery of Your Chosen Domain")
		
	# Setup Narrative Intro
	if narrative_text:
		var narrative_steps: Array = current_scenario.get("narrative", [])
		var formatted: String = ""
		for step in narrative_steps:
			formatted += "[b]" + step.get("speaker", "Teacher 3") + ":[/b] \"" + step.get("text", "") + "\"\n"
		narrative_text.text = formatted
		
	# Setup Clues
	if clues_text:
		var clues: Array = current_scenario.get("investigation_clues", [])
		var formatted_clues: String = "[b][u]INVESTIGATION DOSSIER & CONSTRAINTS:[/u][/b]\n"
		for cl in clues:
			formatted_clues += cl + "\n"
		clues_text.text = formatted_clues
		
	if prompt_label:
		prompt_label.text = current_scenario.get("challenge_prompt", "Choose the optimal resolution plan:")
		
	# Setup Choices
	var choices: Array = current_scenario.get("choices", [])
	for i in range(option_buttons.size()):
		var btn = option_buttons[i]
		if i < choices.size():
			btn.text = choices[i].get("text", "")
			btn.visible = true
		else:
			btn.visible = false
			
	if trial_view:
		trial_view.visible = true
	if feedback_view:
		feedback_view.visible = false

func _on_option_selected(index: int) -> void:
	var choices: Array = current_scenario.get("choices", [])
	if index < 0 or index >= choices.size():
		return
		
	var choice: Dictionary = choices[index]
	is_passed = choice.get("is_correct", false)
	
	if trial_view:
		trial_view.visible = false
	if feedback_view:
		feedback_view.visible = true
		
	if is_passed:
		if feedback_status:
			feedback_status.text = "★ MASTER SYNTHESIS ACHIEVED ★"
			feedback_status.modulate = Color(1, 0.85, 0.2, 1)
		if feedback_text:
			feedback_text.text = "[b][color=#55ff55]" + choice.get("feedback", "Excellent reasoning!") + "[/color][/b]"
		if explanation_text:
			explanation_text.text = "[b]Scholarly Analysis:[/b]\n" + choice.get("explanation", "")
		if action_button:
			action_button.text = "🏆 Conclude Mastery & Present to Council"
			action_button.modulate = Color(1, 0.9, 0.4, 1)
	else:
		if feedback_status:
			feedback_status.text = "DECISION FLAW DETECTED"
			feedback_status.modulate = Color(1, 0.4, 0.4, 1)
		if feedback_text:
			feedback_text.text = "[b][color=#ff6666]" + choice.get("feedback", "The proposed plan had critical flaws.") + "[/color][/b]"
		if explanation_text:
			explanation_text.text = "[b]Deficiency Insight:[/b]\n" + choice.get("explanation", "") + "\n\n[i]Review the constraints and deduce the balanced solution.[/i]"
		if action_button:
			action_button.text = "🔄 Re-evaluate Dossier & Retry"
			action_button.modulate = Color(1, 1, 1, 1)

func _on_action_button_pressed() -> void:
	if is_passed:
		if GameState:
			GameState.complete_final_mastery()
		mastery_completed.emit()
		var cb = _on_complete_callback
		close_ui()
		if cb.is_valid():
			cb.call()
	else:
		# Retry: show trial view
		if trial_view:
			trial_view.visible = true
		if feedback_view:
			feedback_view.visible = false

func close_ui() -> void:
	is_open = false
	visible = false
	if color_rect:
		color_rect.visible = false
	if main_panel:
		main_panel.visible = false
	if GameState:
		GameState.unlock_player_movement()
	ui_closed.emit()
