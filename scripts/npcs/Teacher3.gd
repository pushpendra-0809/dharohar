class_name Teacher3
extends StaticBody2D

var _player_in_range: bool = false
var dialogue_manager: DialogueManager = null
var final_mastery_ui: FinalMasteryUI = null
var nalanda_completion_ui: NalandaCompletionUI = null

@onready var interaction_area: Area2D = $InteractionArea
@onready var indicator_label: Label = $IndicatorLabel
@onready var press_e_label: Label = $PressELabel
@onready var quest_marker: Label = get_node_or_null("QuestMarker")

var _anim_time: float = 0.0
var _marker_base_y: float = -68.0

func setup_manager(d_mgr: DialogueManager, f_ui: FinalMasteryUI = null, comp_ui: NalandaCompletionUI = null) -> void:
	dialogue_manager = d_mgr
	if f_ui:
		final_mastery_ui = f_ui
	if comp_ui:
		nalanda_completion_ui = comp_ui
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
		if GameState.has_signal("player_movement_locked") and not GameState.player_movement_locked.is_connected(_on_movement_locked):
			GameState.player_movement_locked.connect(_on_movement_locked)
			
	if quest_marker:
		_marker_base_y = quest_marker.position.y
		
	_find_dialogue_manager()
	_update_ui_elements()
	_update_quest_marker()

func _on_movement_locked(_locked: bool) -> void:
	_update_ui_elements()

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
	if not already_met:
		quest_marker.visible = can_unlock
	elif GameState.nalanda_complete:
		quest_marker.visible = false
	elif GameState.final_mastery_complete:
		quest_marker.visible = true
	elif GameState.has_all_three_scrolls():
		quest_marker.visible = true
	else:
		quest_marker.visible = false

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
		if event.is_action_pressed("interact") or (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E):
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
			{"speaker": "Mastery Mentor", "text": "Complete your foundational study with the Acharya first, then return here to begin your mastery trials."}
		]
		dialogue_manager.start_dialogue(locked_seq, _on_dialogue_finished)
		return
		
	# First Introduction Dialogue — Story Intro with NPC EXP Gating
	if GameState and not GameState.has_met_teacher3:
		var intro_seq: Array = [
			{"speaker": "Mastery Mentor", "text": "You have acquired foundational knowledge."},
			{"speaker": "Mastery Mentor", "text": "You have put it into practice."},
			{"speaker": "Mastery Mentor", "text": "Now Nalanda asks one further virtue of you — discernment and decision."},
			{"speaker": "Mastery Mentor", "text": "Before you may enter the inner heritage sanctums of the Stupa, Library, and Vihara, you must first serve Nalanda's community."},
			{"speaker": "Mastery Mentor", "text": "Assist the village farmers, scribes, students, and scholars across the campus. As your experience grows, each heritage sanctuary will open to you."},
			{"speaker": "Mastery Mentor", "text": "Your choices and discernment will be your true test."}
		]
		dialogue_manager.start_dialogue(intro_seq, func():
			if GameState:
				GameState.mark_teacher3_intro_completed()
			_on_dialogue_finished()
		)
		return

	# Replay / Post-completion state
	if GameState and GameState.nalanda_complete:
		var post_comp_seq: Array = [
			{"speaker": "Mastery Mentor", "text": "You have successfully completed the scholarly journey of Nalanda."},
			{"speaker": "Mastery Mentor", "text": "May the wisdom, discernment, and heritage of this great sanctuary forever guide your path."}
		]
		dialogue_manager.start_dialogue(post_comp_seq, _on_dialogue_finished)
		return

	# Final Story & Completion Sequence
	if GameState and GameState.final_mastery_complete:
		var final_story_seq: Array = [
			{"speaker": "Mastery Mentor", "text": "Magnificent."},
			{"speaker": "Mastery Mentor", "text": "In Nalanda, you did not merely absorb passive words from scrolls."},
			{"speaker": "Mastery Mentor", "text": "You learned, questioned, experimented, and reasoned independently to solve problems."},
			{"speaker": "Mastery Mentor", "text": "Across the Stupa, Library, and Vihara, you made mindful and discerning decisions."},
			{"speaker": "Mastery Mentor", "text": "And in the Final Mastery Trial, you demonstrated the pinnacle of your chosen discipline."},
			{"speaker": "Mastery Mentor", "text": "This is the true spirit of Nalanda's eternal tradition."},
			{"speaker": "Mastery Mentor", "text": "Knowledge here was never for mere recitation — it was to understand, reflect upon, and apply for the welfare of the world."},
			{"speaker": "Mastery Mentor", "text": "You are now a proud bearer of Nalanda's living heritage."},
			{"speaker": "Player", "text": "I understand now that the pursuit of truth never ends with a single answer."}
		]
		dialogue_manager.start_dialogue(final_story_seq, func():
			if GameState:
				GameState.complete_nalanda_experience()
			_on_dialogue_finished()
			_show_nalanda_completion_sequence()
		)
		return

	# State B: Player has all three Scrolls
	if GameState and GameState.has_all_three_scrolls():
		if not GameState.final_mastery_unlocked:
			var completion_seq: Array = [
				{"speaker": "Mastery Mentor", "text": "From three sacred sanctuaries, you have brought forth three Heritage Scrolls."},
				{"speaker": "Mastery Mentor", "text": "Yet the true worth of these scrolls lies not in the parchment itself."},
				{"speaker": "Mastery Mentor", "text": "The decisions you made, the errors you corrected, the questions you asked, and the insights you earned — that was your true trial."},
				{"speaker": "Mastery Mentor", "text": "Now, your Final Mastery Trial commences."}
			]
			dialogue_manager.start_dialogue(completion_seq, func():
				if GameState:
					GameState.unlock_final_mastery()
				_on_dialogue_finished()
				_open_final_mastery_challenge()
			)
			return
		else:
			var post_unlock_seq: Array = [
				{"speaker": "Mastery Mentor", "text": "The hour has arrived for the Final Mastery Trial based upon your chosen discipline."},
				{"speaker": "Mastery Mentor", "text": "Examine the dossier carefully and formulate the most balanced and enlightened plan."}
			]
			dialogue_manager.start_dialogue(post_unlock_seq, func():
				_on_dialogue_finished()
				_open_final_mastery_challenge()
			)
			return

	# State A: Player does NOT have all three Scrolls yet
	var reminder_seq: Array = [
		{"speaker": "Mastery Mentor", "text": "Assist the people of Nalanda and gain experience.\nReturn to me once you have gathered all three Heritage Scrolls of the Stupa, Library, and Vihara."}
	]
	dialogue_manager.start_dialogue(reminder_seq, _on_dialogue_finished)

func _open_final_mastery_challenge() -> void:
	var uis = get_tree().get_nodes_in_group("final_mastery_ui")
	if uis.size() > 0:
		final_mastery_ui = uis[0]
	if not final_mastery_ui or not is_instance_valid(final_mastery_ui):
		var fm_scene = load("res://scenes/ui/FinalMasteryUI.tscn")
		if fm_scene:
			final_mastery_ui = fm_scene.instantiate()
			get_tree().root.add_child(final_mastery_ui)
	if final_mastery_ui and final_mastery_ui.has_method("open_ui"):
		final_mastery_ui.open_ui(_on_final_mastery_completed)

func _on_final_mastery_completed() -> void:
	_start_teacher3_interaction()

func _show_nalanda_completion_sequence() -> void:
	var uis = get_tree().get_nodes_in_group("nalanda_completion_ui")
	if uis.size() > 0:
		nalanda_completion_ui = uis[0]
	if not nalanda_completion_ui or not is_instance_valid(nalanda_completion_ui):
		var comp_scene = load("res://scenes/ui/NalandaCompletionUI.tscn")
		if comp_scene:
			nalanda_completion_ui = comp_scene.instantiate()
			get_tree().root.add_child(nalanda_completion_ui)
	if nalanda_completion_ui and nalanda_completion_ui.has_method("open_completion_sequence"):
		nalanda_completion_ui.open_completion_sequence()

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
	_find_dialogue_manager()
	var in_dialogue: bool = (dialogue_manager != null and dialogue_manager.is_active()) or (GameState != null and GameState.is_movement_locked)
	var show_prompt: bool = _player_in_range and not in_dialogue
	if indicator_label:
		indicator_label.visible = false
	if press_e_label:
		press_e_label.visible = show_prompt
