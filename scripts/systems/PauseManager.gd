class_name PauseManager
extends Node

var dialogue_manager: Node = null
var quiz_manager: Node = null
var domain_ui: Node = null
var pause_menu_ui: Node = null
var math_puzzle_ui: Node = null
var med_puzzle_ui: Node = null
var astro_puzzle_ui: Node = null
var phil_puzzle_ui: Node = null
var knowledge_book_ui: Node = null

func setup(d_mgr = null, q_mgr = null, dom_ui = null, pause_ui = null, m_puzzle_ui = null, med_p_ui = null, astro_p_ui = null, phil_p_ui = null, kb_ui = null) -> void:
	dialogue_manager = d_mgr
	quiz_manager = q_mgr
	domain_ui = dom_ui
	pause_menu_ui = pause_ui
	math_puzzle_ui = m_puzzle_ui
	med_puzzle_ui = med_p_ui
	astro_puzzle_ui = astro_p_ui
	phil_puzzle_ui = phil_p_ui
	knowledge_book_ui = kb_ui
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
		
	# Priority 2.5: ELSE IF Knowledge Book is open -> close knowledge book
	if knowledge_book_ui and ("visible" in knowledge_book_ui) and knowledge_book_ui.visible:
		if knowledge_book_ui.has_method("close_knowledge_book"):
			knowledge_book_ui.close_knowledge_book()
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
		
	# Priority 5: ELSE IF Astronomy puzzle UI is open -> close puzzle UI
	if astro_puzzle_ui and ("visible" in astro_puzzle_ui) and astro_puzzle_ui.visible:
		if astro_puzzle_ui.has_method("close_puzzle"):
			astro_puzzle_ui.close_puzzle()
		return
		
	# Priority 6: ELSE IF Philosophy puzzle UI is open -> close puzzle UI
	if phil_puzzle_ui and ("visible" in phil_puzzle_ui) and phil_puzzle_ui.visible:
		if phil_puzzle_ui.has_method("close_puzzle"):
			phil_puzzle_ui.close_puzzle()
		return
		
	# Priority 7: ELSE IF domain selection is active -> cancel selection
	if domain_ui and domain_ui.has_method("is_open") and domain_ui.is_open():
		if domain_ui.has_method("cancel_selection"):
			domain_ui.cancel_selection()
		return
		
	# Priority 8: ELSE IF quiz is active -> cancel quiz attempt
	if quiz_manager and quiz_manager.has_method("is_active") and quiz_manager.is_active():
		if quiz_manager.has_method("cancel_quiz"):
			quiz_manager.cancel_quiz()
		return
		
	# Priority 9: ELSE IF pause menu is open -> close pause menu, resume gameplay
	if pause_menu_ui and pause_menu_ui.has_method("is_open") and pause_menu_ui.is_open():
		if pause_menu_ui.has_method("close_pause_menu"):
			pause_menu_ui.close_pause_menu()
		return
		
	# Priority 10: ELSE -> open pause menu
	if pause_menu_ui and pause_menu_ui.has_method("open_pause_menu"):
		pause_menu_ui.open_pause_menu()
