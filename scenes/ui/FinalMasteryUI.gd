class_name FinalMasteryUI
extends CanvasLayer

signal mastery_completed()
signal ui_closed()

@onready var color_rect: ColorRect = $ColorRect
@onready var main_panel: Control = $MainPanel
@onready var close_button: Button = $MainPanel/Header/CloseButton

# Progress Indicator Badges
@onready var stage_badges: Array[Label] = [
	$MainPanel/Header/StageIndicators/Stage1,
	$MainPanel/Header/StageIndicators/Stage2,
	$MainPanel/Header/StageIndicators/Stage3,
	$MainPanel/Header/StageIndicators/Stage4,
	$MainPanel/Header/StageIndicators/Stage5
]

# View 1: Confirmation View
@onready var confirm_view: Control = $MainPanel/ConfirmView
@onready var btn_begin: Button = $MainPanel/ConfirmView/VBox/BtnBegin
@onready var btn_not_yet: Button = $MainPanel/ConfirmView/VBox/BtnNotYet
@onready var confirm_desc: Label = $MainPanel/ConfirmView/DescLabel

# View 2: Trial View
@onready var trial_view: Control = $MainPanel/TrialView
@onready var stage_domain_label: Label = $MainPanel/TrialView/DomainLabel
@onready var stage_subtitle_label: Label = $MainPanel/TrialView/SubtitleLabel
@onready var question_label: Label = $MainPanel/TrialView/QuestionScroll/QuestionLabel
@onready var option_buttons: Array[Button] = [
	$MainPanel/TrialView/Options/OptionA,
	$MainPanel/TrialView/Options/OptionB,
	$MainPanel/TrialView/Options/OptionC,
	$MainPanel/TrialView/Options/OptionD
]

# Feedback Panel (inside TrialView)
@onready var feedback_panel: Control = $MainPanel/TrialView/FeedbackPanel
@onready var feedback_title: Label = $MainPanel/TrialView/FeedbackPanel/FeedbackTitle
@onready var feedback_exp: Label = $MainPanel/TrialView/FeedbackPanel/FeedbackExp
@onready var explanation_label: Label = $MainPanel/TrialView/FeedbackPanel/ExplanationScroll/ExplanationLabel
@onready var hint_label: Label = $MainPanel/TrialView/FeedbackPanel/HintLabel
@onready var continue_button: Button = $MainPanel/TrialView/FeedbackPanel/ContinueButton

# View 3: Victory View
@onready var victory_view: Control = $MainPanel/VictoryView
@onready var victory_desc: Label = $MainPanel/VictoryView/VictoryDesc
@onready var btn_finish: Button = $MainPanel/VictoryView/BtnFinish

var current_stage_idx: int = 0
var current_stage_data: Dictionary = {}
var is_processing: bool = false
var is_open: bool = false
var is_last_answer_correct: bool = false

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
		_setup_hover(close_button)
		
	if btn_begin and not btn_begin.pressed.is_connected(_on_begin_pressed):
		btn_begin.pressed.connect(_on_begin_pressed)
		_setup_hover(btn_begin)
		
	if btn_not_yet and not btn_not_yet.pressed.is_connected(close_ui):
		btn_not_yet.pressed.connect(close_ui)
		_setup_hover(btn_not_yet)
		
	for i in range(option_buttons.size()):
		var btn = option_buttons[i]
		if btn and not btn.pressed.is_connected(_on_option_selected.bind(i)):
			btn.pressed.connect(_on_option_selected.bind(i))
			_setup_hover(btn)
			
	if continue_button and not continue_button.pressed.is_connected(_on_feedback_continue):
		continue_button.pressed.connect(_on_feedback_continue)
		_setup_hover(continue_button)
		
	if btn_finish and not btn_finish.pressed.is_connected(_on_finish_pressed):
		btn_finish.pressed.connect(_on_finish_pressed)
		_setup_hover(btn_finish)

func _setup_hover(btn: Button) -> void:
	if not btn:
		return
	if not btn.mouse_entered.is_connected(_play_hover):
		btn.mouse_entered.connect(_play_hover)

func _play_hover() -> void:
	# Optional sound hook
	pass

func _unhandled_input(event: InputEvent) -> void:
	if is_open and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close_ui()

func open_ui() -> void:
	if not GameState or not GameState.final_mastery_unlocked:
		return
		
	is_open = true
	visible = true
	if color_rect:
		color_rect.visible = true
	if main_panel:
		main_panel.visible = true
		
	GameState.lock_player_movement()
	
	if GameState.final_mastery_complete:
		_show_victory_view()
	else:
		_show_confirm_view()

func _update_stage_indicators() -> void:
	var stage_ids = ["mathematics", "astronomy", "medicine", "philosophy", "integrated"]
	var stage_names = ["1. Math", "2. Astro", "3. Med", "4. Phil", "5. Synthesis"]
	
	for i in range(stage_badges.size()):
		var badge = stage_badges[i]
		if not badge:
			continue
		var s_id = stage_ids[i]
		var is_done = GameState.is_final_mastery_stage_complete(s_id) if GameState else false
		
		if is_done:
			badge.text = "[✓] " + stage_names[i]
			badge.modulate = Color(0.4, 1.0, 0.4, 1.0)
		elif i == current_stage_idx:
			badge.text = "[▶] " + stage_names[i]
			badge.modulate = Color(1.0, 0.85, 0.3, 1.0)
		else:
			badge.text = "[ ] " + stage_names[i]
			badge.modulate = Color(0.65, 0.65, 0.65, 0.8)

func _show_confirm_view() -> void:
	_update_stage_indicators()
	if confirm_view:
		confirm_view.visible = true
	if trial_view:
		trial_view.visible = false
	if victory_view:
		victory_view.visible = false
	if feedback_panel:
		feedback_panel.visible = false
		
	var completed_count = GameState.get_final_mastery_completed_count() if GameState else 0
	if completed_count > 0:
		confirm_desc.text = "You have completed " + str(completed_count) + " of 5 mastery stages.\n\nContinue your final demonstration to attain the title of Nalanda Maha-Acharya."
		btn_begin.text = "Continue Final Mastery (" + str(completed_count + 1) + "/5)"
	else:
		confirm_desc.text = "Acharya! You have earned the sacred scrolls of the Stupa, Library, and Vihara.\n\nNow you must prove that you can CONNECT and APPLY what you learned across Mathematics, Astronomy, Medicine, and Philosophy in 5 rigorous interconnected stages.\n\nAre you prepared to take the Final Mastery Challenge?"
		btn_begin.text = "Begin Final Mastery"

func _on_begin_pressed() -> void:
	# Find first incomplete stage
	var stage_ids = ["mathematics", "astronomy", "medicine", "philosophy", "integrated"]
	current_stage_idx = 0
	for i in range(stage_ids.size()):
		if not GameState.is_final_mastery_stage_complete(stage_ids[i]):
			current_stage_idx = i
			break
			
	_load_stage(current_stage_idx)

func _load_stage(idx: int) -> void:
	if idx < 0 or idx >= FinalMasteryData.get_stage_count():
		_show_victory_view()
		return
		
	current_stage_idx = idx
	current_stage_data = FinalMasteryData.get_stage(idx)
	is_processing = false
	
	_update_stage_indicators()
	
	if confirm_view:
		confirm_view.visible = false
	if victory_view:
		victory_view.visible = false
	if trial_view:
		trial_view.visible = true
	if feedback_panel:
		feedback_panel.visible = false
		
	if stage_domain_label:
		stage_domain_label.text = current_stage_data.get("domain", "").to_upper()
	if stage_subtitle_label:
		stage_subtitle_label.text = current_stage_data.get("subtitle", "")
	if question_label:
		question_label.text = current_stage_data.get("question", "")
		
	var opts = current_stage_data.get("options", [])
	for i in range(option_buttons.size()):
		var btn = option_buttons[i]
		if not btn:
			continue
		if i < opts.size():
			btn.text = opts[i]
			btn.visible = true
			btn.disabled = false
			btn.modulate = Color(1.0, 1.0, 1.0, 1.0)
		else:
			btn.visible = false

func _on_option_selected(index: int) -> void:
	if is_processing or not current_stage_data:
		return
		
	is_processing = true
	for btn in option_buttons:
		if btn:
			btn.disabled = true
			
	var correct_idx = current_stage_data.get("correct", 0)
	var is_correct = (index == correct_idx)
	is_last_answer_correct = is_correct
	
	# Highlight buttons
	if index < option_buttons.size() and option_buttons[index]:
		if is_correct:
			option_buttons[index].modulate = Color(0.4, 1.0, 0.4, 1.0)
		else:
			option_buttons[index].modulate = Color(1.0, 0.35, 0.35, 1.0)
			
	if is_correct and correct_idx < option_buttons.size() and option_buttons[correct_idx]:
		option_buttons[correct_idx].modulate = Color(0.4, 1.0, 0.4, 1.0)
		
	# Show feedback
	_show_feedback(is_correct)

func _show_feedback(is_correct: bool) -> void:
	if not feedback_panel:
		return
		
	feedback_panel.visible = true
	
	if is_correct:
		feedback_title.text = "VICHAAR SAHI HAI! (Mastery Demonstration Valid)"
		feedback_title.modulate = Color(1.0, 0.85, 0.2, 1.0)
		feedback_exp.text = "Stage " + str(current_stage_idx + 1) + " of 5 Completed!"
		feedback_exp.visible = true
		explanation_label.text = current_stage_data.get("explanation", "")
		hint_label.visible = false
		
		# Mark stage complete in GameState
		var s_id = current_stage_data.get("id", "")
		if GameState:
			GameState.complete_final_mastery_stage(s_id)
			
		_update_stage_indicators()
		
		if current_stage_idx >= FinalMasteryData.get_stage_count() - 1:
			continue_button.text = "Attain Maha-Acharya Title →"
		else:
			continue_button.text = "Proceed to Next Stage →"
	else:
		feedback_title.text = "PUNAH PRAYAS KAREIN (Needs Rigorous Re-examination)"
		feedback_title.modulate = Color(1.0, 0.4, 0.4, 1.0)
		feedback_exp.visible = false
		explanation_label.text = "Your deduction overlooks critical Nalanda principles for this domain.\n\n" + current_stage_data.get("explanation", "")
		hint_label.visible = true
		hint_label.text = "Acharya's Guidance: " + current_stage_data.get("hint", "")
		continue_button.text = "Retry Stage"

func _on_feedback_continue() -> void:
	if is_last_answer_correct:
		if current_stage_idx >= FinalMasteryData.get_stage_count() - 1:
			_show_victory_view()
		else:
			_load_stage(current_stage_idx + 1)
	else:
		# Retry current stage
		_load_stage(current_stage_idx)

func _show_victory_view() -> void:
	_update_stage_indicators()
	if confirm_view:
		confirm_view.visible = false
	if trial_view:
		trial_view.visible = false
	if feedback_panel:
		feedback_panel.visible = false
	if victory_view:
		victory_view.visible = true
		
	if victory_desc:
		victory_desc.text = "Congratulations, Scholar!\n\nYou have demonstrated profound mastery across Mathematics, Astronomy, Medicine, and Philosophy — uniting all streams into one harmonious worldview.\n\nAwarded: +100 EXP (Nalanda Capstone Mastery)"
		
	mastery_completed.emit()

func _on_finish_pressed() -> void:
	close_ui()

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
