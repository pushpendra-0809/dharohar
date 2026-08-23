extends Control

@onready var dialogue_ui: DialogueUI = $DialogueUI
@onready var pause_menu_ui: PauseMenuUI = $PauseMenuUI
@onready var university_exit: Area2D = $UniversityExit
@onready var player: Node2D = $Player

var dialogue_manager: DialogueManager = null
var pause_manager: PauseManager = null

func _ready() -> void:
	dialogue_manager = DialogueManager.new()
	pause_manager = PauseManager.new()
	
	add_child(dialogue_manager)
	add_child(pause_manager)
	
	if dialogue_ui:
		dialogue_ui.setup(dialogue_manager)
	if pause_manager:
		pause_manager.setup(dialogue_manager, null, null, pause_menu_ui)
		
	if player and player.has_method("set_map_limits"):
		player.set_map_limits(14, 11, 1129, 628, 14.0, 1129.0, 11.0, 628.0)
		
	call_deferred("_check_pending_arrival_message")

func _check_pending_arrival_message() -> void:
	if GameState:
		GameState.unlock_player_movement()
		if GameState.pending_arrival_message.size() > 0:
			var msg_seq: Array = GameState.pending_arrival_message.duplicate()
			GameState.pending_arrival_message = []
			if dialogue_manager:
				dialogue_manager.start_dialogue(msg_seq, _on_arrival_dialogue_finished)

func _on_arrival_dialogue_finished() -> void:
	if GameState:
		GameState.unlock_player_movement()
