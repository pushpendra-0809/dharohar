class_name QuestUI
extends CanvasLayer

@onready var panel_box: Control = $PanelBox
@onready var title_label: Label = $PanelBox/TitleLabel
@onready var objective_label: Label = $PanelBox/ObjectiveLabel
@onready var reward_label: Label = get_node_or_null("PanelBox/RewardLabel")
@onready var exp_stats_label: Label = get_node_or_null("PanelBox/ExpStatsLabel")
@onready var completion_timer: Timer = $CompletionTimer

@onready var exp_toast: Control = get_node_or_null("ExpToast")
@onready var exp_toast_title: Label = get_node_or_null("ExpToast/VBox/ToastTitle")
@onready var exp_toast_subtitle: Label = get_node_or_null("ExpToast/VBox/ToastSubtitle")
@onready var exp_toast_amount: Label = get_node_or_null("ExpToast/VBox/ToastAmount")
@onready var exp_timer: Timer = get_node_or_null("ExpToast/ExpTimer")

func _ready() -> void:
	add_to_group("quest_ui")
	
	if GameState:
		if not GameState.quest_state_changed.is_connected(_on_quest_state_changed):
			GameState.quest_state_changed.connect(_on_quest_state_changed)
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
		
	update_quest_ui()

func update_quest_ui() -> void:
	if not GameState:
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
		
		if panel_box:
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
		if panel_box:
			panel_box.visible = true
		if title_label:
			title_label.text = "MASTERY CHALLENGES"
		if objective_label:
			var stupa_count: int = GameState.get_stupa_hard_completed_count() if GameState.has_method("get_stupa_hard_completed_count") else 0
			var stupa_done: bool = GameState.stupa_scroll_earned or GameState.stupa_mastery_completed
			var stupa_str: String = "Stupa: Complete ✓" if stupa_done else "Stupa: " + str(stupa_count) + "/4 Hard"
				
			var lib_count: int = GameState.get_library_hard_completed_count() if GameState.has_method("get_library_hard_completed_count") else 0
			var lib_done: bool = GameState.library_scroll_earned or GameState.library_mastery_completed or GameState.library_complete
			var lib_str: String = "Library: Complete ✓" if lib_done else "Library: " + str(lib_count) + "/4 Hard"
				
			var vih_count: int = GameState.get_vihara_hard_completed_count() if GameState.has_method("get_vihara_hard_completed_count") else 0
			var vih_done: bool = GameState.vihara_scroll_earned or GameState.vihara_mastery_completed or GameState.vihara_complete
			var vih_str: String = "Vihara: Complete ✓" if vih_done else "Vihara: " + str(vih_count) + "/4 Hard"
			
			var scrolls_count: int = (1 if stupa_done else 0) + (1 if lib_done else 0) + (1 if vih_done else 0)
			
			var headline: String = ""
			if GameState.nalanda_complete:
				headline = "Nalanda Experience Complete! (All Disciplines & Landmarks Mastered)"
			elif GameState.final_mastery_complete:
				headline = "Nalanda Domain Mastery Complete! Speak with Teacher 3."
			elif GameState.final_mastery_unlocked:
				var comp_stages: int = GameState.get_final_mastery_completed_count() if GameState.has_method("get_final_mastery_completed_count") else 0
				headline = "Complete Final Mastery with Teacher 3 (" + str(comp_stages) + "/5 stages complete)."
			elif scrolls_count >= 3:
				headline = "Return to Teacher 3 with the three Scrolls."
			elif scrolls_count > 0:
				headline = "Complete the remaining mastery challenges."
			else:
				headline = "Complete the mastery challenges in the Stupa, Library and Vihara."
				
			objective_label.text = headline + "\n• " + stupa_str + "  • " + lib_str + "  • " + vih_str
		if reward_label:
			reward_label.visible = false
		if exp_stats_label:
			exp_stats_label.text = "Level: " + str(cur_lvl) + "   EXP: " + str(cur_exp) + " / " + str(req_exp)
			exp_stats_label.visible = true
	elif GameState.has_visited_university:
		if GameState.are_teacher2_tasks_completed():
			if not GameState.has_met_teacher3:
				if panel_box:
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
				# University Exploration Mode -> Show side quest invitation with EXP stats
				if panel_box:
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
			if panel_box:
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
		if panel_box:
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
		if panel_box:
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
		if panel_box:
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
		if panel_box:
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
		if panel_box:
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
