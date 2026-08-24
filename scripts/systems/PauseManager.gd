class_name PauseManager
extends Node

var dialogue_manager: Node = null
var quiz_manager: Node = null
var domain_ui: Node = null
var pause_menu_ui: Node = null
var math_puzzle_ui: Node = null
var med_puzzle_ui: Node = null

func setup(d_mgr = null, q_mgr = null, dom_ui = null, pause_ui = null, m_puzzle_ui = null, med_p_ui = null) -> void:
	dialogue_manager = d_mgr
	quiz_manager = q_mgr
	domain_ui = dom_ui
	pause_menu_ui = pause_ui
	math_puzzle_ui = m_puzzle_ui
	med_puzzle_ui = med_p_ui
	process_mode = PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("escape"):
		get_viewport().set_input_as_handled()
		handle_escape_pressed()

func handle_escape_pressed() -> void:
	# Priority 1: IF confirmation dialog is open -> close confirmation dialog, return to pause menu
	if pause_menu_ui and pause_menu_ui.has_method("is_confirmation_open") and pause_menu_ui.is_confirmation_open():
		if pause_menu_ui.has_method("close_confirmation"):
			pause_menu_ui.close_confirmation()
		return
		
	# Priority 2: ELSE IF dialogue is active -> cancel dialogue
	if dialogue_manager and dialogue_manager.has_method("is_active") and dialogue_manager.is_active():
		if dialogue_manager.has_method("cancel_dialogue"):
			dialogue_manager.cancel_dialogue()
		return
		
	# Priority 3: ELSE IF Mathematics puzzle UI is open -> close puzzle UI
	if math_puzzle_ui and ("visible" in math_puzzle_ui) and math_puzzle_ui.visible:
		if math_puzzle_ui.has_method("close_puzzle"):
			math_puzzle_ui.close_puzzle()
		return
		
	# Priority 4: ELSE IF Medicine puzzle UI is open -> close puzzle UI
	if med_puzzle_ui and ("visible" in med_puzzle_ui) and med_puzzle_ui.visible:
		if med_puzzle_ui.has_method("close_puzzle"):
			med_puzzle_ui.close_puzzle()
		return
		
	# Priority 5: ELSE IF domain selection is active -> cancel selection
	if domain_ui and domain_ui.has_method("is_open") and domain_ui.is_open():
		if domain_ui.has_method("cancel_selection"):
			domain_ui.cancel_selection()
		return
		
	# Priority 6: ELSE IF quiz is active -> cancel quiz attempt
	if quiz_manager and quiz_manager.has_method("is_active") and quiz_manager.is_active():
		if quiz_manager.has_method("cancel_quiz"):
			quiz_manager.cancel_quiz()
		return
		
	# Priority 7: ELSE IF pause menu is open -> close pause menu, resume gameplay
	if pause_menu_ui and pause_menu_ui.has_method("is_open") and pause_menu_ui.is_open():
		if pause_menu_ui.has_method("close_pause_menu"):
			pause_menu_ui.close_pause_menu()
		return
		
	# Priority 8: ELSE -> open pause menu
	if pause_menu_ui and pause_menu_ui.has_method("open_pause_menu"):
		pause_menu_ui.open_pause_menu()
