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
		return

	# Step 19: Replay / Post-completion state
	if GameState and GameState.nalanda_complete:
		var post_comp_seq: Array = [
			{"speaker": "Mastery Mentor", "text": "Nalanda ki gyan-yatra tumne safaltapoorvak poori kar li hai."},
			{"speaker": "Mastery Mentor", "text": "Yahan ka gyan aur dharohar sada tumhare sath rahegi."}
		]
		dialogue_manager.start_dialogue(post_comp_seq, _on_dialogue_finished)
		return

	# Step 19: Final Story & Completion Sequence
	if GameState and GameState.final_mastery_complete:
		var final_story_seq: Array = [
			{"speaker": "Mastery Mentor", "text": "Bahut achha."},
			{"speaker": "Mastery Mentor", "text": "Tumne Nalanda mein keval pustakon se gyan nahi paaya."},
			{"speaker": "Mastery Mentor", "text": "Tumne seekha, prashn kiya, prayog kiya aur apni soch se samasyaon ka samadhan kiya."},
			{"speaker": "Mastery Mentor", "text": "Stupa, Library aur Vihara ki teenon chunautiyon ne tumhari seekh ko alag-alag roop mein parakha."},
			{"speaker": "Mastery Mentor", "text": "Phir antim mastery mein tumne in sabhi gyan ko ek saath joda."},
			{"speaker": "Mastery Mentor", "text": "Yahi Nalanda ki asli parampara hai."},
			{"speaker": "Mastery Mentor", "text": "Yahan gyan sirf yaad karne ke liye nahi tha."},
			{"speaker": "Mastery Mentor", "text": "Use samajhne, us par vichar karne aur duniya mein prayog karne ke liye tha."},
			{"speaker": "Mastery Mentor", "text": "Ab tum bhi Nalanda ki is gyan-yatra ka ek hissa ban chuke ho."},
			{"speaker": "Player", "text": "Main samajh gaya hoon ki gyan ki yatra kabhi sirf ek uttar par khatam nahi hoti."}
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
				{"speaker": "Mastery Mentor", "text": "Ah, tum teenon Scrolls lekar laut aaye ho."},
				{"speaker": "Mastery Mentor", "text": "Stupa, Library aur Vihara — teenon ne tumhari seekh ko alag-alag tareekon se parakha."},
				{"speaker": "Mastery Mentor", "text": "Ab tumne jo seekha hai, usse ek saath prayog karne ka samay aa gaya hai."},
				{"speaker": "Mastery Mentor", "text": "Ab tumhari antim mastery challenge tumhara intezaar kar rahi hai."}
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
				{"speaker": "Mastery Mentor", "text": "Ab samay hai antim chunauti ka. Yeh pariksha tumhare saare gyan ko ek saath jodegi."},
				{"speaker": "Mastery Mentor", "text": "Ganit, Khagol, Chikitsa aur Darshan — charo vishayon ka samavesh karke hi tum Antim Mastery prapt kar sakte ho."}
			]
			dialogue_manager.start_dialogue(post_unlock_seq, func():
				_on_dialogue_finished()
				_open_final_mastery_challenge()
			)
			return

	# State A: Player does NOT have all three Scrolls yet
	var reminder_seq: Array = [
		{"speaker": "Mastery Mentor", "text": "Tumne Stupa, Library aur Vihara ki chunautiyon ka saamna kiya hai.\nApni teenon Scrolls lekar mere paas wapas aao."}
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
		final_mastery_ui.open_ui()

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
	var can_act: bool = dialogue_manager == null or not dialogue_manager.is_active()
	var show_prompt: bool = _player_in_range and can_act
	if indicator_label:
		indicator_label.visible = show_prompt
	if press_e_label:
		press_e_label.visible = show_prompt
