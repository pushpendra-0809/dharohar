class_name QuestUI
extends CanvasLayer

@onready var panel_box: Control = $PanelBox
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

var _is_objective_active: bool = false
var _show_on_quest_update: bool = false

func _ready() -> void:
	add_to_group("quest_ui")
	
	if panel_box:
		panel_box.visible = false # Hidden by default when opening game
		
	if GameState:
		if not GameState.quest_state_changed.is_connected(_on_quest_state_changed):
			GameState.quest_state_changed.connect(_on_quest_state_changed)
		if GameState.has_signal("player_movement_locked") and not GameState.player_movement_locked.is_connected(_on_movement_locked):
			GameState.player_movement_locked.connect(_on_movement_locked)
		if GameState.has_signal("exp_awarded") and not GameState.exp_awarded.is_connected(_on_exp_awarded):
			GameState.exp_awarded.connect(_on_exp_awarded)
		if GameState.has_signal("side_quest_completed") and not GameState.side_quest_completed.is_connected(_on_side_quest_completed):
			GameState.side_quest_completed.connect(_on_side_quest_completed)
			
	if completion_timer and not completion_timer.timeout.is_connected(_on_completion_timeout):
		completion_timer.timeout.connect(_on_completion_timeout)
		
	if exp_timer and not exp_timer.timeout.is_connected(_on_exp_timeout):
		exp_timer.timeout.connect(_on_exp_timeout)
		
	if exp_toast:
		exp_toast.visible = false

func _process(_delta: float) -> void:
	if not panel_box:
		return
		
	if _is_any_popup_or_dialog_active():
		if panel_box.visible:
			panel_box.visible = false
	else:
		if _show_on_quest_update and not panel_box.visible:
			panel_box.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_O: # Press 'O' to toggle objective HUD
			if not _is_any_popup_or_dialog_active():
				get_viewport().set_input_as_handled()
				_toggle_objective_display()

func _toggle_objective_display() -> void:
	if not panel_box:
		return
	if panel_box.visible:
		panel_box.visible = false
		_show_on_quest_update = false
	else:
		_show_on_quest_update = true
		update_quest_ui()
		panel_box.visible = true

func _is_any_popup_or_dialog_active() -> bool:
	if not GameState:
		return true
	if GameState.is_movement_locked:
		return true
		
	var dev = get_node_or_null("/root/DevModeManager")
	if dev and "is_menu_open" in dev and dev.is_menu_open:
		return true
		
	var popup_groups := [
		"dialogue_ui", "pause_menu", "pause_menu_ui",
		"stupa_challenge_ui", "library_challenge_ui", "vihara_challenge_ui",
		"final_mastery_ui", "quiz_ui", "scholar_reasoning_ui",
		"cutscene_ui", "nalanda_completion_ui", "astro_heritage_ui",
		"math_heritage_ui", "med_heritage_ui", "phil_heritage_ui",
		"logic_heritage_ui", "knowledge_book_ui", "confirmation_dialog"
	]
	
	for g in popup_groups:
		var nodes = get_tree().get_nodes_in_group(g)
		for n in nodes:
			if is_instance_valid(n) and n.visible:
				if n.has_node("MainPanel") and n.get_node("MainPanel").visible:
					return true
				if n.has_node("ColorRect") and n.get_node("ColorRect").visible:
					return true
				if not n.has_node("MainPanel") and not n.has_node("ColorRect") and n.visible:
					return true
					
	return false

func _on_movement_locked(locked: bool) -> void:
	if locked:
		if panel_box:
			panel_box.visible = false
	else:
		if _show_on_quest_update:
			update_quest_ui()

func update_quest_ui() -> void:
	if not GameState or _is_any_popup_or_dialog_active():
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
		
	# 2. Main Storyline Progression / Idle State
	if GameState.has_met_teacher3:
		if panel_box and _show_on_quest_update:
			panel_box.visible = true
		if title_label:
			title_label.text = "STORY MASTERY"
		if objective_label:
			var stupa_done: bool = GameState.is_stupa_completed() if GameState.has_method("is_stupa_completed") else (GameState.stupa_scroll_earned or GameState.stupa_mastery_completed)
			var lib_done: bool = GameState.is_library_completed() if GameState.has_method("is_library_completed") else (GameState.library_scroll_earned or GameState.library_mastery_completed)
			var vih_done: bool = GameState.is_vihara_completed() if GameState.has_method("is_vihara_completed") else (GameState.vihara_scroll_earned or GameState.vihara_mastery_completed)
			
			var stupa_str: String = "Stupa: 📜 Claimed" if stupa_done else ("Stupa: 🔓 Ready" if GameState.stupa_unlocked else "Stupa: 🔒 Locked")
			var lib_str: String = "Library: 📜 Claimed" if lib_done else ("Library: 🔓 Ready" if GameState.library_unlocked else "Library: 🔒 Locked")
			var vih_str: String = "Vihara: 📜 Claimed" if vih_done else ("Vihara: 🔓 Ready" if GameState.vihara_unlocked else "Vihara: 🔒 Locked")
			
			var headline: String = ""
			if GameState.nalanda_complete:
				headline = "Nalanda Journey Complete! Wisdom preserved."
			elif GameState.final_mastery_complete:
				headline = "Mastery Complete! Speak with Teacher 3."
			elif GameState.has_all_three_scrolls():
				headline = "Return to Teacher 3 with 3 Scrolls for Final Mastery."
			elif not GameState.stupa_unlocked:
				headline = "Help villagers & complete NPC tasks to unlock the Stupa."
			elif not stupa_done:
				headline = "Visit the Great Stupa and resolve the crisis."
			elif not GameState.library_unlocked:
				headline = "Help more NPCs to gain EXP and unlock the Library."
			elif not lib_done:
				headline = "Visit the Dharmaganja Library and resolve the dispute."
			elif not GameState.vihara_unlocked:
				headline = "Help more NPCs to gain EXP and unlock the Vihara."
			elif not vih_done:
				headline = "Visit the Vihara Living Quarters and resolve the dilemma."
			else:
				headline = "Explore Nalanda and complete building chapters."
				
			objective_label.text = headline + "\n" + stupa_str + "  •  " + lib_str + "  •  " + vih_str
		if reward_label:
			reward_label.visible = false
		if exp_stats_label:
			exp_stats_label.text = "Level: " + str(cur_lvl) + "   EXP: " + str(cur_exp) + " / " + str(req_exp)
			exp_stats_label.visible = true
	elif GameState.has_visited_university:
		if GameState.are_teacher2_tasks_completed():
			if not GameState.has_met_teacher3:
				if panel_box and _show_on_quest_update:
					panel_box.visible = true
				if title_label:
					title_label.text = "OBJECTIVE"
				if objective_label:
					objective_label.text = "Speak with the Mastery Mentor (Teacher 3)."
				if reward_label:
					reward_label.visible = false
				if exp_stats_label:
					exp_stats_label.text = "Level: " + str(cur_lvl) + "   EXP: " + str(cur_exp) + " / " + str(req_exp)
					exp_stats_label.visible = true
			else:
				if panel_box and _show_on_quest_update:
					panel_box.visible = true
				if title_label:
					title_label.text = "NALANDA EXPLORATION"
				if objective_label:
					objective_label.text = "Complete side quests to gain EXP."
				if reward_label:
					reward_label.visible = false
				if exp_stats_label:
					exp_stats_label.text = "Level: " + str(cur_lvl) + "   EXP: " + str(cur_exp) + " / " + str(req_exp)
					exp_stats_label.visible = true
		else:
			if panel_box and _show_on_quest_update:
				panel_box.visible = true
			if title_label:
				title_label.text = "OBJECTIVE"
			if objective_label:
				objective_label.text = "Meet Acharya (Teacher 2) & Complete Hands-on Task"
			if reward_label:
				reward_label.visible = false
			if exp_stats_label:
				exp_stats_label.text = "Level: " + str(cur_lvl) + "   EXP: " + str(cur_exp) + " / " + str(req_exp)
				exp_stats_label.visible = true
	elif GameState.teacher_admitted:
		if panel_box and _show_on_quest_update:
			panel_box.visible = true
		if title_label:
			title_label.text = "OBJECTIVE"
		if objective_label:
			objective_label.text = "Proceed to Nalanda University"
		if reward_label:
			reward_label.visible = false
		if exp_stats_label:
			exp_stats_label.text = "Level: " + str(cur_lvl) + "   EXP: " + str(cur_exp) + " / " + str(req_exp)
			exp_stats_label.visible = true
	elif GameState.water_quest_completed or GameState.university_location_revealed:
		if panel_box and _show_on_quest_update:
			panel_box.visible = true
		if title_label:
			title_label.text = "OBJECTIVE"
		if objective_label:
			objective_label.text = "Meet the Teacher"
		if reward_label:
			reward_label.visible = false
		if exp_stats_label:
			exp_stats_label.text = "Level: " + str(cur_lvl) + "   EXP: " + str(cur_exp) + " / " + str(req_exp)
			exp_stats_label.visible = true
	elif GameState.has_water:
		if panel_box and _show_on_quest_update:
			panel_box.visible = true
		if title_label:
			title_label.text = "OBJECTIVE"
		if objective_label:
			objective_label.text = "Return the water to the Merchant"
		if reward_label:
			reward_label.visible = false
		if exp_stats_label:
			exp_stats_label.text = "Level: " + str(cur_lvl) + "   EXP: " + str(cur_exp) + " / " + str(req_exp)
			exp_stats_label.visible = true
	elif GameState.merchant_water_quest_started:
		if panel_box and _show_on_quest_update:
			panel_box.visible = true
		if title_label:
			title_label.text = "OBJECTIVE"
		if objective_label:
			objective_label.text = "Collect water from the nearby pond"
		if reward_label:
			reward_label.visible = false
		if exp_stats_label:
			exp_stats_label.text = "Level: " + str(cur_lvl) + "   EXP: " + str(cur_exp) + " / " + str(req_exp)
			exp_stats_label.visible = true
	else:
		if panel_box and _show_on_quest_update:
			panel_box.visible = true
		if title_label:
			title_label.text = "OBJECTIVE"
		if objective_label:
			objective_label.text = "Meet the merchant"
		if reward_label:
			reward_label.visible = false
		if exp_stats_label:
			exp_stats_label.text = "Level: " + str(cur_lvl) + "   EXP: " + str(cur_exp) + " / " + str(req_exp)
			exp_stats_label.visible = true

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
	update_quest_ui()

func _on_completion_timeout() -> void:
	if panel_box:
		panel_box.visible = false
