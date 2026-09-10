class_name Teacher3
extends StaticBody2D

var _player_in_range: bool = false
var dialogue_manager: DialogueManager = null

@onready var interaction_area: Area2D = $InteractionArea
@onready var indicator_label: Label = $IndicatorLabel
@onready var press_e_label: Label = $PressELabel
@onready var quest_marker: Label = get_node_or_null("QuestMarker")

var _anim_time: float = 0.0
var _marker_base_y: float = -68.0

func setup_manager(d_mgr: DialogueManager) -> void:
	dialogue_manager = d_mgr
	if dialogue_manager:
		if not dialogue_manager.dialogue_cancelled.is_connected(_on_interaction_cancelled):
			dialogue_manager.dialogue_cancelled.connect(_on_interaction_cancelled)

func _ready() -> void:
	if interaction_area:
		if not interaction_area.body_entered.is_connected(_on_body_entered):
			interaction_area.body_entered.connect(_on_body_entered)
		if not interaction_area.body_exited.is_connected(_on_body_exited):
			interaction_area.body_exited.connect(_on_body_exited)
			
	if GameState:
		if not GameState.quest_state_changed.is_connected(_on_quest_state_changed):
			GameState.quest_state_changed.connect(_on_quest_state_changed)
			
	if quest_marker:
		_marker_base_y = quest_marker.position.y
		
	_find_dialogue_manager()
	_update_ui_elements()
	_update_quest_marker()

func _process(delta: float) -> void:
	_anim_time += delta
	if quest_marker and quest_marker.visible:
		quest_marker.position.y = _marker_base_y + sin(_anim_time * 4.0) * 3.0

func _on_quest_state_changed() -> void:
	_update_quest_marker()

func _update_quest_marker() -> void:
	if not quest_marker or not GameState:
		return
	var can_unlock: bool = GameState.are_teacher2_tasks_completed()
	var already_met: bool = GameState.has_met_teacher3
	quest_marker.visible = can_unlock and not already_met

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
	if _player_in_range:
		if event.is_action_pressed("interact"):
			get_viewport().set_input_as_handled()
			_start_teacher3_interaction()

func _start_teacher3_interaction() -> void:
	_find_dialogue_manager()
	if not dialogue_manager:
		push_error("Teacher3: DialogueManager not assigned.")
		return
		
	if dialogue_manager.is_active():
		return
		
	if GameState:
		GameState.lock_player_movement()
		
	_update_ui_elements()
	
	# Check unlock condition
	if GameState and not GameState.are_teacher2_tasks_completed():
		var locked_seq: Array = [
			{"speaker": "Mastery Mentor", "text": "Pehle Acharya ke sath apne vishay ka abhyas poora karo, tab yahan aana."}
		]
		dialogue_manager.start_dialogue(locked_seq, _on_dialogue_finished)
		return
		
	# First Introduction Dialogue
	if GameState and not GameState.has_met_teacher3:
		var intro_seq: Array = [
			{"speaker": "Mastery Mentor", "text": "Tumne gyan ko padha, uska abhyas kiya aur Nalanda ke jeevan ko nazdeek se samjha hai."},
			{"speaker": "Mastery Mentor", "text": "Ab samay hai apni seekh ko karya mein badalne ka."},
			{"speaker": "Mastery Mentor", "text": "Nalanda ki teen mahatvapurn jagahon par tumhe alag-alag chunautiyon ka saamna karna hoga."},
			{"speaker": "Mastery Mentor", "text": "Stupa, Library aur Vihara — har jagah tumhari soch aur seekh ko alag tareeke se parakha jayega."},
			{"speaker": "Mastery Mentor", "text": "Har building ki teen kathinaiyan hongi. Sabse kathin star ko poora karne par tumhe ek Scroll milega."},
			{"speaker": "Mastery Mentor", "text": "Teen Scroll lekar mere paas wapas aana. Tab tumhari antim mastery challenge shuru hogi."}
		]
		dialogue_manager.start_dialogue(intro_seq, func():
			if GameState:
				GameState.mark_teacher3_intro_completed()
			_on_dialogue_finished()
		)
	else:
		# Re-interaction Short Reminder
		var reminder_seq: Array = [
			{"speaker": "Mastery Mentor", "text": "Stupa, Library aur Vihara ki chunautiyan poori karo.\nTeen Scroll lekar mere paas wapas aao."}
		]
		dialogue_manager.start_dialogue(reminder_seq, _on_dialogue_finished)

func _on_dialogue_finished() -> void:
	if GameState:
		GameState.unlock_player_movement()
	_update_ui_elements()
	_update_quest_marker()

func _on_interaction_cancelled() -> void:
	if GameState:
		GameState.unlock_player_movement()
	_update_ui_elements()
	_update_quest_marker()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = true
		_update_ui_elements()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = false
		_update_ui_elements()

func _update_ui_elements() -> void:
	var can_act: bool = dialogue_manager != null and not dialogue_manager.is_active()
	var show_prompt: bool = _player_in_range and can_act
	if indicator_label:
		indicator_label.visible = show_prompt
	if press_e_label:
		press_e_label.visible = show_prompt
