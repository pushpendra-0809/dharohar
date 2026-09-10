extends Control

const CutscenePlayer = preload("res://scripts/systems/CutscenePlayer.gd")

@onready var dialogue_ui = $DialogueUI
@onready var pause_menu_ui = $PauseMenuUI
@onready var math_puzzle_ui = $MathematicsPuzzleUI
@onready var med_puzzle_ui = $MedicinePuzzleUI
@onready var astro_puzzle_ui = $AstronomyPuzzleUI
@onready var phil_puzzle_ui = $PhilosophyPuzzleUI
@onready var university_exit = $UniversityExit
@onready var teacher2 = $Teacher2
@onready var teacher3 = get_node_or_null("Teacher3")
@onready var player = $Player
@onready var scholar_reasoning_ui = get_node_or_null("ScholarReasoningUI")

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
		
	if teacher3 and teacher3.has_method("setup_manager"):
		teacher3.setup_manager(dialogue_manager)
		
	for npc in get_tree().get_nodes_in_group("exploration_npcs"):
		if npc.has_method("setup_manager"):
			npc.setup_manager(dialogue_manager)
		if npc.has_method("setup_scholar_ui") and scholar_reasoning_ui:
			npc.setup_scholar_ui(scholar_reasoning_ui)
			
	for point in get_tree().get_nodes_in_group("interaction_points"):
		if point.has_method("setup_manager"):
			point.setup_manager(dialogue_manager)
		
	if player and player.has_method("set_map_limits"):
		player.set_map_limits(14, 11, 1129, 628, 14.0, 1129.0, 11.0, 628.0)
		
	call_deferred("_check_domain_cutscene_or_arrival")

func _check_domain_cutscene_or_arrival() -> void:
	if GameState:
		var domain: String = GameState.selected_domain.to_lower().strip_edges()
		if ("math" in domain or "gaṇita" in domain) and not GameState.has_played_math_cutscene:
			GameState.has_played_math_cutscene = true
			_play_domain_cutscene("res://assets/videos/video2.ogv")
			return
		elif ("astro" in domain or "jyotiṣa" in domain) and not GameState.has_played_astro_cutscene:
			GameState.has_played_astro_cutscene = true
			_play_domain_cutscene("res://assets/videos/video3.ogv")
			return
	_check_pending_arrival_message()

func _play_domain_cutscene(video_path: String) -> void:
	if GameState:
		GameState.lock_player_movement()
	CutscenePlayer.play_video(self, video_path, _on_domain_cutscene_finished)

func _on_domain_cutscene_finished() -> void:
	if GameState:
		GameState.unlock_player_movement()
	_check_pending_arrival_message()

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
