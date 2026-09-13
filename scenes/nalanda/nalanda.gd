extends Control

const CutscenePlayer = preload("res://scripts/systems/CutscenePlayer.gd")
const ControlsTutorialPlayer = preload("res://scripts/systems/ControlsTutorialPlayer.gd")

@onready var dialogue_ui = $DialogueUI
@onready var domain_ui = $DomainSelectionUI
@onready var quiz_ui = $QuizUI
@onready var pause_menu_ui = $PauseMenuUI
@onready var math_heritage_ui = $MathHeritageUI
@onready var astro_heritage_ui = $AstroHeritageUI
@onready var med_heritage_ui = $MedHeritageUI
@onready var phil_heritage_ui = $PhilHeritageUI
@onready var logic_heritage_ui = $LogicHeritageUI
var knowledge_book_ui: Node = null
@onready var teacher = $Teacher
@onready var merchant = $Merchant
@onready var player = $Player

var dialogue_manager: Node = null
var quiz_manager: Node = null
var pause_manager: Node = null

func _ready() -> void:
	dialogue_manager = DialogueManager.new()
	quiz_manager = QuizManager.new()
	pause_manager = PauseManager.new()
	
	add_child(dialogue_manager)
	add_child(quiz_manager)
	add_child(pause_manager)
	
	if dialogue_ui and dialogue_ui.has_method("setup"):
		dialogue_ui.setup(dialogue_manager)
	if quiz_ui and quiz_ui.has_method("setup"):
		quiz_ui.setup(quiz_manager)
	if pause_manager and pause_manager.has_method("setup"):
		pause_manager.call("setup", dialogue_manager, quiz_manager, domain_ui, pause_menu_ui, null, null, null, null, knowledge_book_ui)
	
	if teacher and teacher.has_method("setup_managers"):
		teacher.setup_managers(dialogue_manager, quiz_manager, domain_ui, math_heritage_ui, astro_heritage_ui, med_heritage_ui, phil_heritage_ui, logic_heritage_ui, knowledge_book_ui)

		
	if merchant and merchant.has_method("setup_managers"):
		merchant.setup_managers(dialogue_manager, quiz_manager)
		
	for npc in get_tree().get_nodes_in_group("exploration_npcs"):
		if npc.has_method("setup_manager"):
			npc.setup_manager(dialogue_manager)
			
	for point in get_tree().get_nodes_in_group("interaction_points"):
		if point.has_method("setup_manager"):
			point.setup_manager(dialogue_manager)
		
	if player and player.has_method("set_map_limits"):
		player.set_map_limits(0, 0, 1152, 648, 20.0, 1132.0, 30.0, 620.0)
		
	call_deferred("_check_cutscene_or_arrival")

@onready var intro_narration_ui = get_node_or_null("NalandaIntroNarrationUI")

func _check_cutscene_or_arrival() -> void:
	if GameState and not GameState.nalanda_intro_seen:
		_show_intro_narration()
	else:
		_check_pending_arrival_message()

func _show_intro_narration() -> void:
	if intro_narration_ui == null:
		intro_narration_ui = get_node_or_null("NalandaIntroNarrationUI")
	if intro_narration_ui == null:
		var scene_res = load("res://scenes/ui/NalandaIntroNarrationUI.tscn")
		if scene_res:
			intro_narration_ui = scene_res.instantiate()
			add_child(intro_narration_ui)
	
	if intro_narration_ui and intro_narration_ui.has_method("open_narration"):
		if not intro_narration_ui.narration_completed.is_connected(_on_intro_narration_finished):
			intro_narration_ui.narration_completed.connect(_on_intro_narration_finished)
		intro_narration_ui.open_narration()
	else:
		if GameState:
			GameState.nalanda_intro_seen = true
		_check_pending_arrival_message()

func _on_intro_narration_finished() -> void:
	_check_pending_arrival_message()

func _play_intro_cutscene() -> void:
	if GameState:
		GameState.lock_player_movement()
	CutscenePlayer.play_video(self, "res://assets/videos/video1.ogv", _on_cutscene_finished)

func _on_cutscene_finished() -> void:
	if GameState:
		GameState.unlock_player_movement()
	_check_pending_arrival_message()

func _check_pending_arrival_message() -> void:
	if GameState and GameState.pending_arrival_message.size() > 0:
		var msg_seq: Array = GameState.pending_arrival_message.duplicate()
		GameState.pending_arrival_message = []
		if dialogue_manager and dialogue_manager.has_method("start_dialogue"):
			dialogue_manager.start_dialogue(msg_seq, _on_arrival_dialogue_finished)
		else:
			_check_controls_tutorial()
	else:
		_check_controls_tutorial()

func _on_arrival_dialogue_finished() -> void:
	_check_controls_tutorial()

func _check_controls_tutorial() -> void:
	if GameState and not GameState.has_shown_nalanda_controls_tutorial:
		GameState.has_shown_nalanda_controls_tutorial = true
		_show_controls_tutorial()
	else:
		if GameState:
			GameState.unlock_player_movement()

func _show_controls_tutorial() -> void:
	if GameState:
		GameState.lock_player_movement()
	ControlsTutorialPlayer.show_tutorial(self, _on_controls_tutorial_closed)

func _on_controls_tutorial_closed() -> void:
	if GameState:
		GameState.unlock_player_movement()
