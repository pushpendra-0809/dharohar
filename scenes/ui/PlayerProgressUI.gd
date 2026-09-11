class_name PlayerProgressUI
extends CanvasLayer

signal progress_opened
signal progress_closed

@onready var panel_box: Control = $PanelBox
@onready var level_label: Label = $PanelBox/VBox/LevelLabel
@onready var exp_label: Label = $PanelBox/VBox/ExpLabel
@onready var exp_progress_bar: ProgressBar = $PanelBox/VBox/ExpProgressBar
@onready var next_level_label: Label = $PanelBox/VBox/NextLevelLabel
@onready var quest_stats_label: Label = $PanelBox/VBox/QuestStatsLabel
@onready var total_exp_label: Label = $PanelBox/VBox/TotalExpLabel
@onready var close_button: Button = $PanelBox/CloseButton

var _is_open: bool = false

func _ready() -> void:
	add_to_group("player_progress_ui")
	visible = false
	if panel_box:
		panel_box.visible = false
		
	if close_button and not close_button.pressed.is_connected(close_progress_panel):
		close_button.pressed.connect(close_progress_panel)
		
	if GameState:
		if not GameState.quest_state_changed.is_connected(_on_state_changed):
			GameState.quest_state_changed.connect(_on_state_changed)
		if GameState.has_signal("exp_awarded") and not GameState.exp_awarded.is_connected(_on_exp_awarded):
			GameState.exp_awarded.connect(_on_exp_awarded)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_P:
			# Check if typing or movement locked by dialogue/quiz
			var d_active: bool = false
			var scene = get_tree().current_scene
			if scene and "dialogue_manager" in scene and scene.dialogue_manager:
				d_active = scene.dialogue_manager.is_active()
				
			if not d_active:
				get_viewport().set_input_as_handled()
				toggle_progress_panel()
		elif _is_open and event.keycode == KEY_ESCAPE:
			get_viewport().set_input_as_handled()
			close_progress_panel()

func is_open() -> bool:
	return _is_open

func toggle_progress_panel() -> void:
	if _is_open:
		close_progress_panel()
	else:
		open_progress_panel()

func open_progress_panel() -> void:
	_is_open = true
	update_progress_data()
	visible = true
	if panel_box:
		panel_box.visible = true
	if GameState:
		GameState.lock_player_movement()
	progress_opened.emit()

func close_progress_panel() -> void:
	_is_open = false
	visible = false
	if panel_box:
		panel_box.visible = false
	if GameState:
		GameState.unlock_player_movement()
	progress_closed.emit()

func update_progress_data() -> void:
	if not GameState:
		return
		
	var lvl: int = GameState.player_level
	var cur_exp: int = GameState.player_exp
	var req_exp: int = GameState.get_exp_required_for_next_level(lvl)
	var rem_exp: int = max(0, req_exp - cur_exp)
	var total_exp: int = GameState.total_accumulated_exp
	
	var completed_quests: int = 0
	for q_id in GameState.side_quests:
		if GameState.is_side_quest_complete(q_id):
			completed_quests += 1
			
	if level_label:
		level_label.text = "LEVEL: " + str(lvl)
	if exp_label:
		exp_label.text = "EXP: " + str(cur_exp) + " / " + str(req_exp)
	if exp_progress_bar:
		exp_progress_bar.max_value = req_exp
		exp_progress_bar.value = cur_exp
	if next_level_label:
		next_level_label.text = "Next Level: " + str(rem_exp) + " EXP remaining"
	if quest_stats_label:
		quest_stats_label.text = "Side Quests Completed: " + str(completed_quests) + " / 6"
	if total_exp_label:
		total_exp_label.text = "Lifetime Experience: " + str(total_exp) + " EXP"

func _on_state_changed() -> void:
	if _is_open:
		update_progress_data()

func _on_exp_awarded(_amt: int, _cur: int, _req: int, _lvl_up: bool) -> void:
	if _is_open:
		update_progress_data()
