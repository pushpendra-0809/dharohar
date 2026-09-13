class_name LibraryMasteryUI
extends CanvasLayer

signal challenge_completed(domain: String, difficulty: String)
signal ui_closed()

# UI References
@onready var color_rect: ColorRect = $ColorRect
@onready var main_panel: Control = $MainPanel
@onready var close_btn: Button = $MainPanel/Header/CloseButton

# Header Labels
@onready var header_title: Label = $MainPanel/Header/TitleLabel
@onready var domain_badge: Label = $MainPanel/Header/DomainBadge
@onready var level_badge: Label = $MainPanel/Header/LevelBadge
@onready var lives_label: Label = $MainPanel/Header/LivesLabel

# Views
@onready var scholar_intro_view: Control = $MainPanel/Views/ScholarIntroView
@onready var scholar_dialogue: Label = $MainPanel/Views/ScholarIntroView/DialogueBox/DialogueLabel
@onready var btn_begin: Button = $MainPanel/Views/ScholarIntroView/Buttons/BtnBegin
@onready var btn_not_yet: Button = $MainPanel/Views/ScholarIntroView/Buttons/BtnNotYet

@onready var level1_view: Control = $MainPanel/Views/Level1View
@onready var l1_clue_label: Label = $MainPanel/Views/Level1View/ClueBox/ClueLabel
@onready var l1_shelf_container: HBoxContainer = $MainPanel/Views/Level1View/ShelfContainer
@onready var l1_inspector_panel: Control = $MainPanel/Views/Level1View/InspectorPanel
@onready var l1_insp_title: Label = $MainPanel/Views/Level1View/InspectorPanel/Title
@onready var l1_insp_author: Label = $MainPanel/Views/Level1View/InspectorPanel/Author
@onready var l1_insp_symbol: Label = $MainPanel/Views/Level1View/InspectorPanel/Symbol
@onready var l1_insp_text: Label = $MainPanel/Views/Level1View/InspectorPanel/Text
@onready var l1_insp_clues: Label = $MainPanel/Views/Level1View/InspectorPanel/Clues
@onready var btn_l1_select: Button = $MainPanel/Views/Level1View/InspectorPanel/BtnSelect
@onready var btn_l1_close_insp: Button = $MainPanel/Views/Level1View/InspectorPanel/BtnCloseInsp

@onready var level2_view: Control = $MainPanel/Views/Level2View
@onready var l2_study_panel: Control = $MainPanel/Views/Level2View/StudyPanel
@onready var l2_study_title: Label = $MainPanel/Views/Level2View/StudyPanel/Title
@onready var l2_study_text: Label = $MainPanel/Views/Level2View/StudyPanel/Text
@onready var btn_l2_studied: Button = $MainPanel/Views/Level2View/StudyPanel/BtnStudied
@onready var l2_quiz_panel: Control = $MainPanel/Views/Level2View/QuizPanel
@onready var l2_quiz_progress: Label = $MainPanel/Views/Level2View/QuizPanel/ProgressLabel
@onready var l2_quiz_question: Label = $MainPanel/Views/Level2View/QuizPanel/QuestionLabel
@onready var l2_opt_a: Button = $MainPanel/Views/Level2View/QuizPanel/Options/OptionA
@onready var l2_opt_b: Button = $MainPanel/Views/Level2View/QuizPanel/Options/OptionB
@onready var l2_opt_c: Button = $MainPanel/Views/Level2View/QuizPanel/Options/OptionC
@onready var l2_opt_d: Button = $MainPanel/Views/Level2View/QuizPanel/Options/OptionD

@onready var level3_view: Control = $MainPanel/Views/Level3View
@onready var l3_instruction: Label = $MainPanel/Views/Level3View/Instruction
@onready var l3_fragments_container: HFlowContainer = $MainPanel/Views/Level3View/FragmentsContainer
@onready var btn_l3_verify_frags: Button = $MainPanel/Views/Level3View/BtnVerifyFrags
@onready var l3_decision_panel: Control = $MainPanel/Views/Level3View/DecisionPanel
@onready var l3_decision_prompt: Label = $MainPanel/Views/Level3View/DecisionPanel/PromptLabel
@onready var l3_cand_a_btn: Button = $MainPanel/Views/Level3View/DecisionPanel/CandidatesBox/CandidateA
@onready var l3_cand_b_btn: Button = $MainPanel/Views/Level3View/DecisionPanel/CandidatesBox/CandidateB

@onready var level_complete_view: Control = $MainPanel/Views/LevelCompleteView
@onready var lvl_comp_title: Label = $MainPanel/Views/LevelCompleteView/Title
@onready var lvl_comp_sub: Label = $MainPanel/Views/LevelCompleteView/Subtitle
@onready var lvl_comp_lives: Label = $MainPanel/Views/LevelCompleteView/LivesCarry
@onready var btn_next_level: Button = $MainPanel/Views/LevelCompleteView/BtnNextLevel

@onready var game_over_view: Control = $MainPanel/Views/GameOverView
@onready var game_over_msg: Label = $MainPanel/Views/GameOverView/Message
@onready var btn_retry: Button = $MainPanel/Views/GameOverView/Buttons/BtnRetry
@onready var btn_exit_fail: Button = $MainPanel/Views/GameOverView/Buttons/BtnExit

@onready var mastery_view: Control = $MainPanel/Views/MasteryView
@onready var mastery_dialogue: Label = $MainPanel/Views/MasteryView/DialogueLabel
@onready var btn_finish_mastery: Button = $MainPanel/Views/MasteryView/BtnReturnNalanda

# State
var current_domain: String = "mathematics"
var current_level: int = 1
var lives: int = 3
var is_active: bool = false

# Level 1 State
var l1_inspected_manuscript: Dictionary = {}

# Level 2 State
var l2_questions: Array = []
var l2_q_index: int = 0

# Level 3 State
var l3_selected_fragment_ids: Array = []

func _ready() -> void:
	add_to_group("library_challenge_ui")
	visible = false
	if color_rect:
		color_rect.visible = false
	if main_panel:
		main_panel.visible = false
		
	_setup_signals()

func _setup_signals() -> void:
	if close_btn and not close_btn.pressed.is_connected(close_ui):
		close_btn.pressed.connect(close_ui)
		_setup_hover(close_btn)
		
	if btn_begin and not btn_begin.pressed.is_connected(_on_begin_pressed):
		btn_begin.pressed.connect(_on_begin_pressed)
		_setup_hover(btn_begin)
		
	if btn_not_yet and not btn_not_yet.pressed.is_connected(close_ui):
		btn_not_yet.pressed.connect(close_ui)
		_setup_hover(btn_not_yet)
		
	if btn_l1_select and not btn_l1_select.pressed.is_connected(_on_l1_manuscript_selected):
		btn_l1_select.pressed.connect(_on_l1_manuscript_selected)
		_setup_hover(btn_l1_select)
		
	if btn_l1_close_insp and not btn_l1_close_insp.pressed.is_connected(_on_l1_close_inspector):
		btn_l1_close_insp.pressed.connect(_on_l1_close_inspector)
		_setup_hover(btn_l1_close_insp)
		
	if btn_l2_studied and not btn_l2_studied.pressed.is_connected(_on_l2_studied_pressed):
		btn_l2_studied.pressed.connect(_on_l2_studied_pressed)
		_setup_hover(btn_l2_studied)
		
	var opt_btns = [l2_opt_a, l2_opt_b, l2_opt_c, l2_opt_d]
	for idx in range(opt_btns.size()):
		var b = opt_btns[idx]
		if b and not b.pressed.is_connected(_on_l2_option_selected.bind(idx)):
			b.pressed.connect(_on_l2_option_selected.bind(idx))
			_setup_hover(b)
			
	if btn_l3_verify_frags and not btn_l3_verify_frags.pressed.is_connected(_on_l3_verify_fragments):
		btn_l3_verify_frags.pressed.connect(_on_l3_verify_fragments)
		_setup_hover(btn_l3_verify_frags)
		
	if l3_cand_a_btn and not l3_cand_a_btn.pressed.is_connected(_on_l3_candidate_selected.bind(0)):
		l3_cand_a_btn.pressed.connect(_on_l3_candidate_selected.bind(0))
		_setup_hover(l3_cand_a_btn)
		
	if l3_cand_b_btn and not l3_cand_b_btn.pressed.is_connected(_on_l3_candidate_selected.bind(1)):
		l3_cand_b_btn.pressed.connect(_on_l3_candidate_selected.bind(1))
		_setup_hover(l3_cand_b_btn)
		
	if btn_next_level and not btn_next_level.pressed.is_connected(_on_next_level_pressed):
		btn_next_level.pressed.connect(_on_next_level_pressed)
		_setup_hover(btn_next_level)
		
	if btn_retry and not btn_retry.pressed.is_connected(_on_retry_pressed):
		btn_retry.pressed.connect(_on_retry_pressed)
		_setup_hover(btn_retry)
		
	if btn_exit_fail and not btn_exit_fail.pressed.is_connected(close_ui):
		btn_exit_fail.pressed.connect(close_ui)
		_setup_hover(btn_exit_fail)
		
	if btn_finish_mastery and not btn_finish_mastery.pressed.is_connected(_on_mastery_finished):
		btn_finish_mastery.pressed.connect(_on_mastery_finished)
		_setup_hover(btn_finish_mastery)

func _setup_hover(btn: Button) -> void:
	if not btn:
		return
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	btn.pivot_offset = btn.size / 2.0
	if not btn.mouse_entered.is_connected(_on_btn_hover.bind(btn, true)):
		btn.mouse_entered.connect(_on_btn_hover.bind(btn, true))
	if not btn.mouse_exited.is_connected(_on_btn_hover.bind(btn, false)):
		btn.mouse_exited.connect(_on_btn_hover.bind(btn, false))

func _on_btn_hover(btn: Control, zoom: bool) -> void:
	btn.pivot_offset = btn.size / 2.0
	var tw = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var sc = Vector2(1.04, 1.04) if zoom else Vector2(1.0, 1.0)
	tw.tween_property(btn, "scale", sc, 0.1)

func _unhandled_input(event: InputEvent) -> void:
	if visible and (event.is_action_pressed("escape") or event.is_action_pressed("ui_cancel")):
		get_viewport().set_input_as_handled()
		close_ui()

func open_challenge(forced_domain: String = "") -> void:
	visible = true
	if color_rect:
		color_rect.visible = true
	if main_panel:
		main_panel.visible = true
		
	if GameState:
		GameState.lock_player_movement()
		if forced_domain != "":
			current_domain = forced_domain.to_lower()
		elif GameState.selected_domain != "":
			current_domain = GameState.selected_domain.to_lower()
		else:
			current_domain = "mathematics"
	else:
		current_domain = forced_domain if forced_domain != "" else "mathematics"
		
	current_level = 1
	lives = 3
	_update_header()
	_show_scholar_intro()

func close_ui() -> void:
	visible = false
	if color_rect:
		color_rect.visible = false
	if main_panel:
		main_panel.visible = false
		
	if GameState:
		GameState.unlock_player_movement()
		
	ui_closed.emit()

func _update_header() -> void:
	var dom_info = LibraryChallengeData.get_domain_info(current_domain)
	if domain_badge:
		domain_badge.text = "✦ " + dom_info.get("name", "Mathematics").to_upper() + " ✦"
	if level_badge:
		var tier_name = "FIND" if current_level == 1 else ("REMEMBER" if current_level == 2 else "RECONSTRUCT & DECIDE")
		level_badge.text = "LEVEL " + str(current_level) + " — " + tier_name
	_update_lives_display()

func _update_lives_display() -> void:
	if not lives_label:
		return
	var hearts_str = ""
	for i in range(3):
		if i < lives:
			hearts_str += "❤️ "
		else:
			hearts_str += "♡ "
	lives_label.text = "LIVES: " + hearts_str.strip_edges()

func _lose_life(reason: String = "") -> void:
	lives = max(0, lives - 1)
	_update_lives_display()
	_flash_screen_red()
	
	if lives <= 0:
		_show_game_over()

func _flash_screen_red() -> void:
	if not color_rect:
		return
	var tw = create_tween()
	tw.tween_property(color_rect, "color", Color(0.6, 0.1, 0.1, 0.75), 0.1)
	tw.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 0.7), 0.25)

# --- VIEW NAVIGATION ---
func _hide_all_views() -> void:
	if scholar_intro_view: scholar_intro_view.visible = false
	if level1_view: level1_view.visible = false
	if level2_view: level2_view.visible = false
	if level3_view: level3_view.visible = false
	if level_complete_view: level_complete_view.visible = false
	if game_over_view: game_over_view.visible = false
	if mastery_view: mastery_view.visible = false

func _show_scholar_intro() -> void:
	_hide_all_views()
	if scholar_intro_view:
		scholar_intro_view.visible = true
	if scholar_dialogue:
		scholar_dialogue.text = "“A vital manuscript folio has gone missing from the Ratnasagara archives.\n\nWe have reorganized many ancient palm-leaf texts, but certain fragments have been displaced.\n\nYou must examine the scholarly clues, identify the genuine treatise, and restore its wisdom.\n\nAre you ready?”"

func _on_begin_pressed() -> void:
	_start_level(current_level)

func _start_level(lvl: int) -> void:
	current_level = lvl
	_hide_all_views()
	_update_header()
	
	if current_level == 1:
		_setup_level1()
	elif current_level == 2:
		_setup_level2()
	elif current_level == 3:
		_setup_level3()

# ==============================================================================
# 1. LEVEL 1: FIND THE RIGHT MANUSCRIPT
# ==============================================================================
func _setup_level1() -> void:
	if level1_view:
		level1_view.visible = true
	if l1_inspector_panel:
		l1_inspector_panel.visible = false
		
	var dom_info = LibraryChallengeData.get_domain_info(current_domain)
	if l1_clue_label:
		l1_clue_label.text = "🔍 SCHOLAR'S INQUIRY:\n" + dom_info.get("scholar_clue", "") + "\n(Symbol: " + dom_info.get("symbol", "") + " | Subject: " + dom_info.get("subject", "") + ")"
		
	for child in l1_shelf_container.get_children():
		child.queue_free()
		
	var manuscripts = LibraryChallengeData.get_level1_manuscripts(current_domain).duplicate()
	manuscripts.shuffle()
	
	for m in manuscripts:
		var m_btn = Button.new()
		m_btn.custom_minimum_size = Vector2(185, 120)
		m_btn.text = "📜 " + m.get("symbol", "") + "\n" + m.get("title", "") + "\n[" + m.get("author", "") + "]"
		m_btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		m_btn.add_theme_font_size_override("font_size", 12)
		m_btn.add_theme_constant_override("line_spacing", 2)
		m_btn.set_meta("manuscript_data", m)
		
		var sb = StyleBoxFlat.new()
		sb.bg_color = Color(0.24, 0.15, 0.09, 0.95)
		sb.border_color = Color(0.85, 0.65, 0.25, 1.0)
		sb.border_width_bottom = 3
		sb.border_width_top = 2
		sb.border_width_left = 2
		sb.border_width_right = 2
		sb.corner_radius_top_left = 8
		sb.corner_radius_top_right = 8
		sb.corner_radius_bottom_left = 8
		sb.corner_radius_bottom_right = 8
		sb.shadow_color = Color(0, 0, 0, 0.45)
		sb.shadow_size = 4
		m_btn.add_theme_stylebox_override("normal", sb)

		var sb_hov = sb.duplicate()
		sb_hov.bg_color = Color(0.38, 0.24, 0.13, 0.98)
		sb_hov.border_color = Color(1.0, 0.88, 0.45, 1.0)
		sb_hov.shadow_color = Color(1.0, 0.7, 0.2, 0.3)
		sb_hov.shadow_size = 6
		m_btn.add_theme_stylebox_override("hover", sb_hov)
		
		m_btn.pressed.connect(_on_l1_inspect_manuscript.bind(m))
		_setup_hover(m_btn)
		l1_shelf_container.add_child(m_btn)

func _on_l1_inspect_manuscript(m: Dictionary) -> void:
	l1_inspected_manuscript = m
	if l1_inspector_panel:
		l1_inspector_panel.visible = true
	if l1_insp_title:
		l1_insp_title.text = "📜 " + m.get("title", "")
	if l1_insp_author:
		l1_insp_author.text = "Author / Lineage: " + m.get("author", "")
	if l1_insp_symbol:
		l1_insp_symbol.text = "Seal: " + m.get("symbol", "") + " | Subject: " + m.get("subject", "")
	if l1_insp_text:
		l1_insp_text.text = m.get("excerpt", "")
	if l1_insp_clues:
		l1_insp_clues.text = m.get("clues", "")

func _on_l1_close_inspector() -> void:
	if l1_inspector_panel:
		l1_inspector_panel.visible = false

func _on_l1_manuscript_selected() -> void:
	if l1_inspected_manuscript.is_empty():
		return
		
	var is_correct = l1_inspected_manuscript.get("is_correct", false)
	if is_correct:
		if l1_inspector_panel:
			l1_inspector_panel.visible = false
		_on_level_cleared()
	else:
		_lose_life("Selected incorrect distractor manuscript")
		if l1_insp_author:
			l1_insp_author.text = "❌ INCORRECT MANUSCRIPT. Check scholar's subject and symbol."
			l1_insp_author.add_theme_color_override("font_color", Color(1.0, 0.35, 0.35))

# ==============================================================================
# 2. LEVEL 2: REMEMBER & COMPARE
# ==============================================================================
func _setup_level2() -> void:
	if level2_view:
		level2_view.visible = true
	if l2_study_panel:
		l2_study_panel.visible = true
	if l2_quiz_panel:
		l2_quiz_panel.visible = false
		
	var study_data = LibraryChallengeData.get_level2_study(current_domain)
	if l2_study_title:
		l2_study_title.text = "📜 " + study_data.get("title", "")
	if l2_study_text:
		l2_study_text.text = study_data.get("study_text", "")
		
	l2_questions = study_data.get("questions", []).duplicate()
	l2_q_index = 0

func _on_l2_studied_pressed() -> void:
	if l2_study_panel:
		l2_study_panel.visible = false
	if l2_quiz_panel:
		l2_quiz_panel.visible = true
	_show_l2_question(l2_q_index)

func _show_l2_question(idx: int) -> void:
	if idx >= l2_questions.size():
		_on_level_cleared()
		return
		
	var qdata = l2_questions[idx]
	if l2_quiz_progress:
		l2_quiz_progress.text = "MEMORY RECALL — QUESTION " + str(idx + 1) + " OF " + str(l2_questions.size())
	if l2_quiz_question:
		l2_quiz_question.text = qdata.get("question", "")
		
	var opts: Array = qdata.get("options", [])
	var opt_btns = [l2_opt_a, l2_opt_b, l2_opt_c, l2_opt_d]
	
	for i in range(opt_btns.size()):
		var b = opt_btns[i]
		if b:
			if i < opts.size():
				b.visible = true
				b.text = opts[i]
				b.disabled = false
				b.modulate = Color(1, 1, 1, 1)
			else:
				b.visible = false

func _on_l2_option_selected(idx: int) -> void:
	if l2_q_index >= l2_questions.size():
		return
		
	var qdata = l2_questions[l2_q_index]
	var correct_idx = qdata.get("correct", 0)
	
	var opt_btns = [l2_opt_a, l2_opt_b, l2_opt_c, l2_opt_d]
	for b in opt_btns:
		if b:
			b.disabled = true
			
	if idx == correct_idx:
		if opt_btns[idx]:
			opt_btns[idx].modulate = Color(0.4, 1.0, 0.4)
		var tw = create_tween()
		tw.tween_interval(0.6)
		tw.tween_callback(func():
			l2_q_index += 1
			_show_l2_question(l2_q_index)
		)
	else:
		_lose_life("Incorrect memory answer")
		if opt_btns[idx]:
			opt_btns[idx].modulate = Color(1.0, 0.35, 0.35)
		var tw = create_tween()
		tw.tween_interval(0.8)
		tw.tween_callback(func():
			for b in opt_btns:
				if b:
					b.disabled = false
					b.modulate = Color(1, 1, 1, 1)
		)

# ==============================================================================
# 3. LEVEL 3: RECONSTRUCT & DECIDE
# ==============================================================================
func _setup_level3() -> void:
	if level3_view:
		level3_view.visible = true
	if l3_instruction:
		l3_instruction.visible = true
	if l3_decision_panel:
		l3_decision_panel.visible = false
	if l3_fragments_container:
		l3_fragments_container.visible = true
	if btn_l3_verify_frags:
		btn_l3_verify_frags.visible = true
		
	var mystery_data = LibraryChallengeData.get_level3_mystery(current_domain)
	if l3_instruction:
		l3_instruction.text = "Select all genuine fragments that belong to the lost manuscript, then assemble the reconstructed manuscript."
		
	for child in l3_fragments_container.get_children():
		child.queue_free()
		
	l3_selected_fragment_ids.clear()
	var frags: Array = mystery_data.get("fragments", []).duplicate()
	frags.shuffle()
	
	for f in frags:
		var f_btn = Button.new()
		f_btn.custom_minimum_size = Vector2(270, 75)
		f_btn.text = f.get("text", "")
		f_btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		f_btn.add_theme_font_size_override("font_size", 11)
		f_btn.set_meta("frag_data", f)
		f_btn.set_meta("is_selected", false)
		
		var sb = StyleBoxFlat.new()
		sb.bg_color = Color(0.2, 0.14, 0.1, 0.95)
		sb.border_color = Color(0.65, 0.5, 0.3)
		sb.border_width_bottom = 2
		sb.border_width_top = 1
		sb.border_width_left = 1
		sb.border_width_right = 1
		sb.corner_radius_top_left = 4
		sb.corner_radius_top_right = 4
		sb.corner_radius_bottom_left = 4
		sb.corner_radius_bottom_right = 4
		f_btn.add_theme_stylebox_override("normal", sb)
		
		f_btn.pressed.connect(_on_l3_fragment_clicked.bind(f_btn))
		_setup_hover(f_btn)
		l3_fragments_container.add_child(f_btn)

func _on_l3_fragment_clicked(btn: Button) -> void:
	if not is_instance_valid(btn):
		return
	var fdata = btn.get_meta("frag_data", {})
	var fid = fdata.get("id", "")
	var is_sel = btn.get_meta("is_selected", false)
	
	if is_sel:
		btn.set_meta("is_selected", false)
		l3_selected_fragment_ids.erase(fid)
		btn.modulate = Color(1, 1, 1, 1)
	else:
		btn.set_meta("is_selected", true)
		l3_selected_fragment_ids.append(fid)
		btn.modulate = Color(1.0, 0.85, 0.4)

func _on_l3_verify_fragments() -> void:
	var mystery_data = LibraryChallengeData.get_level3_mystery(current_domain)
	var frags: Array = mystery_data.get("fragments", [])
	
	var genuine_ids = []
	for f in frags:
		if f.get("is_genuine", false):
			genuine_ids.append(f.get("id", ""))
			
	var selection_correct = (l3_selected_fragment_ids.size() == genuine_ids.size())
	for gid in genuine_ids:
		if not l3_selected_fragment_ids.has(gid):
			selection_correct = false
			break
			
	if selection_correct:
		# Transition to Scholar's Contradiction Decision Phase
		_show_l3_decision_phase()
	else:
		_lose_life("Selected invalid or incomplete fragments")
		if l3_instruction:
			l3_instruction.text = "❌ Fragment reconstruction flawed. Ensure you select only genuine fragments of your subject."
			l3_instruction.add_theme_color_override("font_color", Color(1.0, 0.35, 0.35))

func _show_l3_decision_phase() -> void:
	if l3_fragments_container:
		l3_fragments_container.visible = false
	if btn_l3_verify_frags:
		btn_l3_verify_frags.visible = false
	if l3_decision_panel:
		l3_decision_panel.visible = true
	if l3_instruction:
		l3_instruction.visible = false
		
	var mystery_data = LibraryChallengeData.get_level3_mystery(current_domain)
	if l3_decision_prompt:
		l3_decision_prompt.text = "“Both manuscripts appear related to the same subject, yet there is a critical distinction between them.”\n" + mystery_data.get("scholar_prompt", "") + "\n\n✦ Which reconstructed manuscript should be returned to the Scholar? ✦"
		
	var candidates: Array = mystery_data.get("candidates", [])
	if candidates.size() >= 2:
		if l3_cand_a_btn:
			l3_cand_a_btn.text = "📜 " + candidates[0].get("title", "") + "\n\n" + candidates[0].get("text", "")
		if l3_cand_b_btn:
			l3_cand_b_btn.text = "📜 " + candidates[1].get("title", "") + "\n\n" + candidates[1].get("text", "")

func _on_l3_candidate_selected(idx: int) -> void:
	var mystery_data = LibraryChallengeData.get_level3_mystery(current_domain)
	var candidates: Array = mystery_data.get("candidates", [])
	if idx >= candidates.size():
		return
		
	var cand = candidates[idx]
	var is_correct = cand.get("is_correct", false)
	
	if is_correct:
		_on_level_cleared()
	else:
		_lose_life("Selected flawed candidate manuscript")
		if l3_decision_prompt:
			l3_decision_prompt.text = "❌ " + cand.get("explanation", "Flawed decision.") + "\nReflect upon authentic evidence and reconsider."
			l3_decision_prompt.add_theme_color_override("font_color", Color(1.0, 0.35, 0.35))

# ==============================================================================
# LEVEL CLEARED & LEVEL COMPLETE / MASTERY
# ==============================================================================
func _on_level_cleared() -> void:
	if current_level < 3:
		_show_level_complete_modal()
	else:
		_show_mastery_complete_modal()

func _show_level_complete_modal() -> void:
	_hide_all_views()
	if level_complete_view:
		level_complete_view.visible = true
	if lvl_comp_title:
		lvl_comp_title.text = "✨ LEVEL " + str(current_level) + " COMPLETE! ✨"
	if lvl_comp_sub:
		var next_tier = "Remember & Compare" if current_level == 1 else "Reconstruct & Decide"
		lvl_comp_sub.text = "Investigation progressing. Ready to proceed to Level " + str(current_level + 1) + " (" + next_tier + ")."
	if lvl_comp_lives:
		var hearts_str = ""
		for i in range(3):
			hearts_str += "❤️ " if i < lives else "♡ "
		lvl_comp_lives.text = "Lives Carried Forward: " + hearts_str.strip_edges() + "\n(Lives DO NOT reset between levels)"

func _on_next_level_pressed() -> void:
	_start_level(current_level + 1)

func _show_game_over() -> void:
	_hide_all_views()
	if game_over_view:
		game_over_view.visible = true
	if game_over_msg:
		game_over_msg.text = "“The manuscript remains undiscovered. Observe the clues once more.”\n\n(Retry investigation from Level 1 with 3 lives or return to Nalanda.)"

func _on_retry_pressed() -> void:
	current_level = 1
	lives = 3
	_start_level(1)

func _show_mastery_complete_modal() -> void:
	_hide_all_views()
	if mastery_view:
		mastery_view.visible = true
	if mastery_dialogue:
		mastery_dialogue.text = "“You did not merely recover an ancient text.\n\nYou observed, remembered, compared, and discerned the truth.”"
		
	if GameState:
		GameState.complete_library_mastery()
	challenge_completed.emit(current_domain, "hard")

func _on_mastery_finished() -> void:
	close_ui()
