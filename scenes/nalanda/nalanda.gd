extends Control

@onready var dialogue_ui = $DialogueUI
@onready var domain_ui = $DomainSelectionUI
@onready var quiz_ui = $QuizUI
@onready var pause_menu_ui = $PauseMenuUI
@onready var math_heritage_ui = $MathHeritageUI
@onready var astro_heritage_ui = $AstroHeritageUI
@onready var med_heritage_ui = $MedHeritageUI
@onready var phil_heritage_ui = $PhilHeritageUI
@onready var logic_heritage_ui = $LogicHeritageUI
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
		pause_manager.call("setup", dialogue_manager, quiz_manager, domain_ui, pause_menu_ui)
	
	if teacher and teacher.has_method("setup_managers"):
		teacher.setup_managers(dialogue_manager, quiz_manager, domain_ui, math_heritage_ui, astro_heritage_ui, med_heritage_ui, phil_heritage_ui, logic_heritage_ui)
		
	if merchant and merchant.has_method("setup_managers"):
		merchant.setup_managers(dialogue_manager, quiz_manager)
		
	if player and player.has_method("set_map_limits"):
		player.set_map_limits(0, 0, 1152, 648, 20.0, 1132.0, 30.0, 620.0)
		
	call_deferred("_check_pending_arrival_message")

func _check_pending_arrival_message() -> void:
	if GameState and GameState.pending_arrival_message.size() > 0:
		var msg_seq: Array = GameState.pending_arrival_message.duplicate()
		GameState.pending_arrival_message = []
		if dialogue_manager and dialogue_manager.has_method("start_dialogue"):
			dialogue_manager.start_dialogue(msg_seq, _on_arrival_dialogue_finished)

func _on_arrival_dialogue_finished() -> void:
	if GameState:
		GameState.unlock_player_movement()
