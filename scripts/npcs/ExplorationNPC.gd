extends StaticBody2D

@export var npc_name: String = "Villager"
@export var sprite_texture: Texture2D
@export var sprite_scale: Vector2 = Vector2(0.03, 0.03)
@export var sprite_flip_h: bool = false
@export var dialogue_lines: Array = []
@export var quest_id: String = ""

var _player_in_range: bool = false
var dialogue_manager: DialogueManager = null
var scholar_reasoning_ui: ScholarReasoningUI = null

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var interaction_area: Area2D = $InteractionArea
@onready var indicator: Label = $InteractionIndicator
@onready var press_e_label: Label = $PressELabel
@onready var quest_marker: Label = get_node_or_null("QuestMarker")

var _anim_time: float = 0.0
var _marker_base_y: float = -54.0

func _ready() -> void:
	add_to_group("exploration_npcs")
	
	if sprite_texture and sprite_2d:
		sprite_2d.texture = sprite_texture
		sprite_2d.scale = sprite_scale
		sprite_2d.flip_h = sprite_flip_h
		
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
	_find_scholar_ui()
	_update_npc_visibility()
	_update_ui_elements()
	_update_quest_marker()

func _on_movement_locked(_locked: bool) -> void:
	_update_ui_elements()

func _process(delta: float) -> void:
	_anim_time += delta
	if quest_marker and quest_marker.visible:
		quest_marker.position.y = _marker_base_y + sin(_anim_time * 4.0) * 2.5

func _on_quest_state_changed() -> void:
	_update_npc_visibility()
	_update_quest_marker()

func _update_npc_visibility() -> void:
	if name == "NPC_YoungStudent" or npc_name == "Student":
		if GameState:
			var teacher2_done: bool = GameState.are_teacher2_tasks_completed() if GameState.has_method("are_teacher2_tasks_completed") else true
			var active: bool = GameState.is_side_quest_active("missing_student")
			var found: bool = GameState.is_missing_student_found()
			var complete: bool = GameState.is_side_quest_complete("missing_student")
			var dev = get_node_or_null("/root/DevModeManager")
			var is_dev: bool = dev != null and dev.dev_mode_enabled
			var should_show: bool = (is_dev or (teacher2_done and active)) and not found and not complete
			visible = should_show
			var col = get_node_or_null("CollisionShape2D")
			if col:
				col.disabled = not should_show
			if interaction_area:
				var a_col = interaction_area.get_node_or_null("CollisionShape2D")
				if a_col:
					a_col.disabled = not should_show
			if not should_show:
				_player_in_range = false

func _update_quest_marker() -> void:
	if not quest_marker or not GameState:
		return
		
	var teacher2_done: bool = GameState.are_teacher2_tasks_completed() if GameState.has_method("are_teacher2_tasks_completed") else true
	
	# Quest 5 Special: Missing Student NPC marker
	if name == "NPC_YoungStudent" or npc_name == "Student":
		if teacher2_done and GameState.is_side_quest_active("missing_student") and not GameState.is_missing_student_found():
			quest_marker.text = "!"
			quest_marker.modulate = Color(0.4, 1.0, 0.4, 1.0)
			quest_marker.visible = true
		else:
			quest_marker.visible = false
		return
		
	if quest_id == "" or not teacher2_done:
		quest_marker.visible = false
		return
		
	var state: int = GameState.get_side_quest_state(quest_id)
	if state == GameState.QuestStatus.NOT_STARTED:
		# Quest available to take!
		quest_marker.text = "!"
		quest_marker.modulate = Color(1.0, 0.88, 0.35, 1.0)
		quest_marker.visible = true
	elif state == GameState.QuestStatus.ACTIVE:
		# Check if ready to turn in
		var ready_to_turn_in: bool = false
		match quest_id:
			"farmer_provisions":
				var q: Dictionary = GameState.side_quests["farmer_provisions"]
				ready_to_turn_in = q.get("progress", 0) >= q.get("target", 3)
			"scribe_manuscript":
				ready_to_turn_in = GameState.is_manuscript_delivered()
			"stupa_caretaker":
				var q: Dictionary = GameState.side_quests["stupa_caretaker"]
				ready_to_turn_in = q.get("progress", 0) >= q.get("target", 3)
			"vihara_supplies":
				var q: Dictionary = GameState.side_quests["vihara_supplies"]
				ready_to_turn_in = q.get("progress", 0) >= q.get("target", 3)
			"missing_student":
				ready_to_turn_in = GameState.is_missing_student_found()
			"scholar_question":
				ready_to_turn_in = GameState.is_scholar_question_solved()
				
		if ready_to_turn_in:
			quest_marker.text = "?"
			quest_marker.modulate = Color(0.4, 1.0, 0.4, 1.0)
			quest_marker.visible = true
		else:
			quest_marker.visible = false
	else:
		# Complete
		quest_marker.visible = false

func setup_manager(d_mgr: DialogueManager) -> void:
	dialogue_manager = d_mgr

func setup_scholar_ui(s_ui: ScholarReasoningUI) -> void:
	scholar_reasoning_ui = s_ui

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

func _find_scholar_ui() -> void:
	if scholar_reasoning_ui:
		return
	var nodes = get_tree().get_nodes_in_group("scholar_reasoning_ui")
	if not nodes.is_empty() and nodes[0] is ScholarReasoningUI:
		scholar_reasoning_ui = nodes[0]

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and _can_interact():
		if event.is_action_pressed("interact"):
			get_viewport().set_input_as_handled()
			_start_interaction()

func _can_interact() -> bool:
	_find_dialogue_manager()
	if GameState != null and GameState.is_movement_locked:
		return false
	return dialogue_manager != null and not dialogue_manager.is_active()

func _start_interaction() -> void:
	if not _can_interact():
		return
	if not dialogue_manager:
		_find_dialogue_manager()
	_find_scholar_ui()
	if not dialogue_manager:
		return
		
	_update_ui_elements()
	
	# Check for Quest 5: Young Student interaction
	if name == "NPC_YoungStudent" or npc_name == "Student":
		if GameState and GameState.is_side_quest_active("missing_student") and not GameState.is_missing_student_found():
			var found_seq: Array = [
				{"speaker": "Student", "text": "I was completely engrossed here listening to discussions of ancient stone inscriptions and scholarly wisdom!"},
				{"speaker": "Student", "text": "I will return immediately to the Senior Student. Thank you for finding me!"}
			]
			dialogue_manager.start_dialogue(found_seq, func():
				if GameState:
					GameState.find_missing_student()
					GameState.unlock_player_movement()
				_update_ui_elements()
			)
			return

	# Handle side quest dialogues if quest_id is configured
	if quest_id != "" and GameState:
		var q_state: int = GameState.get_side_quest_state(quest_id)
		match quest_id:
			"farmer_provisions":
				_handle_farmer_quest(q_state)
				return
			"scribe_manuscript":
				_handle_scribe_quest(q_state)
				return
			"stupa_caretaker":
				_handle_stupa_quest(q_state)
				return
			"vihara_supplies":
				_handle_vihara_quest(q_state)
				return
			"missing_student":
				_handle_senior_student_quest(q_state)
				return
			"scholar_question":
				_handle_scholar_quest(q_state)
				return
				
	# Default flavor dialogue
	if not dialogue_lines.is_empty():
		dialogue_manager.start_dialogue(dialogue_lines, _on_dialogue_finished)

func _handle_farmer_quest(state: int) -> void:
	if state == GameState.QuestStatus.NOT_STARTED:
		var intro_seq: Array = [
			{"speaker": "Village Elder", "text": "Nalanda is connected not only with its revered scholars, but deeply with the people of the surrounding villages."},
			{"speaker": "Village Elder", "text": "The harvest and produce from our fields sustain the thousands of resident scholars studying here."},
			{"speaker": "Village Elder", "text": "Could you assist us by gathering 3 grain and provision bundles from around the village?"}
		]
		dialogue_manager.start_dialogue(intro_seq, func():
			GameState.start_side_quest("farmer_provisions")
			GameState.unlock_player_movement()
			_update_ui_elements()
		)
	elif state == GameState.QuestStatus.ACTIVE:
		var q: Dictionary = GameState.side_quests["farmer_provisions"]
		var prog: int = q.get("progress", 0)
		if prog < 3:
			var active_seq: Array = [
				{"speaker": "Village Elder", "text": "Please locate 3 grain and food provision bundles from around the village. (Collected: " + str(prog) + "/3)"}
			]
			dialogue_manager.start_dialogue(active_seq, _on_dialogue_finished)
		else:
			var complete_seq: Array = [
				{"speaker": "Village Elder", "text": "You have assisted us in good time. Nalanda's daily life was deeply intertwined with the prosperity of its neighboring villages."}
			]
			dialogue_manager.start_dialogue(complete_seq, func():
				GameState.complete_side_quest("farmer_provisions")
				GameState.unlock_player_movement()
				_update_ui_elements()
			)
	else:
		var done_seq: Array = [
			{"speaker": "Village Elder", "text": "You have assisted us in good time. Nalanda's daily life was deeply intertwined with the prosperity of its neighboring villages."}
		]
		dialogue_manager.start_dialogue(done_seq, _on_dialogue_finished)

func _handle_scribe_quest(state: int) -> void:
	if state == GameState.QuestStatus.NOT_STARTED:
		var intro_seq: Array = [
			{"speaker": "Scribe", "text": "Carrying a sacred treatise safely from one hall to another is an essential part of the journey of knowledge."},
			{"speaker": "Scribe", "text": "Preserving every letter inscribed upon these palm leaves is our solemn duty."},
			{"speaker": "Scribe", "text": "Please deliver this vital manuscript bundle to the study chambers of the Dharmaganja Library."}
		]
		dialogue_manager.start_dialogue(intro_seq, func():
			GameState.start_side_quest("scribe_manuscript")
			GameState.unlock_player_movement()
			_update_ui_elements()
		)
	elif state == GameState.QuestStatus.ACTIVE:
		var is_deliv: bool = GameState.is_manuscript_delivered()
		if not is_deliv:
			var active_seq: Array = [
				{"speaker": "Scribe", "text": "Please deliver this palm-leaf manuscript to the scholars in the Dharmaganja Library study hall."}
			]
			dialogue_manager.start_dialogue(active_seq, _on_dialogue_finished)
		else:
			var complete_seq: Array = [
				{"speaker": "Scribe", "text": "A sacred treatise delivered safely to its scholar sustains the great tradition of learning."}
			]
			dialogue_manager.start_dialogue(complete_seq, func():
				GameState.complete_side_quest("scribe_manuscript")
				GameState.unlock_player_movement()
				_update_ui_elements()
			)
	else:
		var done_seq: Array = [
			{"speaker": "Scribe", "text": "A sacred treatise delivered safely to its scholar sustains the great tradition of learning."}
		]
		dialogue_manager.start_dialogue(done_seq, _on_dialogue_finished)

func _handle_stupa_quest(state: int) -> void:
	if state == GameState.QuestStatus.NOT_STARTED:
		var intro_seq: Array = [
			{"speaker": "Stupa Caretaker", "text": "This Great Stupa is not merely a monument of brick and stone; it is the spiritual heart of devotion and mindfulness in Nalanda."},
			{"speaker": "Stupa Caretaker", "text": "For our daily offerings and care, I require 3 sacred items: an Oil Lamp (Deepa), Sacred Cloth (Vastra), and Fresh Flowers (Pushpa)."},
			{"speaker": "Stupa Caretaker", "text": "Could you gather these 3 offering items from around the Stupa grounds?"}
		]
		dialogue_manager.start_dialogue(intro_seq, func():
			GameState.start_side_quest("stupa_caretaker")
			GameState.unlock_player_movement()
			_update_ui_elements()
		)
	elif state == GameState.QuestStatus.ACTIVE:
		var q: Dictionary = GameState.side_quests["stupa_caretaker"]
		var prog: int = q.get("progress", 0)
		if prog < 3:
			var active_seq: Array = [
				{"speaker": "Stupa Caretaker", "text": "Please locate the oil lamp, sacred cloth, and fresh flowers around the Stupa. (Collected: " + str(prog) + "/3)"}
			]
			dialogue_manager.start_dialogue(active_seq, _on_dialogue_finished)
		else:
			var complete_seq: Array = [
				{"speaker": "Stupa Caretaker", "text": "Thank you. Such acts of mindfulness and service keep the sacred heritage of these monuments alive."}
			]
			dialogue_manager.start_dialogue(complete_seq, func():
				GameState.complete_side_quest("stupa_caretaker")
				GameState.unlock_player_movement()
				_update_ui_elements()
			)
	else:
		var done_seq: Array = [
			{"speaker": "Stupa Caretaker", "text": "Thank you. Such acts of mindfulness and service keep the sacred heritage of these monuments alive."}
		]
		dialogue_manager.start_dialogue(done_seq, _on_dialogue_finished)

func _handle_vihara_quest(state: int) -> void:
	if state == GameState.QuestStatus.NOT_STARTED:
		var intro_seq: Array = [
			{"speaker": "Vihara Worker", "text": "Maintaining the living quarters for thousands of resident monks and students requires continuous dedication."},
			{"speaker": "Vihara Worker", "text": "For repairing the student cells, I require 3 essential supplies: Timber Wood, Building Stone, and Strong Rope."},
			{"speaker": "Vihara Worker", "text": "Could you gather these 3 materials from around the Vihara grounds?"}
		]
		dialogue_manager.start_dialogue(intro_seq, func():
			GameState.start_side_quest("vihara_supplies")
			GameState.unlock_player_movement()
			_update_ui_elements()
		)
	elif state == GameState.QuestStatus.ACTIVE:
		var q: Dictionary = GameState.side_quests["vihara_supplies"]
		var prog: int = q.get("progress", 0)
		if prog < 3:
			var active_seq: Array = [
				{"speaker": "Vihara Worker", "text": "Please bring wood, stone, and rope from around the Vihara area. (Collected: " + str(prog) + "/3)"}
			]
			dialogue_manager.start_dialogue(active_seq, _on_dialogue_finished)
		else:
			var complete_seq: Array = [
				{"speaker": "Vihara Worker", "text": "Caring for the monastic living quarters is an essential pillar of life here at Nalanda."}
			]
			dialogue_manager.start_dialogue(complete_seq, func():
				GameState.complete_side_quest("vihara_supplies")
				GameState.unlock_player_movement()
				_update_ui_elements()
			)
	else:
		var done_seq: Array = [
			{"speaker": "Vihara Worker", "text": "Caring for the monastic living quarters is an essential pillar of life here at Nalanda."}
		]
		dialogue_manager.start_dialogue(done_seq, _on_dialogue_finished)

func _handle_senior_student_quest(state: int) -> void:
	if state == GameState.QuestStatus.NOT_STARTED:
		var intro_seq: Array = [
			{"speaker": "Senior Student", "text": "Every day at Nalanda brings encounters with brilliant thinkers and new ideas."},
			{"speaker": "Senior Student", "text": "However, a young junior scholar has wandered away from our courtyard group."},
			{"speaker": "Senior Student", "text": "Could you search the campus grounds and speak with him?"}
		]
		dialogue_manager.start_dialogue(intro_seq, func():
			GameState.start_side_quest("missing_student")
			GameState.unlock_player_movement()
			_update_ui_elements()
		)
	elif state == GameState.QuestStatus.ACTIVE:
		var is_found: bool = GameState.is_missing_student_found()
		if not is_found:
			var active_seq: Array = [
				{"speaker": "Senior Student", "text": "Please look for the young student; he should be somewhere nearby exploring the campus grounds."}
			]
			dialogue_manager.start_dialogue(active_seq, _on_dialogue_finished)
		else:
			var complete_seq: Array = [
				{"speaker": "Senior Student", "text": "I am glad you found him safely. In Nalanda, looking after fellow scholars is just as important as scholarly learning."}
			]
			dialogue_manager.start_dialogue(complete_seq, func():
				GameState.complete_side_quest("missing_student")
				GameState.unlock_player_movement()
				_update_ui_elements()
			)
	else:
		var done_seq: Array = [
			{"speaker": "Senior Student", "text": "I am glad you found him safely. In Nalanda, looking after fellow scholars is just as important as scholarly learning."}
		]
		dialogue_manager.start_dialogue(done_seq, _on_dialogue_finished)

func _handle_scholar_quest(state: int) -> void:
	if state == GameState.QuestStatus.NOT_STARTED:
		var intro_seq: Array = [
			{"speaker": "Scholar", "text": "A true scholar does not merely memorize facts; they understand the deeper connections between ideas."},
			{"speaker": "Scholar", "text": "I am cataloguing manuscripts across the Dharmaganja library according to their epistemological subjects."},
			{"speaker": "Scholar", "text": "Assist me by answering this philosophical question."}
		]
		dialogue_manager.start_dialogue(intro_seq, func():
			GameState.start_side_quest("scholar_question")
			_open_scholar_challenge()
		)
	elif state == GameState.QuestStatus.ACTIVE:
		var is_solved: bool = GameState.is_scholar_question_solved()
		if not is_solved:
			_open_scholar_challenge()
		else:
			var complete_seq: Array = [
				{"speaker": "Scholar", "text": "You have reasoned with great clarity. A disciplined thinker perceives harmony and principles across knowledge."}
			]
			dialogue_manager.start_dialogue(complete_seq, func():
				GameState.complete_side_quest("scholar_question")
				GameState.unlock_player_movement()
				_update_ui_elements()
			)
	else:
		var done_seq: Array = [
			{"speaker": "Scholar", "text": "You have reasoned with great clarity. A disciplined thinker perceives harmony and principles across knowledge."}
		]
		dialogue_manager.start_dialogue(done_seq, _on_dialogue_finished)

func _open_scholar_challenge() -> void:
	_find_scholar_ui()
	if scholar_reasoning_ui:
		scholar_reasoning_ui.show_challenge(func():
			var complete_seq: Array = [
				{"speaker": "Scholar", "text": "You have reasoned with great clarity. A disciplined thinker perceives harmony and principles across knowledge."}
			]
			dialogue_manager.start_dialogue(complete_seq, func():
				GameState.complete_side_quest("scholar_question")
				GameState.unlock_player_movement()
				_update_ui_elements()
			)
		)
	else:
		# Fallback if UI not yet mapped
		GameState.solve_scholar_question()
		var complete_seq: Array = [
			{"speaker": "Scholar", "text": "You have reasoned with great clarity. A disciplined thinker perceives harmony and principles across knowledge."}
		]
		dialogue_manager.start_dialogue(complete_seq, func():
			GameState.complete_side_quest("scholar_question")
			GameState.unlock_player_movement()
			_update_ui_elements()
		)

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
	var show_prompt: bool = _player_in_range and _can_interact() and not in_dialogue
	if indicator:
		indicator.visible = false
	if press_e_label:
		press_e_label.visible = show_prompt
