class_name ViharaTaskInteractable
extends Area2D

@export var interactable_id: String = "warden"
@export var station_title: String = ""
@export var station_icon: String = "✦"
@export var associated_prop_path: NodePath = NodePath("")

var _player_in_range: bool = false
var dialogue_manager: Node = null
var vihara_manager: Node = null

@onready var press_e_label: Label = get_node_or_null("PressELabel")

func _ready() -> void:
	add_to_group("vihara_interactables")
	
	# Connect collision signals
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)
		
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
	if not area_exited.is_connected(_on_area_exited):
		area_exited.connect(_on_area_exited)
		
	if press_e_label:
		press_e_label.text = "E"
		press_e_label.visible = false
		
	_find_managers()
	_update_prop_visibility()

func _process(_delta: float) -> void:
	# Continuous distance fallback so player can always interact when nearby
	var player_node: Node2D = _get_player()
	if player_node:
		var dist = global_position.distance_to(player_node.global_position)
		var in_dist = (dist <= 65.0)
		if in_dist != _player_in_range:
			_player_in_range = in_dist
			_update_ui_elements()

func _get_player() -> Node2D:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0 and is_instance_valid(players[0]):
		return players[0] as Node2D
	var scene = get_tree().current_scene
	if scene and scene.has_node("Player"):
		return scene.get_node("Player") as Node2D
	return null

func setup(d_mgr: Node, v_mgr: Node = null) -> void:
	dialogue_manager = d_mgr
	vihara_manager = v_mgr
	_update_prop_visibility()

func _find_managers() -> void:
	if not dialogue_manager:
		var scene = get_tree().current_scene
		if scene and "dialogue_manager" in scene and scene.dialogue_manager:
			dialogue_manager = scene.dialogue_manager
		else:
			var dlg_nodes = get_tree().get_nodes_in_group("dialogue_ui")
			if dlg_nodes.size() > 0:
				dialogue_manager = dlg_nodes[0]
				
	if not vihara_manager:
		var v_nodes = get_tree().get_nodes_in_group("vihara_manager")
		if v_nodes.size() > 0:
			vihara_manager = v_nodes[0]
		elif get_tree().current_scene and "vihara_manager" in get_tree().current_scene:
			vihara_manager = get_tree().current_scene.vihara_manager

func _update_prop_visibility() -> void:
	if not associated_prop_path.is_empty() and has_node(associated_prop_path):
		var prop = get_node(associated_prop_path)
		if prop:
			match interactable_id:
				"study_room_lamp":
					var is_done = (vihara_manager != null and vihara_manager.task_lamp_complete) or (GameState and GameState.is_vihara_completed())
					prop.visible = is_done
				"astronomy_student":
					var is_done = (vihara_manager != null and vihara_manager.task_manuscript_complete) or (GameState and GameState.is_vihara_completed())
					prop.visible = is_done
				"courtyard_water":
					var is_done = (vihara_manager != null and vihara_manager.task_water_complete) or (GameState and GameState.is_vihara_completed())
					prop.visible = is_done
				"junior_student_desk":
					var is_done = (vihara_manager != null and vihara_manager.task_study_space_complete) or (GameState and GameState.is_vihara_completed())
					prop.visible = is_done

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and _can_interact():
		if event.is_action_pressed("interact") or (event is InputEventKey and event.pressed and not event.echo and (event.keycode == KEY_E or event.keycode == KEY_SPACE or event.keycode == KEY_ENTER)):
			get_viewport().set_input_as_handled()
			_execute_interaction()

func _input(event: InputEvent) -> void:
	if _player_in_range and _can_interact():
		if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E:
			get_viewport().set_input_as_handled()
			_execute_interaction()

func _can_interact() -> bool:
	_find_managers()
	var in_dialogue: bool = (dialogue_manager != null and dialogue_manager.has_method("is_active") and dialogue_manager.is_active()) or (GameState != null and GameState.is_movement_locked)
	return not in_dialogue

func _execute_interaction() -> void:
	_find_managers()
	if not dialogue_manager:
		return
		
	match interactable_id:
		"warden":
			_handle_warden_interaction()
		"lamp_station":
			_handle_lamp_station_interaction()
		"study_room_lamp":
			_handle_study_room_lamp_interaction()
		"scribe_station":
			_handle_scribe_station_interaction()
		"astronomy_student":
			_handle_astronomy_student_interaction()
		"water_station":
			_handle_water_station_interaction()
		"courtyard_water":
			_handle_courtyard_water_interaction()
		"writing_kit_station":
			_handle_writing_kit_station_interaction()
		"junior_student_desk":
			_handle_junior_student_desk_interaction()
		"evening_bell":
			_handle_evening_bell_interaction()
		"ambient_monk":
			var monk_seq = [
				{"speaker": "Bhikshu Sangharakshita", "text": "“Buddham Sharanam Gacchami... Peace, discipline, and mutual cooperation form the foundation of the Vihara.”"},
				{"speaker": "Bhikshu Sangharakshita", "text": "“When all scholars support one another, the living atmosphere becomes filled with wisdom and calm.”"}
			]
			dialogue_manager.start_dialogue(monk_seq, _on_dialogue_finished)
		"ambient_scholar":
			var sch_seq = [
				{"speaker": "Senior Scholar Vasumitra", "text": "“I am preparing for the evening philosophical assembly (Shastrartha).”"},
				{"speaker": "Senior Scholar Vasumitra", "text": "“When the Evening Bell tolls, we shall gather in the courtyard for meditation and reflection.”"}
			]
			dialogue_manager.start_dialogue(sch_seq, _on_dialogue_finished)
		"ambient_student":
			var stu_seq = [
				{"speaker": "Student Priyadarshi", "text": "“Nalanda's Vihara is not merely a residence; it is our scholarly family.”"},
				{"speaker": "Student Priyadarshi", "text": "“Studying under the warm glow of oil lamps in the evening is truly inspiring.”"}
			]
			dialogue_manager.start_dialogue(stu_seq, _on_dialogue_finished)

# --- 1. WARDEN ---
func _handle_warden_interaction() -> void:
	if GameState and GameState.is_vihara_completed():
		var done_seq = [
			{"speaker": "Vihara Warden", "text": "“Evening preparations across the Vihara are complete. All scholars are immersed in meditation and study.”"},
			{"speaker": "Vihara Warden", "text": "“Your cooperation is commendable. Peace and harmony prevail throughout our residential halls.”"}
		]
		dialogue_manager.start_dialogue(done_seq, _on_dialogue_finished)
		return
		
	if vihara_manager and vihara_manager.are_all_prep_tasks_complete():
		var ready_seq = [
			{"speaker": "Vihara Warden", "text": "“Splendid work! The lamps are lit, manuscripts and water vessels are safely placed, and study desks are prepared.”"},
			{"speaker": "Vihara Warden", "text": "“Now, toll the sacred Evening Bell near the shrine to signal the start of evening studies!”"}
		]
		dialogue_manager.start_dialogue(ready_seq, _on_dialogue_finished)
	else:
		var intro_seq = [
			{"speaker": "Vihara Warden", "text": "“Evening twilight approaches. The scholars' evening studies are about to begin.”"},
			{"speaker": "Vihara Warden", "text": "“There are 4 main preparation stations:
• 🪔 Lamps: Collect oil lamps from the Top-Left Depot and light the East Study Desk.
• 📜 Manuscript: Take the treatise from the Left Scribe to the Top-Right Astronomy Scholar.
• 🏺 Water: Fetch water vessels from the Bottom-Left Helper and place them on the Courtyard Stand.
• ✍️ Supplies: Pick up writing materials from the West Shelf and deliver them to the Junior Desk.”"},
			{"speaker": "Vihara Warden", "text": "“Once all four tasks are fulfilled, toll the sacred Evening Bell at the Top Shrine!”"}
		]
		dialogue_manager.start_dialogue(intro_seq, _on_dialogue_finished)

# --- 2. TASK 1: STUDY LAMPS ---
func _handle_lamp_station_interaction() -> void:
	if vihara_manager and vihara_manager.task_lamp_complete:
		var seq = [{"speaker": "Lamp Depot", "text": "“The brass oil lamps have already been placed and lit in the student study room.”"}]
		dialogue_manager.start_dialogue(seq, _on_dialogue_finished)
		return
		
	if vihara_manager and vihara_manager.has_held_item("lamp"):
		var seq = [{"speaker": "Lamp Depot", "text": "“You are currently holding an oil lamp. Place and light it on the East Study Desk.”"}]
		dialogue_manager.start_dialogue(seq, _on_dialogue_finished)
		return
		
	var seq = [
		{"speaker": "Lamp Depot", "text": "“This brass oil lamp (Deepak) is filled and prepared.”"},
		{"speaker": "Lamp Depot", "text": "“You have picked up the lamp. Place and light it on the study desk in the eastern room.”"}
	]
	dialogue_manager.start_dialogue(seq, func():
		if vihara_manager:
			vihara_manager.pickup_item("lamp", "🪔 Oil Lamp (Deepak)")
		_on_dialogue_finished()
	)

func _handle_study_room_lamp_interaction() -> void:
	if vihara_manager and vihara_manager.task_lamp_complete:
		var seq = [
			{"speaker": "Student Jinamitra", "text": "“The lamp casts a warm, peaceful light. Now I can read my lessons in comfort. Thank you!”"}
		]
		dialogue_manager.start_dialogue(seq, _on_dialogue_finished)
		return
		
	if vihara_manager and vihara_manager.has_held_item("lamp"):
		var seq = [
			{"speaker": "Student Jinamitra", "text": "“My room had no light for reading... ah, you have brought a lamp!”"},
			{"speaker": "Player", "text": "[You placed the brass oil lamp upon the study desk and lit its flame]"},
			{"speaker": "Student Jinamitra", "text": "“Thank you! Now our evening studies will be brightly illuminated.”"}
		]
		dialogue_manager.start_dialogue(seq, func():
			if vihara_manager:
				vihara_manager.clear_held_item()
				vihara_manager.complete_task("lamp")
			_update_prop_visibility()
			_on_dialogue_finished()
		)
	else:
		var seq = [
			{"speaker": "Student Jinamitra", "text": "“My room lacks an oil lamp for reading. Twilight is falling; could you bring a lamp from the depot?”"}
		]
		dialogue_manager.start_dialogue(seq, _on_dialogue_finished)

# --- 3. TASK 2: MANUSCRIPT DELIVERY ---
func _handle_scribe_station_interaction() -> void:
	if vihara_manager and vihara_manager.task_manuscript_complete:
		var seq = [{"speaker": "Scribe Bodhiruchi", "text": "“The Astronomy Nakshatra treatise has been safely delivered to the scholar. Thank you!”"}]
		dialogue_manager.start_dialogue(seq, _on_dialogue_finished)
		return
		
	if vihara_manager and vihara_manager.has_held_item("manuscript"):
		var seq = [{"speaker": "Scribe Bodhiruchi", "text": "“You are holding the palm-leaf Astronomy treatise. Deliver it to the Astronomy Scholar in the north room.”"}]
		dialogue_manager.start_dialogue(seq, _on_dialogue_finished)
		return
		
	var seq = [
		{"speaker": "Scribe Bodhiruchi", "text": "“This palm-leaf manuscript needs to reach the scholar awaiting it.”"},
		{"speaker": "Scribe Bodhiruchi", "text": "“This text contains the transit logs of the 27 Nakshatras and planetary positions for tonight's sky observation.”"},
		{"speaker": "Player", "text": "[You carefully took the Astronomy Manuscript Bundle]"}
	]
	dialogue_manager.start_dialogue(seq, func():
		if vihara_manager:
			vihara_manager.pickup_item("manuscript", "📜 Astronomy Manuscript (Tāraka Pañcikā)")
		_on_dialogue_finished()
	)

func _handle_astronomy_student_interaction() -> void:
	if vihara_manager and vihara_manager.task_manuscript_complete:
		var seq = [
			{"speaker": "Astronomy Scholar Varaha", "text": "“My Nakshatra transit log is here. Tonight from the rooftop observatory, I shall record planetary movements.”"}
		]
		dialogue_manager.start_dialogue(seq, _on_dialogue_finished)
		return
		
	if vihara_manager and vihara_manager.has_held_item("manuscript"):
		var seq = [
			{"speaker": "Astronomy Scholar Varaha", "text": "“I was hoping to review my astronomical notes before nightfall... ah, this is the very palm-leaf text!”"},
			{"speaker": "Astronomy Scholar Varaha", "text": "“This is exactly what I needed. You have assisted me greatly!”"}
		]
		dialogue_manager.start_dialogue(seq, func():
			if vihara_manager:
				vihara_manager.clear_held_item()
				vihara_manager.complete_task("manuscript")
			_update_prop_visibility()
			_on_dialogue_finished()
		)
	else:
		var seq = [
			{"speaker": "Astronomy Scholar Varaha", "text": "“I need to review my stellar transit notes for tonight. The Scribe has my palm-leaf treatise ready.”"}
		]
		dialogue_manager.start_dialogue(seq, _on_dialogue_finished)

# --- 4. TASK 3: WATER VESSELS ---
func _handle_water_station_interaction() -> void:
	if vihara_manager and vihara_manager.task_water_complete:
		var seq = [{"speaker": "Vihara Helper Devadasa", "text": "“Fresh cool drinking water vessels have been securely placed on the courtyard stand.”"}]
		dialogue_manager.start_dialogue(seq, _on_dialogue_finished)
		return
		
	if vihara_manager and vihara_manager.has_held_item("water_vessel"):
		var seq = [{"speaker": "Vihara Helper Devadasa", "text": "“You are carrying the earthen water vessels. Place them onto the central courtyard stand.”"}]
		dialogue_manager.start_dialogue(seq, _on_dialogue_finished)
		return
		
	var seq = [
		{"speaker": "Vihara Helper Devadasa", "text": "“Two earthen water vessels need to be placed in the courtyard so scholars have fresh drinking water during study.”"},
		{"speaker": "Player", "text": "[You lifted both earthen water vessels carefully]"}
	]
	dialogue_manager.start_dialogue(seq, func():
		if vihara_manager:
			vihara_manager.pickup_item("water_vessel", "🏺 Water Vessels (Mṛttikā Pātra)")
		_on_dialogue_finished()
	)

func _handle_courtyard_water_interaction() -> void:
	if vihara_manager and vihara_manager.task_water_complete:
		var seq = [{"speaker": "Courtyard Water Stand", "text": "“Fresh drinking water vessels are arranged neatly on the stand.”"}]
		dialogue_manager.start_dialogue(seq, _on_dialogue_finished)
		return
		
	if vihara_manager and vihara_manager.has_held_item("water_vessel"):
		var seq = [
			{"speaker": "Player", "text": "[You arranged both water vessels securely onto the courtyard stand]"},
			{"speaker": "Vihara Helper Devadasa", "text": "“Wonderful! The scholars will have fresh drinking water throughout their evening studies.”"}
		]
		dialogue_manager.start_dialogue(seq, func():
			if vihara_manager:
				vihara_manager.clear_held_item()
				vihara_manager.complete_task("water")
			_update_prop_visibility()
			_on_dialogue_finished()
		)
	else:
		var seq = [{"speaker": "Courtyard Water Stand", "text": "“This is the central courtyard water station. Drinking vessels must be placed here before evening studies begin.”"}]
		dialogue_manager.start_dialogue(seq, _on_dialogue_finished)

# --- 5. TASK 4: STUDY SPACE ---
func _handle_writing_kit_station_interaction() -> void:
	if vihara_manager and vihara_manager.task_study_space_complete:
		var seq = [{"speaker": "Supply Shelf", "text": "“Writing materials have been delivered to the junior student's desk.”"}]
		dialogue_manager.start_dialogue(seq, _on_dialogue_finished)
		return
		
	if vihara_manager and vihara_manager.has_held_item("writing_kit"):
		var seq = [{"speaker": "Supply Shelf", "text": "“You are carrying the writing kit (Wooden Board, Ink Pot, Reed Pen). Place it on the junior student's desk.”"}]
		dialogue_manager.start_dialogue(seq, _on_dialogue_finished)
		return
		
	var seq = [
		{"speaker": "Supply Shelf", "text": "“Here are the classical writing materials — Wooden Board (Kāṣṭha Paṭṭikā), Ink Pot (Masī Pātra), and Reed Pen (Lekhanī).”"},
		{"speaker": "Player", "text": "[You collected the writing kit to deliver to the junior student]"}
	]
	dialogue_manager.start_dialogue(seq, func():
		if vihara_manager:
			vihara_manager.pickup_item("writing_kit", "✍️ Writing Kit (Board, Ink, Pen)")
		_on_dialogue_finished()
	)

func _handle_junior_student_desk_interaction() -> void:
	if vihara_manager and vihara_manager.task_study_space_complete:
		var seq = [
			{"speaker": "Junior Student Soma", "text": "“My study desk is completely prepared! Now I can begin practicing manuscript translation. Thank you!”"}
		]
		dialogue_manager.start_dialogue(seq, _on_dialogue_finished)
		return
		
	if vihara_manager and vihara_manager.has_held_item("writing_kit"):
		var seq = [
			{"speaker": "Junior Student Soma", "text": "“I had no writing materials at my desk... ah, you have brought everything!”"},
			{"speaker": "Player", "text": "[You arranged the writing board, ink pot, and reed pen upon the desk]"},
			{"speaker": "Junior Student Soma", "text": "“Now I can begin my studies in earnest. My deepest gratitude!”"}
		]
		dialogue_manager.start_dialogue(seq, func():
			if vihara_manager:
				vihara_manager.clear_held_item()
				vihara_manager.complete_task("study_space")
			_update_prop_visibility()
			_on_dialogue_finished()
		)
	else:
		var seq = [
			{"speaker": "Junior Student Soma", "text": "“My desk lacks writing materials. I need a writing board, ink pot, and reed pen before class begins.”"}
		]
		dialogue_manager.start_dialogue(seq, _on_dialogue_finished)

# --- 6. TASK 5: EVENING BELL ---
func _handle_evening_bell_interaction() -> void:
	if GameState and GameState.is_vihara_completed():
		var done_seq = [
			{"speaker": "Evening Bell", "text": "“The Evening Bell has tolled. Peace, harmony, and contemplative wisdom resonate through the Vihara.”"}
		]
		dialogue_manager.start_dialogue(done_seq, _on_dialogue_finished)
		return
		
	if vihara_manager and vihara_manager.are_all_prep_tasks_complete():
		var ring_seq = [
			{"speaker": "Player", "text": "[You struck the sacred Evening Bell with reverent focus — 🔔 DIIING... DIIING...]"},
			{"speaker": "Vihara Warden", "text": "“The Evening Bell tolls! All study chambers across the Vihara are illuminated and prepared.”"},
			{"speaker": "Vihara Warden", "text": "“All scholars now settle in for evening meditation, reading, and discourse.”"}
		]
		dialogue_manager.start_dialogue(ring_seq, func():
			_on_dialogue_finished()
			if vihara_manager:
				vihara_manager.complete_task("bell")
		)
	else:
		var not_ready_seq = [
			{"speaker": "Evening Bell", "text": "“The Vihara is not yet fully prepared.”"},
			{"speaker": "Vihara Warden", "text": "“First light the lamps, deliver the manuscript, place the water vessels, and set up the study desk. Then toll the bell!”"}
		]
		dialogue_manager.start_dialogue(not_ready_seq, _on_dialogue_finished)

func _on_dialogue_finished() -> void:
	if GameState:
		GameState.unlock_player_movement()
	_update_ui_elements()
	_update_prop_visibility()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D or body.is_in_group("player"):
		_player_in_range = true
		_update_ui_elements()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D or body.is_in_group("player"):
		_player_in_range = false
		_update_ui_elements()

func _on_area_entered(_area: Area2D) -> void:
	_player_in_range = true
	_update_ui_elements()

func _on_area_exited(_area: Area2D) -> void:
	_player_in_range = false
	_update_ui_elements()

func _update_ui_elements() -> void:
	_find_managers()
	var in_dialogue: bool = (dialogue_manager != null and dialogue_manager.has_method("is_active") and dialogue_manager.is_active()) or (GameState != null and GameState.is_movement_locked)
	var show_prompt: bool = _player_in_range and not in_dialogue
	if press_e_label:
		press_e_label.visible = show_prompt
		if show_prompt:
			var action_text: String = "E"
			match interactable_id:
				"warden":
					action_text = "🏛️ Warden [E]"
				"lamp_station":
					action_text = "🪔 Take Oil Lamp [E]" if (vihara_manager and not vihara_manager.task_lamp_complete and not vihara_manager.has_held_item("lamp")) else "🪔 Lamps Depot [E]"
				"study_room_lamp":
					action_text = "💡 Place & Light Lamp [E]" if (vihara_manager and vihara_manager.has_held_item("lamp")) else "💡 Study Desk [E]"
				"scribe_station":
					action_text = "📜 Take Manuscript [E]" if (vihara_manager and not vihara_manager.task_manuscript_complete and not vihara_manager.has_held_item("manuscript")) else "📜 Scribe [E]"
				"astronomy_student":
					action_text = "⭐ Deliver Granth [E]" if (vihara_manager and vihara_manager.has_held_item("manuscript")) else "⭐ Astronomy Scholar [E]"
				"water_station":
					action_text = "🏺 Take Water Vessels [E]" if (vihara_manager and not vihara_manager.task_water_complete and not vihara_manager.has_held_item("water_vessel")) else "🏺 Water Helper [E]"
				"courtyard_water":
					action_text = "💧 Place Water Vessels [E]" if (vihara_manager and vihara_manager.has_held_item("water_vessel")) else "💧 Water Stand [E]"
				"writing_kit_station":
					action_text = "✍️ Take Writing Kit [E]" if (vihara_manager and not vihara_manager.task_study_space_complete and not vihara_manager.has_held_item("writing_kit")) else "✍️ Supplies Shelf [E]"
				"junior_student_desk":
					action_text = "📋 Deliver Writing Kit [E]" if (vihara_manager and vihara_manager.has_held_item("writing_kit")) else "📋 Junior Desk [E]"
				"evening_bell":
					var all_prep = vihara_manager != null and vihara_manager.are_all_prep_tasks_complete()
					action_text = "🔔 RING EVENING BELL [E]" if all_prep else "🔔 Evening Bell [E]"
				"ambient_monk", "ambient_scholar", "ambient_student":
					action_text = "Talk [E]"
			press_e_label.text = action_text
