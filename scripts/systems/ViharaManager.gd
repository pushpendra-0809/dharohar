class_name ViharaManager
extends Node

signal task_updated(task_id: String, is_complete: bool)
signal held_item_changed(item_id: String, item_name: String)
signal vihara_completed()

# Task States
var task_lamp_complete: bool = false
var task_manuscript_complete: bool = false
var task_water_complete: bool = false
var task_study_space_complete: bool = false
var task_bell_complete: bool = false

# Player Inventory in Vihara
var held_item_id: String = "" # "lamp", "manuscript", "water_vessel", "writing_kit"
var held_item_name: String = ""

# References
var dialogue_manager: Node = null
var objective_hud: Node = null
var completion_ui: Node = null

func _ready() -> void:
	add_to_group("vihara_manager")
	if GameState and GameState.is_vihara_completed():
		task_lamp_complete = true
		task_manuscript_complete = true
		task_water_complete = true
		task_study_space_complete = true
		task_bell_complete = true

func setup(d_mgr: Node, hud: Node = null, comp_ui: Node = null) -> void:
	dialogue_manager = d_mgr
	objective_hud = hud
	completion_ui = comp_ui
	_update_all_hud_tasks()

func pickup_item(item_id: String, item_name: String) -> void:
	held_item_id = item_id
	held_item_name = item_name
	held_item_changed.emit(held_item_id, held_item_name)
	_update_all_hud_tasks()

func clear_held_item() -> void:
	held_item_id = ""
	held_item_name = ""
	held_item_changed.emit("", "")
	_update_all_hud_tasks()

func has_held_item(item_id: String) -> bool:
	return held_item_id == item_id

func are_all_prep_tasks_complete() -> bool:
	return task_lamp_complete and task_manuscript_complete and task_water_complete and task_study_space_complete

func is_vihara_fully_complete() -> bool:
	return task_bell_complete

func complete_task(task_id: String) -> void:
	match task_id:
		"lamp":
			task_lamp_complete = true
		"manuscript":
			task_manuscript_complete = true
		"water":
			task_water_complete = true
		"study_space":
			task_study_space_complete = true
		"bell":
			task_bell_complete = true
			if GameState:
				GameState.complete_vihara_mastery()
			vihara_completed.emit()
			if completion_ui and completion_ui.has_method("show_completion"):
				completion_ui.show_completion()
	
	task_updated.emit(task_id, true)
	_update_all_hud_tasks()

func _update_all_hud_tasks() -> void:
	if objective_hud and objective_hud.has_method("update_tasks"):
		objective_hud.update_tasks(
			task_lamp_complete,
			task_manuscript_complete,
			task_water_complete,
			task_study_space_complete,
			task_bell_complete,
			held_item_name
		)

func reset_vihara_progress() -> void:
	task_lamp_complete = false
	task_manuscript_complete = false
	task_water_complete = false
	task_study_space_complete = false
	task_bell_complete = false
	held_item_id = ""
	held_item_name = ""
	if GameState:
		GameState.vihara_complete = false
		GameState.vihara_scroll_earned = false
		GameState.vihara_mastery_completed = false
	_update_all_hud_tasks()
