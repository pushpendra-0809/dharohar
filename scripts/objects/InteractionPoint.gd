extends Area2D

@export var point_name: String = "Environment Point"
@export var prompt_text: String = "E"
@export var dialogue_lines: Array = []
@export var interaction_radius: float = 40.0

var _player_in_range: bool = false
var dialogue_manager: DialogueManager = null
var narrative_choice_ui: NarrativeChoiceUI = null
var stupa_challenge_ui: Node = null
var library_challenge_ui: Node = null
var vihara_challenge_ui: Node = null

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
		elif (point_name == "Dharmaganja Library" or point_name == "Writing & Study Desk") and GameState.library_unlocked and not GameState.is_library_completed():
			quest_marker.visible = true
		elif point_name == "Great Stupa" and GameState.stupa_unlocked and not GameState.is_stupa_completed():
			quest_marker.visible = true
		elif point_name == "Vihara Living Quarters" and GameState.vihara_unlocked and not GameState.is_vihara_completed():
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

func _get_stupa_challenge_ui() -> Node:
	if stupa_challenge_ui and is_instance_valid(stupa_challenge_ui):
		return stupa_challenge_ui
	var uis = get_tree().get_nodes_in_group("stupa_challenge_ui")
	if uis.size() > 0:

		stupa_challenge_ui = uis[0]
		return stupa_challenge_ui
	var scene_res = load("res://scenes/ui/StupaChallengeUI.tscn")
	if scene_res:
		stupa_challenge_ui = scene_res.instantiate()
		get_tree().root.add_child(stupa_challenge_ui)
		return stupa_challenge_ui
	return null

func _get_library_challenge_ui() -> Node:
	if library_challenge_ui and is_instance_valid(library_challenge_ui):
		return library_challenge_ui
	var uis = get_tree().get_nodes_in_group("library_challenge_ui")
	if uis.size() > 0:
		library_challenge_ui = uis[0]
		return library_challenge_ui
	var scene_res = load("res://scenes/ui/LibraryChallengeUI.tscn")
	if scene_res:
		library_challenge_ui = scene_res.instantiate()
		get_tree().root.add_child(library_challenge_ui)
		return library_challenge_ui
	return null

func _get_vihara_challenge_ui() -> Node:
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
	
	# 1. Great Stupa Concentration Challenge (Gated by stupa_unlocked)
	if point_name == "Great Stupa" and GameState:
		if GameState.is_stupa_completed():
			var stupa_done_seq: Array = [
				{"speaker": "Great Stupa", "text": "The Great Stupa stands in serene concentration and harmony. You have earned the Stupa Scroll of Mastery."}
			]
			dialogue_manager.start_dialogue(stupa_done_seq, _on_dialogue_finished)
			return
		elif GameState.stupa_unlocked:
			var s_ui = _get_stupa_challenge_ui()
			if s_ui:
				s_ui.open_challenge()
				return
		elif GameState.has_met_teacher3:
			var locked_stupa_seq: Array = [
				{"speaker": "Great Stupa", "text": "The path ahead is not yet ready for you.\nHelp the people of Nalanda through their tasks to gain experience before undertaking the Stupa trial."}
			]
			dialogue_manager.start_dialogue(locked_stupa_seq, _on_dialogue_finished)
			return

	
	# 2. Scribe Side Quest Manuscript Delivery
	if (point_name == "Dharmaganja Library" or point_name == "Writing & Study Desk") and GameState:
		if GameState.is_side_quest_active("scribe_manuscript") and not GameState.is_manuscript_delivered():
			var deliver_seq: Array = [
				{"speaker": "Dharmaganja Library", "text": "You have safely delivered the Scribe's palm-leaf manuscript to the study hall."},
				{"speaker": "Dharmaganja Library", "text": "You may now return to the Scribe."}
			]
			dialogue_manager.start_dialogue(deliver_seq, func():
				GameState.deliver_manuscript()
				GameState.unlock_player_movement()
				_update_ui_elements()
			)
			return

	# 3. Dharmaganja Library Investigation (Gated by library_unlocked)
	if (point_name == "Dharmaganja Library" or point_name == "Writing & Study Desk") and GameState:
		if GameState.is_library_completed():
			var lib_done_seq: Array = [
				{"speaker": "Dharmaganja Library", "text": "The Ratnasagara manuscript archives remain preserved and accurately catalogued. You have recovered the Lost Manuscript."}
			]
			dialogue_manager.start_dialogue(lib_done_seq, _on_dialogue_finished)
			return
		elif GameState.library_unlocked:
			var l_ui = _get_library_challenge_ui()
			if l_ui:
				l_ui.open_challenge()
				return
		elif GameState.has_met_teacher3:
			var locked_lib_seq: Array = [
				{"speaker": "Dharmaganja Library", "text": "The inner archives are currently restricted.\nComplete the Stupa chapter and assist more scholars and villagers to earn access."}
			]
			dialogue_manager.start_dialogue(locked_lib_seq, _on_dialogue_finished)
			return


	# 4. Vihara Living Quarters (Gated by vihara_unlocked)
	if point_name == "Vihara Living Quarters" and GameState:
		if GameState.is_vihara_completed():
			var vih_done_seq: Array = [
				{"speaker": "Vihara Living Quarters", "text": "The Vihara residential quarters thrive in warmth and scholarly peace under your balanced coordination."}
			]
			dialogue_manager.start_dialogue(vih_done_seq, _on_dialogue_finished)
			return
		elif GameState.vihara_unlocked:
			var vih_prog_seq: Array = [
				{"speaker": "Vihara Living Quarters", "text": "Evening study preparations are underway in the Vihara residential quarters. Enter the Vihara to assist the scholars."}
			]
			dialogue_manager.start_dialogue(vih_prog_seq, _on_dialogue_finished)
			return
		elif GameState.has_met_teacher3:
			var locked_vih_seq: Array = [
				{"speaker": "Vihara Living Quarters", "text": "The living quarters require further recommendation.\nComplete the Library chapter and assist the Nalanda community to unlock the Vihara trial."}
			]
			dialogue_manager.start_dialogue(locked_vih_seq, _on_dialogue_finished)
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
