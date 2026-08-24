extends Control

@onready var dialogue_ui = $DialogueUI
@onready var pause_menu_ui = $PauseMenuUI
@onready var math_puzzle_ui = $MathematicsPuzzleUI
@onready var med_puzzle_ui = $MedicinePuzzleUI
@onready var astro_puzzle_ui = $AstronomyPuzzleUI
@onready var phil_puzzle_ui = $PhilosophyPuzzleUI
@onready var university_exit = $UniversityExit
@onready var teacher2 = $Teacher2
@onready var player = $Player

var dialogue_manager: Node = null
var pause_manager: Node = null

func _ready() -> void:
	dialogue_manager = DialogueManager.new()
	pause_manager = PauseManager.new()
	
	add_child(dialogue_manager)
	add_child(pause_manager)
	
	if dialogue_ui and dialogue_ui.has_method("setup"):
		dialogue_ui.setup(dialogue_manager)
	if pause_manager and pause_manager.has_method("setup"):
		pause_manager.call("setup", dialogue_manager, null, null, pause_menu_ui, math_puzzle_ui, med_puzzle_ui, astro_puzzle_ui, phil_puzzle_ui)
		
	if teacher2 and teacher2.has_method("setup_manager"):
		teacher2.setup_manager(dialogue_manager, math_puzzle_ui, med_puzzle_ui, astro_puzzle_ui, phil_puzzle_ui)
		
	if player and player.has_method("set_map_limits"):
		player.set_map_limits(14, 11, 1129, 628, 14.0, 1129.0, 11.0, 628.0)
		
	call_deferred("_check_pending_arrival_message")

func _check_pending_arrival_message() -> void:
	if GameState:
		GameState.unlock_player_movement()
		if GameState.pending_arrival_message.size() > 0:
			var msg_seq: Array = GameState.pending_arrival_message.duplicate()
			GameState.pending_arrival_message = []
			if dialogue_manager and dialogue_manager.has_method("start_dialogue"):
				dialogue_manager.start_dialogue(msg_seq, _on_arrival_dialogue_finished)

func _on_arrival_dialogue_finished() -> void:
	if GameState:
		GameState.unlock_player_movement()
