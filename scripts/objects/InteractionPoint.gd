extends Area2D

@export var point_name: String = "Environment Point"
@export var prompt_text: String = "E"
@export var dialogue_lines: Array = []
@export var interaction_radius: float = 40.0

var _player_in_range: bool = false
var dialogue_manager: DialogueManager = null
var narrative_choice_ui: NarrativeChoiceUI = null

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
		if GameState.has_signal("player_movement_locked") and not GameState.player_movement_locked.is_connected(_on_movement_locked):
			GameState.player_movement_locked.connect(_on_movement_locked)
			
	if quest_marker:
		_marker_base_y = quest_marker.position.y
		
	if press_e_label:
		press_e_label.text = "E"
		
	_find_dialogue_manager()
	_update_ui_elements()
	_update_quest_marker()

func _on_movement_locked(_locked: bool) -> void:
	_update_ui_elements()

func _process(delta: float) -> void:
	_anim_time += delta
	if quest_marker and quest_marker.visible:
		quest_marker.position.y = _marker_base_y + sin(_anim_time * 4.0) * 2.5

func _on_quest_state_changed() -> void:
	_update_quest_marker()

func _update_quest_marker() -> void:
	if not GameState:
		return
		
	if quest_marker:
		if (point_name == "Dharmaganja Library" or point_name == "Writing & Study Desk") and GameState.is_side_quest_active("scribe_manuscript") and not GameState.is_manuscript_delivered():
			quest_marker.visible = true
		elif (point_name == "Dharmaganja Library" or point_name == "Writing & Study Desk") and GameState.has_met_teacher3 and not GameState.library_scroll_earned:
			quest_marker.visible = true
		elif point_name == "Great Stupa" and GameState.has_met_teacher3 and not GameState.stupa_scroll_earned:
			quest_marker.visible = true
		elif point_name == "Vihara Living Quarters" and GameState.has_met_teacher3 and not GameState.vihara_scroll_earned:
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

func _get_narrative_ui() -> NarrativeChoiceUI:
	if narrative_choice_ui and is_instance_valid(narrative_choice_ui):
		return narrative_choice_ui
	var uis = get_tree().get_nodes_in_group("narrative_choice_ui")
	if uis.size() > 0:
		narrative_choice_ui = uis[0]
		return narrative_choice_ui
	var scene_res = load("res://scenes/ui/NarrativeChoiceUI.tscn")
	if scene_res:
		narrative_choice_ui = scene_res.instantiate()
		get_tree().root.add_child(narrative_choice_ui)
		return narrative_choice_ui
	return null

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and _can_interact():
		if event.is_action_pressed("interact") or (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E):
			get_viewport().set_input_as_handled()
			_start_interaction()

func _can_interact() -> bool:
	_find_dialogue_manager()
	var in_dialogue: bool = (dialogue_manager != null and dialogue_manager.is_active()) or (GameState != null and GameState.is_movement_locked)
	return not in_dialogue

func _start_interaction() -> void:
	if not dialogue_manager:
		_find_dialogue_manager()
	if not dialogue_manager:
		return
		
	_update_ui_elements()
	
	# 1. Great Stupa Narrative Chapter
	if point_name == "Great Stupa" and GameState and GameState.has_met_teacher3:
		if GameState.stupa_scroll_earned:
			var stupa_done_seq: Array = [
				{"speaker": "Great Stupa", "text": "The Great Stupa stands in balanced harmony, protected and revered according to your wise decision."}
			]
			dialogue_manager.start_dialogue(stupa_done_seq, _on_dialogue_finished)
			return
		else:
			var n_ui = _get_narrative_ui()
			if n_ui:
				n_ui.open_chapter("stupa", _on_chapter_completed)
				return
	
	# 2. Scribe Side Quest Manuscript Delivery
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

	# 3. Dharmaganja Library Narrative Chapter
	if (point_name == "Dharmaganja Library" or point_name == "Writing & Study Desk") and GameState and GameState.has_met_teacher3:
		if GameState.library_scroll_earned:
			var lib_done_seq: Array = [
				{"speaker": "Dharmaganja Library", "text": "The Ratnasagara manuscript archives remain preserved and accurately catalogued through evidence and dialogue."}
			]
			dialogue_manager.start_dialogue(lib_done_seq, _on_dialogue_finished)
			return
		else:
			var n_ui = _get_narrative_ui()
			if n_ui:
				n_ui.open_chapter("library", _on_chapter_completed)
				return

	# 4. Vihara Living Quarters Narrative Chapter
	if point_name == "Vihara Living Quarters" and GameState and GameState.has_met_teacher3:
		if GameState.vihara_scroll_earned:
			var vih_done_seq: Array = [
				{"speaker": "Vihara Living Quarters", "text": "The Vihara residential quarters thrive in warmth and scholarly peace under your balanced allocation plan."}
			]
			dialogue_manager.start_dialogue(vih_done_seq, _on_dialogue_finished)
			return
		else:
			var n_ui = _get_narrative_ui()
			if n_ui:
				n_ui.open_chapter("vihara", _on_chapter_completed)
				return
			
	if not dialogue_lines.is_empty():
		dialogue_manager.start_dialogue(dialogue_lines, _on_dialogue_finished)

func _on_chapter_completed() -> void:
	if GameState:
		GameState.unlock_player_movement()
	_update_ui_elements()
	_update_quest_marker()

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
	var in_dialogue: bool = (dialogue_manager != null and dialogue_manager.is_active()) or (GameState != null and GameState.is_movement_locked)
	var show_prompt: bool = _player_in_range and not in_dialogue
	if indicator:
		indicator.visible = false
	if press_e_label:
		press_e_label.visible = show_prompt
