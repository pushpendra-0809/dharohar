extends Control

@onready var dialogue_ui = $DialogueUI
@onready var pause_menu_ui = $PauseMenuUI
@onready var player = $Player
@onready var objective_hud = get_node_or_null("ViharaObjectiveHUD")
@onready var completion_ui = get_node_or_null("ViharaCompletionUI")

var dialogue_manager: DialogueManager = null
var pause_manager: PauseManager = null
var vihara_manager: ViharaManager = null

func _ready() -> void:
	dialogue_manager = DialogueManager.new()
	pause_manager = PauseManager.new()
	vihara_manager = ViharaManager.new()
	
	add_child(dialogue_manager)
	add_child(pause_manager)
	add_child(vihara_manager)
	
	if dialogue_ui and dialogue_ui.has_method("setup"):
		dialogue_ui.setup(dialogue_manager)
	if pause_manager and pause_manager.has_method("setup"):
		pause_manager.call("setup", dialogue_manager, null, null, pause_menu_ui)
		
	if vihara_manager and vihara_manager.has_method("setup"):
		vihara_manager.setup(dialogue_manager, objective_hud, completion_ui)
		
	for interactable in get_tree().get_nodes_in_group("vihara_interactables"):
		if interactable.has_method("setup"):
			interactable.setup(dialogue_manager, vihara_manager)
			
	for point in get_tree().get_nodes_in_group("interaction_points"):
		if point.has_method("setup_manager"):
			point.setup_manager(dialogue_manager)
			
	if player:
		if player.has_method("set_camera_zoom"):
			player.set_camera_zoom(Vector2(2.35, 2.35))
		if player.has_method("set_map_limits"):
			player.set_map_limits(0, 0, 1152, 648, 70.0, 1082.0, 80.0, 580.0)
		
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
