class_name QuestUI
extends CanvasLayer

@onready var panel_box: Control = $PanelBox
@onready var minimized_btn: Button = get_node_or_null("MinimizedBtn")
@onready var title_label: Label = get_node_or_null("PanelBox/MarginContainer/VBox/TitleLabel") if has_node("PanelBox/MarginContainer/VBox/TitleLabel") else get_node_or_null("PanelBox/TitleLabel")
@onready var objective_label: Label = get_node_or_null("PanelBox/MarginContainer/VBox/ObjectiveLabel") if has_node("PanelBox/MarginContainer/VBox/ObjectiveLabel") else get_node_or_null("PanelBox/ObjectiveLabel")
@onready var reward_label: Label = get_node_or_null("PanelBox/MarginContainer/VBox/RewardLabel") if has_node("PanelBox/MarginContainer/VBox/RewardLabel") else get_node_or_null("PanelBox/RewardLabel")
@onready var exp_stats_label: Label = get_node_or_null("PanelBox/MarginContainer/VBox/ExpStatsLabel") if has_node("PanelBox/MarginContainer/VBox/ExpStatsLabel") else get_node_or_null("PanelBox/ExpStatsLabel")
@onready var completion_timer: Timer = $CompletionTimer

@onready var exp_toast: Control = get_node_or_null("ExpToast")
@onready var exp_toast_title: Label = get_node_or_null("ExpToast/VBox/ToastTitle")
@onready var exp_toast_subtitle: Label = get_node_or_null("ExpToast/VBox/ToastSubtitle")
@onready var exp_toast_amount: Label = get_node_or_null("ExpToast/VBox/ToastAmount")
@onready var exp_timer: Timer = get_node_or_null("ExpToast/ExpTimer")

var _is_objective_active: bool = true
var _show_on_quest_update: bool = true
var _user_manually_opened: bool = false
var _is_hovered: bool = false

func _ready() -> void:
	add_to_group("quest_ui")
	_show_on_quest_update = true
	_user_manually_opened = false
	
	if minimized_btn:
		if not minimized_btn.pressed.is_connected(_toggle_objective_display):
			minimized_btn.pressed.connect(_toggle_objective_display)
	
	if panel_box:
		if not panel_box.mouse_entered.is_connected(_on_panel_mouse_entered):
			panel_box.mouse_entered.connect(_on_panel_mouse_entered)
		if not panel_box.mouse_exited.is_connected(_on_panel_mouse_exited):
			panel_box.mouse_exited.connect(_on_panel_mouse_exited)
		
	if GameState:
		if not GameState.quest_state_changed.is_connected(_on_quest_state_changed):
			GameState.quest_state_changed.connect(_on_quest_state_changed)
		if not GameState.merchant_state_changed.is_connected(_on_quest_state_changed):
			GameState.merchant_state_changed.connect(_on_quest_state_changed)
		if not GameState.teacher_state_changed.is_connected(_on_quest_state_changed):
			GameState.teacher_state_changed.connect(_on_quest_state_changed)
		if GameState.has_signal("exp_awarded") and not GameState.exp_awarded.is_connected(_on_exp_awarded):
			GameState.exp_awarded.connect(_on_exp_awarded)
		if GameState.has_signal("side_quest_completed") and not GameState.side_quest_completed.is_connected(_on_side_quest_completed):
			GameState.side_quest_completed.connect(_on_side_quest_completed)
		if GameState.has_signal("side_quest_state_changed") and not GameState.side_quest_state_changed.is_connected(_on_side_quest_state_changed):
			GameState.side_quest_state_changed.connect(_on_side_quest_state_changed)
			
	if completion_timer and not completion_timer.timeout.is_connected(_on_completion_timeout):
		completion_timer.timeout.connect(_on_completion_timeout)
		
	if exp_timer and not exp_timer.timeout.is_connected(_on_exp_timeout):
		exp_timer.timeout.connect(_on_exp_timeout)
		
	if exp_toast:
		exp_toast.visible = false

	update_quest_ui()
	pop_objective()

func _on_side_quest_state_changed(_quest_id: String, _new_state: int) -> void:
	_show_on_quest_update = true
	update_quest_ui()
	pop_objective()

func _is_in_vihara_tasks() -> bool:
	if not GameState:
		return false
	if GameState.is_vihara_completed():
		return false
	var cur_scene = get_tree().current_scene
	if cur_scene and (cur_scene.name == "InnerVihar" or cur_scene.name == "innerVihar"):
		return true
	if get_tree().get_nodes_in_group("vihara_objective_hud").size() > 0 or get_tree().get_nodes_in_group("vihara_manager").size() > 0:
		return true
	return false

func pop_objective() -> void:
	if not panel_box:
		return
	if _is_fullscreen_puzzle_active():
		panel_box.visible = false
		if minimized_btn:
			minimized_btn.visible = false
		return
	if _is_in_vihara_tasks() and not _user_manually_opened:
		panel_box.visible = false
		if minimized_btn:
			minimized_btn.visible = true
		return
	panel_box.visible = true
	if minimized_btn:
		minimized_btn.visible = false
	var tw := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	panel_box.modulate.a = 0.2
	tw.tween_property(panel_box, "modulate:a", 1.0, 0.25)

func _process(_delta: float) -> void:
	if not panel_box:
		return
		
	if _is_fullscreen_puzzle_active():
		if panel_box.visible:
			panel_box.visible = false
		if minimized_btn and minimized_btn.visible:
			minimized_btn.visible = false
	else:
		var in_vihara := _is_in_vihara_tasks()
		if in_vihara:
			if _user_manually_opened:
				if not panel_box.visible:
					panel_box.visible = true
				if minimized_btn and minimized_btn.visible:
					minimized_btn.visible = false
			else:
				if panel_box.visible:
					panel_box.visible = false
				if minimized_btn and not minimized_btn.visible:
					minimized_btn.visible = true
		else:
			if _show_on_quest_update:
				if not panel_box.visible:
					panel_box.visible = true
				if minimized_btn and minimized_btn.visible:
					minimized_btn.visible = false
			else:
				if panel_box.visible:
					panel_box.visible = false
				if minimized_btn and not minimized_btn.visible:
					minimized_btn.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.echo:
		if event.keycode == KEY_O: # Press 'O' to toggle objective HUD
			if not _is_fullscreen_puzzle_active():
				get_viewport().set_input_as_handled()
				_toggle_objective_display()

func _toggle_objective_display() -> void:
	if not panel_box:
		return
	if panel_box.visible:
		panel_box.visible = false
		_show_on_quest_update = false
		_user_manually_opened = false
		if minimized_btn:
			minimized_btn.visible = not _is_fullscreen_puzzle_active()
	else:
		_show_on_quest_update = true
		_user_manually_opened = true
		if minimized_btn:
			minimized_btn.visible = false
		update_quest_ui()
		pop_objective()

func _is_fullscreen_puzzle_active() -> bool:
	if not GameState:
		return true
		
	# 1. DevMode overlay check
	var dev = get_node_or_null("/root/DevModeManager")
	if dev and "is_menu_open" in dev and dev.is_menu_open:
		return true
		
	# 2. Known popup/challenge/puzzle groups check
	var popup_groups := [
		"pause_menu", "pause_menu_ui",
		"stupa_challenge_ui", "library_challenge_ui", "vihara_challenge_ui",
		"final_mastery_ui", "quiz_ui", "scholar_reasoning_ui",
		"nalanda_completion_ui", "vihara_completion_ui",
		"astro_heritage_ui", "math_heritage_ui", "med_heritage_ui", "phil_heritage_ui",
		"logic_heritage_ui", "knowledge_book_ui", "confirmation_dialog",
		"puzzle_ui", "math_puzzle_ui", "astro_puzzle_ui", "med_puzzle_ui", "phil_puzzle_ui",
		"domain_selection", "domain_selection_ui",
		"nalanda_info_ui", "intro_narration_ui", "narrative_choice_ui",
		"player_progress_ui", "controls_tutorial_ui", "cutscene_ui",
		"puzzle_info_panel", "popup_modal"
	]
	
	for g in popup_groups:
		var nodes = get_tree().get_nodes_in_group(g)
		for n in nodes:
			if is_instance_valid(n) and n.visible:
				if n.has_node("PanelContainer") and n.get_node("PanelContainer").visible:
					return true
				if n.has_node("MainPanel") and n.get_node("MainPanel").visible:
					return true
				if n.has_node("ColorRect") and n.get_node("ColorRect").visible:
					return true
				if n.has_node("SelectionBox") and n.get_node("SelectionBox").visible:
					return true
				if n.has_node("MenuBox") and n.get_node("MenuBox").visible:
					return true
				if not n.has_node("MainPanel") and not n.has_node("ColorRect") and not n.has_node("PanelContainer") and not n.has_node("SelectionBox") and not n.has_node("MenuBox") and n.visible:
					return true

	# 3. Check active scene children for any open CanvasLayer modal
	var cur_scene = get_tree().current_scene
	if cur_scene:
		for child in cur_scene.get_children():
			if not is_instance_valid(child) or child == self:
				continue
			if child.is_in_group("quest_ui") or child.is_in_group("objective_trail") or child.is_in_group("dialogue_ui"):
				continue
			if child is DialogueUI:
				continue
			if child is ViharaObjectiveHUD:
				if child.has_node("GuideModal") and child.get_node("GuideModal").visible:
					return true
				continue
			if child is CanvasLayer:
				if not child.visible:
					continue
				# Check if any main modal UI control inside this CanvasLayer is visible
				for sub in child.get_children():
					if sub is Control and sub.visible and sub.name != "DialogueBox":
						return true
						
	return false

func update_quest_ui() -> void:
	if not GameState or _is_fullscreen_puzzle_active():
		if panel_box:
			panel_box.visible = false
		return
		
	var cur_lvl: int = GameState.player_level
	var cur_exp: int = GameState.player_exp
	var req_exp: int = GameState.get_exp_required_for_next_level(cur_lvl)
	
	# 1. Check for Active Side Quest
	var active_q_id: String = ""
	for q_id in ["farmer_provisions", "scribe_manuscript", "stupa_caretaker", "vihara_supplies", "missing_student", "scholar_question"]:
		if GameState.is_side_quest_active(q_id):
			active_q_id = q_id
			break
			
	if active_q_id != "":
		var q: Dictionary = GameState.side_quests[active_q_id]
		var q_title: String = q.get("title", "Side Quest")
		var q_reward: int = GameState.SIDE_QUEST_EXP_REWARDS.get(active_q_id, 50)
		var obj_text: String = GameState.get_active_side_quest_objective()
		
		if panel_box and _show_on_quest_update:
			panel_box.visible = true
		if title_label:
			title_label.text = q_title.to_upper()
		if objective_label:
			objective_label.text = obj_text
		if reward_label:
			reward_label.text = "Reward: +" + str(q_reward) + " EXP"
			reward_label.visible = true
		if exp_stats_label:
			exp_stats_label.text = "Level: " + str(cur_lvl) + "   EXP: " + str(cur_exp) + " / " + str(req_exp)
			exp_stats_label.visible = true
		return
		
	# 2. Main Storyline Progression Flow (State-driven hierarchy)
	if panel_box and _show_on_quest_update:
		panel_box.visible = true
	if reward_label:
		reward_label.visible = false
	if exp_stats_label:
		exp_stats_label.text = "Level: " + str(cur_lvl) + "   EXP: " + str(cur_exp) + " / " + str(req_exp)
		exp_stats_label.visible = true

	var is_merchant_done: bool = GameState.merchant_passed or GameState.water_quest_completed or GameState.university_location_revealed
	var stupa_done: bool = GameState.is_stupa_completed() if GameState.has_method("is_stupa_completed") else (GameState.stupa_scroll_earned or GameState.stupa_mastery_completed)
	var lib_done: bool = GameState.is_library_completed() if GameState.has_method("is_library_completed") else (GameState.library_scroll_earned or GameState.library_mastery_completed)
	var vih_done: bool = GameState.is_vihara_completed() if GameState.has_method("is_vihara_completed") else (GameState.vihara_scroll_earned or GameState.vihara_mastery_completed)

	if GameState.nalanda_complete:
		if title_label:
			title_label.text = "NALANDA MASTERED"
		if objective_label:
			objective_label.text = "Wisdom preserved for eternity! Explore freely."
	elif GameState.final_mastery_complete:
		if title_label:
			title_label.text = "FINAL MASTERY"
		if objective_label:
			objective_label.text = "Mastery Complete! Speak with Teacher 3 to conclude."
	elif GameState.final_mastery_unlocked or GameState.has_all_three_scrolls():
		if title_label:
			title_label.text = "FINAL MASTERY"
		if objective_label:
			if GameState.final_mastery_unlocked:
				var dom: String = GameState.selected_domain.to_lower()
				if "math" in dom or "gaṇita" in dom:
					objective_label.text = "Complete Mathematics Mastery."
				elif "astro" in dom or "jyotiṣa" in dom:
					objective_label.text = "Complete Astronomy Mastery."
				elif "med" in dom or "cikitsā" in dom or "ayur" in dom:
					objective_label.text = "Complete Medicine Mastery."
				elif "phil" in dom or "darśana" in dom or "nyāya" in dom or "hetuvidyā" in dom:
					objective_label.text = "Complete Philosophy Mastery."
				else:
					objective_label.text = "Complete the Final Mastery Challenge."
			else:
				objective_label.text = "Return to Teacher 3 with the 3 Sacred Scrolls."
	elif GameState.has_met_teacher3:
		if not stupa_done:
			if title_label:
				title_label.text = "CHAPTER OBJECTIVE"
			if objective_label:
				objective_label.text = "Visit the Great Stupa and resolve the crisis."
		elif not lib_done:
			if title_label:
				title_label.text = "CHAPTER OBJECTIVE"
			if objective_label:
				objective_label.text = "Visit the Dharmaganja Library and resolve the dispute."
		elif not vih_done:
			if title_label:
				title_label.text = "CHAPTER OBJECTIVE"
			if objective_label:
				objective_label.text = "Visit the Vihara Living Quarters and resolve the dilemma."
		else:
			if title_label:
				title_label.text = "NALANDA EXPLORATION"
			if objective_label:
				objective_label.text = "Explore Nalanda and complete side quests."
	elif GameState.are_teacher2_tasks_completed():
		if OS.has_feature("web"):
			if title_label:
				title_label.text = "WEB DEMO COMPLETE"
			if objective_label:
				objective_label.text = "Download full game to continue Nalanda journey."
		else:
			if title_label:
				title_label.text = "CURRENT OBJECTIVE"
			if objective_label:
				objective_label.text = "Meet the Mastery Mentor at the central plaza."
	elif GameState.has_visited_university:
		if title_label:
			title_label.text = "CURRENT OBJECTIVE"
		if objective_label:
			if GameState.teacher2_convo_started:
				objective_label.text = "Complete the hands-on challenge."
			else:
				objective_label.text = "Meet Acharya & complete your domain task."
	elif GameState.teacher_admitted:
		if title_label:
			title_label.text = "CURRENT OBJECTIVE"
		if objective_label:
			objective_label.text = "Proceed through the northern gate into Nalanda University."
	elif is_merchant_done:
		if title_label:
			title_label.text = "CURRENT OBJECTIVE"
		if objective_label:
			if GameState.selected_domain != "" and not GameState.teacher_quiz_completed:
				objective_label.text = "Complete the Admission Quiz with Teacher 1."
			else:
				objective_label.text = "Meet the Teacher at the gate & pass the Admission Quiz."
	elif GameState.has_water:
		if title_label:
			title_label.text = "CURRENT OBJECTIVE"
		if objective_label:
			objective_label.text = "Return the fresh water bucket to the Merchant."
	elif GameState.merchant_water_quest_started:
		if title_label:
			title_label.text = "CURRENT OBJECTIVE"
		if objective_label:
			objective_label.text = "Collect fresh water from the nearby pond."
	else:
		if title_label:
			title_label.text = "CURRENT OBJECTIVE"
		if objective_label:
			objective_label.text = "Meet the Merchant."

func _on_side_quest_completed(quest_id: String) -> void:
	var q_title: String = "Side Quest"
	if GameState.side_quests.has(quest_id):
		q_title = GameState.side_quests[quest_id].get("title", "Side Quest")
		
	var q_reward: int = GameState.SIDE_QUEST_EXP_REWARDS.get(quest_id, 50)
	
	if exp_toast:
		if exp_toast_title:
			exp_toast_title.text = "QUEST COMPLETE!"
		if exp_toast_subtitle:
			exp_toast_subtitle.text = q_title
		if exp_toast_amount:
			exp_toast_amount.text = "+ " + str(q_reward) + " EXP"
			
		exp_toast.visible = true
		if exp_timer:
			exp_timer.start(3.2)
			
	_show_on_quest_update = true
	update_quest_ui()

func _on_exp_awarded(amount: int, _current_exp: int, _req: int, did_level_up: bool) -> void:
	if not exp_toast:
		return
		
	if did_level_up and GameState:
		if exp_toast_title:
			exp_toast_title.text = "🌟 LEVEL UP!"
		if exp_toast_subtitle:
			exp_toast_subtitle.text = "You reached Level " + str(GameState.player_level)
		if exp_toast_amount:
			exp_toast_amount.text = "EXP: " + str(GameState.player_exp) + " / " + str(GameState.get_exp_required_for_next_level(GameState.player_level))
			
		exp_toast.visible = true
		if exp_timer:
			exp_timer.start(3.5)
			
	update_quest_ui()

func _on_exp_timeout() -> void:
	if exp_toast:
		exp_toast.visible = false

func _on_quest_state_changed() -> void:
	_show_on_quest_update = true
	_user_manually_opened = false
	update_quest_ui()
	pop_objective()

func _on_completion_timeout() -> void:
	if panel_box:
		panel_box.visible = false

func _on_panel_mouse_entered() -> void:
	_is_hovered = true
	update_quest_ui()

func _on_panel_mouse_exited() -> void:
	_is_hovered = false
	update_quest_ui()
