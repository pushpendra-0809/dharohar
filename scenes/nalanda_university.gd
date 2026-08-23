extends Control

@onready var dialogue_ui: DialogueUI = $DialogueUI
@onready var pause_menu_ui: PauseMenuUI = $PauseMenuUI
@onready var puzzle_assembly_ui: PuzzleAssemblyUI = $PuzzleAssemblyUI
@onready var university_exit: Area2D = $UniversityExit
@onready var teacher2: Node = $Teacher2
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
		pause_manager.setup(dialogue_manager, null, null, pause_menu_ui, puzzle_assembly_ui)
		
	if teacher2 and teacher2.has_method("setup_manager"):
		teacher2.setup_manager(dialogue_manager)
		
	if player and player.has_method("set_map_limits"):
		player.set_map_limits(14, 11, 1129, 628, 14.0, 1129.0, 11.0, 628.0)
		
	call_deferred("_sync_puzzle_pieces")
	call_deferred("_check_pending_arrival_message")

func _sync_puzzle_pieces() -> void:
	if not GameState or not GameState.teacher2_puzzle_started or GameState.teacher2_puzzle_completed:
		return
		
	var piece_scene: PackedScene = load("res://scenes/objects/PuzzlePiece.tscn")
	if not piece_scene:
		return
		
	for piece_id in GameState.teacher2_piece_positions.keys():
		var info: Dictionary = GameState.teacher2_piece_positions[piece_id]
		if info.get("map", "") == "university" and not GameState.teacher2_collected_pieces.has(piece_id):
			var existing: Node = get_node_or_null("PuzzlePiece_" + str(piece_id))
			if not existing:
				var inst: Area2D = piece_scene.instantiate()
				inst.name = "PuzzlePiece_" + str(piece_id)
				inst.position = info.get("pos", Vector2.ZERO)
				if inst.has_method("set_piece_id"):
					inst.set_piece_id(piece_id)
				add_child(inst)

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
