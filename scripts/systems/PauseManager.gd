class_name PauseManager
extends Node

var dialogue_manager: DialogueManager = null
var quiz_manager: QuizManager = null
var domain_ui: DomainSelectionUI = null
var pause_menu_ui: PauseMenuUI = null
var puzzle_assembly_ui: PuzzleAssemblyUI = null

func setup(d_mgr: DialogueManager, q_mgr: QuizManager, dom_ui: DomainSelectionUI, pause_ui: PauseMenuUI, puzzle_ui: PuzzleAssemblyUI = null) -> void:
	dialogue_manager = d_mgr
	quiz_manager = q_mgr
	domain_ui = dom_ui
	pause_menu_ui = pause_ui
	puzzle_assembly_ui = puzzle_ui
	process_mode = PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("escape"):
		get_viewport().set_input_as_handled()
		handle_escape_pressed()

func handle_escape_pressed() -> void:
	# Priority 1: IF confirmation dialog is open -> close confirmation dialog, return to pause menu
	if pause_menu_ui and pause_menu_ui.is_confirmation_open():
		pause_menu_ui.close_confirmation()
		return
		
	# Priority 2: ELSE IF dialogue is active -> cancel dialogue
	if dialogue_manager and dialogue_manager.is_active():
		dialogue_manager.cancel_dialogue()
		return
		
	# Priority 3: ELSE IF puzzle assembly UI is open -> close puzzle UI
	if puzzle_assembly_ui and puzzle_assembly_ui.visible:
		puzzle_assembly_ui.close_puzzle()
		return
		
	# Priority 4: ELSE IF domain selection is active -> cancel selection
	if domain_ui and domain_ui.is_open():
		domain_ui.cancel_selection()
		return
		
	# Priority 5: ELSE IF quiz is active -> cancel quiz attempt
	if quiz_manager and quiz_manager.is_active():
		quiz_manager.cancel_quiz()
		return
		
	# Priority 6: ELSE IF pause menu is open -> close pause menu, resume gameplay
	if pause_menu_ui and pause_menu_ui.is_open():
		pause_menu_ui.close_pause_menu()
		return
		
	# Priority 7: ELSE -> open pause menu
	if pause_menu_ui:
		pause_menu_ui.open_pause_menu()
