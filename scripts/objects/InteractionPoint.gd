extends Area2D

@export var point_name: String = "Environment Point"
@export var prompt_text: String = "[Press E to Inspect]"
@export var dialogue_lines: Array = []
@export var interaction_radius: float = 40.0

var _player_in_range: bool = false
var dialogue_manager: DialogueManager = null

@onready var indicator: Label = $InteractionIndicator
@onready var press_e_label: Label = $PressELabel
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var quest_marker: Label = get_node_or_null("QuestMarker")

var _anim_time: float = 0.0
var _marker_base_y: float = -54.0

func _ready() -> void:
	add_to_group("interaction_points")
	
	if collision_shape and collision_shape.shape is CircleShape2D:
		(collision_shape.shape as CircleShape2D).radius = interaction_radius
		
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)
		
	if GameState:
		if not GameState.quest_state_changed.is_connected(_on_quest_state_changed):
			GameState.quest_state_changed.connect(_on_quest_state_changed)
			
	if quest_marker:
		_marker_base_y = quest_marker.position.y
		
	if press_e_label:
		press_e_label.text = prompt_text
		
	_find_dialogue_manager()
	_update_ui_elements()
	_update_quest_marker()

func _process(delta: float) -> void:
	_anim_time += delta
	if quest_marker and quest_marker.visible:
		quest_marker.position.y = _marker_base_y + sin(_anim_time * 4.0) * 2.5

func _on_quest_state_changed() -> void:
	_update_quest_marker()

func _update_quest_marker() -> void:
	if not quest_marker or not GameState:
		return
		
	if (point_name == "Dharmaganja Library" or point_name == "Writing & Study Desk") and GameState.is_side_quest_active("scribe_manuscript") and not GameState.is_manuscript_delivered():
		quest_marker.visible = true
	else:
		quest_marker.visible = false

func setup_manager(d_mgr: DialogueManager) -> void:
	dialogue_manager = d_mgr

func _find_dialogue_manager() -> void:
	if dialogue_manager:
		return
	var scene = get_tree().current_scene
	if scene and "dialogue_manager" in scene and scene.dialogue_manager:
		dialogue_manager = scene.dialogue_manager
	elif scene:
		for child in scene.get_children():
			if child is DialogueManager:
				dialogue_manager = child
				break

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and _can_interact():
		if event.is_action_pressed("interact"):
			get_viewport().set_input_as_handled()
			_start_interaction()

func _can_interact() -> bool:
	_find_dialogue_manager()
	return dialogue_manager != null and not dialogue_manager.is_active()

func _start_interaction() -> void:
	if not dialogue_manager:
		_find_dialogue_manager()
	if not dialogue_manager:
		return
		
	_update_ui_elements()
	
	# Quest 2 Manuscript Delivery Check for Library / Writing points
	if (point_name == "Dharmaganja Library" or point_name == "Writing & Study Desk") and GameState:
		if GameState.is_side_quest_active("scribe_manuscript") and not GameState.is_manuscript_delivered():
			var deliver_seq: Array = [
				{"speaker": "Dharmaganja Library", "text": "Aapne Scribe ki taadpatra pandulipi yahan adhyayan kaksh mein surakshit pahuncha di hai."},
				{"speaker": "Dharmaganja Library", "text": "Ab Scribe ke paas vapis laut sakte hain."}
			]
			dialogue_manager.start_dialogue(deliver_seq, func():
				GameState.deliver_manuscript()
				GameState.unlock_player_movement()
				_update_ui_elements()
			)
			return
			
	if not dialogue_lines.is_empty():
		dialogue_manager.start_dialogue(dialogue_lines, _on_dialogue_finished)

func _on_dialogue_finished() -> void:
	if GameState:
		GameState.unlock_player_movement()
	_update_ui_elements()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = true
		_update_ui_elements()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = false
		_update_ui_elements()

func _update_ui_elements() -> void:
	var show_prompt: bool = _player_in_range and _can_interact()
	if indicator:
		indicator.visible = show_prompt
	if press_e_label:
		press_e_label.visible = show_prompt
