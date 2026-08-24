class_name QuestUI
extends CanvasLayer

@onready var panel_box: Control = $PanelBox
@onready var objective_label: Label = $PanelBox/ObjectiveLabel
@onready var completion_timer: Timer = $CompletionTimer

func _ready() -> void:
	add_to_group("quest_ui")
	
	if GameState:
		if not GameState.quest_state_changed.is_connected(_on_quest_state_changed):
			GameState.quest_state_changed.connect(_on_quest_state_changed)
			
	if completion_timer and not completion_timer.timeout.is_connected(_on_completion_timeout):
		completion_timer.timeout.connect(_on_completion_timeout)
		
	update_quest_ui()

func update_quest_ui() -> void:
	if not GameState:
		if panel_box:
			panel_box.visible = false
		return
		
	if GameState.has_visited_university:
		if GameState.teacher2_convo_started or GameState.math_puzzle_completed or GameState.medicine_puzzle_completed or GameState.astronomy_puzzle_completed or GameState.philosophy_puzzle_completed:
			if panel_box:
				panel_box.visible = false
		else:
			if panel_box:
				panel_box.visible = true
			if objective_label:
				objective_label.text = "Meet the Teacher"
	elif GameState.teacher_admitted:
		if panel_box:
			panel_box.visible = true
		if objective_label:
			objective_label.text = "Proceed to Nalanda University"
	elif GameState.water_quest_completed or GameState.university_location_revealed:
		if panel_box:
			panel_box.visible = true
		if objective_label:
			objective_label.text = "Meet the Teacher"
	elif GameState.has_water:
		if panel_box:
			panel_box.visible = true
		if objective_label:
			objective_label.text = "Return the water to the Merchant"
	elif GameState.merchant_water_quest_started:
		if panel_box:
			panel_box.visible = true
		if objective_label:
			objective_label.text = "Collect water from the nearby pond"
	else:
		if panel_box:
			panel_box.visible = true
		if objective_label:
			objective_label.text = "Meet the merchant"

func _on_quest_state_changed() -> void:
	update_quest_ui()

func _on_completion_timeout() -> void:
	if panel_box:
		panel_box.visible = false
