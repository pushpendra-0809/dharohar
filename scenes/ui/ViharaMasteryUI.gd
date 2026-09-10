class_name ViharaMasteryUI
extends CanvasLayer

signal challenge_completed(domain: String, difficulty: String)
signal ui_closed()

@onready var color_rect: ColorRect = $ColorRect
@onready var main_panel: Control = $MainPanel
@onready var close_button: Button = $MainPanel/Header/CloseButton

# Progress Header
@onready var progress_label: Label = $MainPanel/Header/ProgressLabel
@onready var scroll_status_label: Label = $MainPanel/Header/ScrollStatusLabel

# View 1: Domain Selection
@onready var domain_view: Control = $MainPanel/DomainView
@onready var btn_math: Button = $MainPanel/DomainView/Grid/BtnMath
@onready var btn_astro: Button = $MainPanel/DomainView/Grid/BtnAstro
@onready var btn_med: Button = $MainPanel/DomainView/Grid/BtnMed
@onready var btn_phil: Button = $MainPanel/DomainView/Grid/BtnPhil

@onready var math_status: Label = $MainPanel/DomainView/Grid/BtnMath/MathStatus
@onready var astro_status: Label = $MainPanel/DomainView/Grid/BtnAstro/AstroStatus
@onready var med_status: Label = $MainPanel/DomainView/Grid/BtnMed/MedStatus
@onready var phil_status: Label = $MainPanel/DomainView/Grid/BtnPhil/PhilStatus

# View 2: Difficulty Selection
@onready var difficulty_view: Control = $MainPanel/DifficultyView
@onready var diff_domain_title: Label = $MainPanel/DifficultyView/DomainTitle
@onready var diff_back_button: Button = $MainPanel/DifficultyView/BackButton
@onready var btn_easy: Button = $MainPanel/DifficultyView/VBox/BtnEasy
@onready var btn_med_diff: Button = $MainPanel/DifficultyView/VBox/BtnMedium
@onready var btn_hard: Button = $MainPanel/DifficultyView/VBox/BtnHard
@onready var easy_status: Label = $MainPanel/DifficultyView/VBox/BtnEasy/EasyStatus
@onready var med_diff_status: Label = $MainPanel/DifficultyView/VBox/BtnMedium/MedStatus
@onready var hard_status: Label = $MainPanel/DifficultyView/VBox/BtnHard/HardStatus

# View 3: Challenge Trial
@onready var trial_view: Control = $MainPanel/TrialView
@onready var trial_domain_label: Label = $MainPanel/TrialView/DomainLabel
@onready var trial_mechanic_label: Label = $MainPanel/TrialView/MechanicLabel
@onready var trial_question_label: Label = $MainPanel/TrialView/QuestionBox/QuestionLabel
@onready var trial_back_button: Button = $MainPanel/TrialView/BackButton

@onready var option_a: Button = $MainPanel/TrialView/Options/OptionA
@onready var option_b: Button = $MainPanel/TrialView/Options/OptionB
@onready var option_c: Button = $MainPanel/TrialView/Options/OptionC
@onready var option_d: Button = $MainPanel/TrialView/Options/OptionD

@onready var feedback_panel: Control = $MainPanel/TrialView/FeedbackPanel
@onready var feedback_title: Label = $MainPanel/TrialView/FeedbackPanel/FeedbackTitle
@onready var feedback_exp: Label = $MainPanel/TrialView/FeedbackPanel/FeedbackExp
@onready var explanation_label: Label = $MainPanel/TrialView/FeedbackPanel/ExplanationLabel
@onready var continue_button: Button = $MainPanel/TrialView/FeedbackPanel/ContinueButton

var current_domain: String = ""
var current_difficulty: String = ""
var current_challenge_data: Dictionary = {}
var is_processing: bool = false
var is_open: bool = false

func _ready() -> void:
	add_to_group("vihara_mastery_ui")
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
		
	# Domains
	var d_btns = [btn_math, btn_astro, btn_med, btn_phil]
	var d_names = ["mathematics", "astronomy", "medicine", "philosophy"]
	for i in range(d_btns.size()):
		var b = d_btns[i]
		var dn = d_names[i]
		if b and not b.pressed.is_connected(_on_domain_selected.bind(dn)):
			b.pressed.connect(_on_domain_selected.bind(dn))
			_setup_hover(b)
			
	# Difficulties
	if diff_back_button and not diff_back_button.pressed.is_connected(_show_domain_view):
		diff_back_button.pressed.connect(_show_domain_view)
		_setup_hover(diff_back_button)
		
	if btn_easy and not btn_easy.pressed.is_connected(_on_difficulty_selected.bind("easy")):
		btn_easy.pressed.connect(_on_difficulty_selected.bind("easy"))
		_setup_hover(btn_easy)
	if btn_med_diff and not btn_med_diff.pressed.is_connected(_on_difficulty_selected.bind("medium")):
		btn_med_diff.pressed.connect(_on_difficulty_selected.bind("medium"))
		_setup_hover(btn_med_diff)
	if btn_hard and not btn_hard.pressed.is_connected(_on_difficulty_selected.bind("hard")):
		btn_hard.pressed.connect(_on_difficulty_selected.bind("hard"))
		_setup_hover(btn_hard)
		
	# Trial View
	if trial_back_button and not trial_back_button.pressed.is_connected(_show_difficulty_view):
		trial_back_button.pressed.connect(_show_difficulty_view)
		_setup_hover(trial_back_button)
		
	var opt_btns = [option_a, option_b, option_c, option_d]
	for i in range(opt_btns.size()):
		var b = opt_btns[i]
		if b and not b.pressed.is_connected(_on_option_selected.bind(i)):
			b.pressed.connect(_on_option_selected.bind(i))
			_setup_hover(b)
			
	if continue_button and not continue_button.pressed.is_connected(_on_continue_pressed):
		continue_button.pressed.connect(_on_continue_pressed)
		_setup_hover(continue_button)

func _setup_hover(btn: Button) -> void:
	if not btn:
		return
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	btn.pivot_offset = btn.size / 2.0
	if not btn.mouse_entered.is_connected(_on_btn_hover.bind(btn, true)):
		btn.mouse_entered.connect(_on_btn_hover.bind(btn, true))
	if not btn.mouse_exited.is_connected(_on_btn_hover.bind(btn, false)):
		btn.mouse_exited.connect(_on_btn_hover.bind(btn, false))

func _on_btn_hover(btn: Button, entered: bool) -> void:
	if not btn or btn.disabled:
		return
	var tw = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	if entered:
		tw.tween_property(btn, "scale", Vector2(1.03, 1.03), 0.12)
	else:
		tw.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.12)

func _unhandled_input(event: InputEvent) -> void:
	if not is_open:
		return
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause") or (event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE):
		get_viewport().set_input_as_handled()
		if trial_view and trial_view.visible:
			_show_difficulty_view()
		elif difficulty_view and difficulty_view.visible:
			_show_domain_view()
		else:
			close_ui()

func open_ui(initial_domain: String = "") -> void:
	is_open = true
	visible = true
	if color_rect:
		color_rect.visible = true
	if main_panel:
		main_panel.visible = true
		
	if GameState:
		GameState.lock_player_movement()
		
	if initial_domain != "" and initial_domain.to_lower() in ["mathematics", "astronomy", "medicine", "philosophy"]:
		current_domain = initial_domain.to_lower()
		_show_difficulty_view()
	else:
		_show_domain_view()

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

func _update_progress_header() -> void:
	if not GameState:
		return
		
	var completed_count: int = GameState.get_vihara_completed_count()
	var hard_count: int = GameState.get_vihara_hard_completed_count()
	
	if progress_label:
		progress_label.text = "Vihara Trials Completed: " + str(completed_count) + " / 12  (" + str(hard_count) + "/4 Domain Scrolls)"
		
	if scroll_status_label:
		if GameState.vihara_scroll_earned:
			scroll_status_label.text = "📜 VIHARA SCROLL EARNED!"
			scroll_status_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.2))
		else:
			scroll_status_label.text = "🔒 Vihara Scroll: Complete all 4 Hard Challenges"
			scroll_status_label.add_theme_color_override("font_color", Color(0.8, 0.75, 0.65))

func _show_domain_view() -> void:
	if domain_view:
		domain_view.visible = true
	if difficulty_view:
		difficulty_view.visible = false
	if trial_view:
		trial_view.visible = false
		
	_update_domain_badges()
	_update_progress_header()

func _update_domain_badges() -> void:
	if not GameState:
		return
		
	var doms = ["mathematics", "astronomy", "medicine", "philosophy"]
	var labels = [math_status, astro_status, med_status, phil_status]
	
	for i in range(doms.size()):
		var d = doms[i]
		var lbl = labels[i]
		if lbl:
			var e = "✓" if GameState.is_vihara_challenge_completed(d, "easy") else "—"
			var m = "✓" if GameState.is_vihara_challenge_completed(d, "medium") else "—"
			var h = "★" if GameState.is_vihara_challenge_completed(d, "hard") else "—"
			lbl.text = "Easy: " + e + "  |  Med: " + m + "  |  Hard: " + h

func _on_domain_selected(domain: String) -> void:
	current_domain = domain
	_show_difficulty_view()

func _show_difficulty_view() -> void:
	if domain_view:
		domain_view.visible = false
	if difficulty_view:
		difficulty_view.visible = true
	if trial_view:
		trial_view.visible = false
		
	if diff_domain_title:
		diff_domain_title.text = current_domain.to_upper() + " CHALLENGES"
		
	_update_difficulty_buttons()
	_update_progress_header()

func _update_difficulty_buttons() -> void:
	if not GameState or current_domain == "":
		return
		
	var e_done = GameState.is_vihara_challenge_completed(current_domain, "easy")
	var m_done = GameState.is_vihara_challenge_completed(current_domain, "medium")
	var h_done = GameState.is_vihara_challenge_completed(current_domain, "hard")
	
	var m_unlocked = GameState.is_vihara_difficulty_unlocked(current_domain, "medium")
	var h_unlocked = GameState.is_vihara_difficulty_unlocked(current_domain, "hard")
	
	if btn_easy:
		btn_easy.disabled = false
	if easy_status:
		easy_status.text = "COMPLETED ✓ (+25 EXP)" if e_done else "READY (+25 EXP)"
		
	if btn_med_diff:
		btn_med_diff.disabled = not m_unlocked
	if med_diff_status:
		if m_done:
			med_diff_status.text = "COMPLETED ✓ (+35 EXP)"
		elif m_unlocked:
			med_diff_status.text = "READY (+35 EXP)"
		else:
			med_diff_status.text = "LOCKED 🔒 (Complete Easy first)"
			
	if btn_hard:
		btn_hard.disabled = not h_unlocked
	if hard_status:
		if h_done:
			hard_status.text = "MASTERED ★ (+50 EXP)"
		elif h_unlocked:
			hard_status.text = "READY (+50 EXP)"
		else:
			hard_status.text = "LOCKED 🔒 (Complete Medium first)"

func _on_difficulty_selected(diff: String) -> void:
	current_difficulty = diff
	_start_challenge(current_domain, diff)

func _start_challenge(domain: String, diff: String) -> void:
	current_challenge_data = ViharaChallengeData.get_challenge(domain, diff)
	if current_challenge_data.is_empty():
		return
		
	if domain_view:
		domain_view.visible = false
	if difficulty_view:
		difficulty_view.visible = false
	if trial_view:
		trial_view.visible = true
	if feedback_panel:
		feedback_panel.visible = false
		
	is_processing = false
	
	var dom_info = ViharaChallengeData.CHALLENGES.get(domain, {})
	if trial_domain_label:
		trial_domain_label.text = dom_info.get("title", domain.to_upper())
	if trial_mechanic_label:
		trial_mechanic_label.text = "Tier: " + diff.to_upper() + " — " + current_challenge_data.get("title", "")
		
	if trial_question_label:
		trial_question_label.text = current_challenge_data.get("question", "")
		
	var opts: Array = current_challenge_data.get("options", [])
	var opt_btns = [option_a, option_b, option_c, option_d]
	
	for i in range(opt_btns.size()):
		var b = opt_btns[i]
		if b:
			if i < opts.size():
				b.visible = true
				b.text = opts[i]
				b.disabled = false
			else:
				b.visible = false

func _on_option_selected(idx: int) -> void:
	if is_processing or current_challenge_data.is_empty():
		return
		
	is_processing = true
	var correct_idx = current_challenge_data.get("correct", 0)
	var is_correct = (idx == correct_idx)
	
	var opt_btns = [option_a, option_b, option_c, option_d]
	for b in opt_btns:
		if b:
			b.disabled = true
			
	if feedback_panel:
		feedback_panel.visible = true
		
	if is_correct:
		var exp_reward: int = GameState.VIHARA_EXP_REWARDS.get(current_difficulty, 25)
		if feedback_title:
			feedback_title.text = "✨ CORRECT!"
			feedback_title.add_theme_color_override("font_color", Color(0.3, 0.9, 0.4))
		if feedback_exp:
			feedback_exp.text = "+" + str(exp_reward) + " EXP Earned!"
			feedback_exp.visible = true
		if explanation_label:
			explanation_label.text = current_challenge_data.get("explanation", "")
			
		if GameState:
			GameState.complete_vihara_challenge(current_domain, current_difficulty)
			
		challenge_completed.emit(current_domain, current_difficulty)
	else:
		if feedback_title:
			feedback_title.text = "❌ INCORRECT"
			feedback_title.add_theme_color_override("font_color", Color(0.95, 0.35, 0.35))
		if feedback_exp:
			feedback_exp.visible = false
		if explanation_label:
			explanation_label.text = "Reflect upon monastic principles and observations. Try again!"

func _on_continue_pressed() -> void:
	if feedback_panel:
		feedback_panel.visible = false
	_show_difficulty_view()
