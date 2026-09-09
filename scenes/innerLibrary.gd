extends Control

@onready var dialogue_ui = $DialogueUI
@onready var pause_menu_ui = $PauseMenuUI
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
		pause_manager.call("setup", dialogue_manager, null, null, pause_menu_ui)
		
	if player:
		if player.has_method("set_camera_zoom"):
			player.set_camera_zoom(Vector2(2.35, 2.35))
		if player.has_method("set_map_limits"):
			player.set_map_limits(0, 0, 1152, 648, 80.0, 1072.0, 130.0, 600.0)
		
	call_deferred("_check_arrival")

func _check_arrival() -> void:
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
