class_name NalandaIntroNarrationUI
extends CanvasLayer

signal narration_completed

@onready var dim_overlay: ColorRect = $DimOverlay
@onready var main_panel: Control = $MainPanel
@onready var scroll_container: ScrollContainer = $MainPanel/MarginContainer/VBox/ContentBox/MarginContainer/VBox/ScrollContainer
@onready var scroll_hint: Label = $MainPanel/MarginContainer/VBox/BottomBar/ScrollHintLabel
@onready var continue_btn: Button = $MainPanel/MarginContainer/VBox/BottomBar/ContinueBtn

var _is_open: bool = false

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	visible = false
	if continue_btn and not continue_btn.pressed.is_connected(_on_continue_pressed):
		continue_btn.pressed.connect(_on_continue_pressed)
	if scroll_container:
		var v_bar = scroll_container.get_v_scroll_bar()
		if v_bar and not v_bar.value_changed.is_connected(_on_scroll_changed):
			v_bar.value_changed.connect(_on_scroll_changed)

func open_narration() -> void:
	_is_open = true
	visible = true
	if GameState:
		GameState.lock_player_movement()
	if scroll_container:
		scroll_container.scroll_vertical = 0
	if scroll_hint:
		scroll_hint.visible = true
	if continue_btn:
		continue_btn.grab_focus()
	
	main_panel.modulate.a = 0.0
	dim_overlay.modulate.a = 0.0
	var tw = create_tween().set_parallel(true).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.tween_property(main_panel, "modulate:a", 1.0, 0.25)
	tw.tween_property(dim_overlay, "modulate:a", 1.0, 0.25)

func _on_scroll_changed(value: float) -> void:
	if scroll_container and scroll_hint:
		var v_bar = scroll_container.get_v_scroll_bar()
		if v_bar and (value + v_bar.page >= v_bar.max_value - 20.0):
			scroll_hint.visible = false

func _on_continue_pressed() -> void:
	if not _is_open:
		return
	_is_open = false
	
	if GameState:
		GameState.nalanda_intro_seen = true
		GameState.has_played_nalanda_intro_cutscene = true
		GameState.unlock_player_movement()
		
	var tw = create_tween().set_parallel(true).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tw.tween_property(main_panel, "modulate:a", 0.0, 0.2)
	tw.tween_property(dim_overlay, "modulate:a", 0.0, 0.2)
	await tw.finished
	visible = false
	narration_completed.emit()
