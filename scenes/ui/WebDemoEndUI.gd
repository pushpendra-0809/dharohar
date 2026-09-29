class_name WebDemoEndUI
extends CanvasLayer

signal demo_end_closed()

@onready var color_rect: ColorRect = $ColorRect
@onready var main_panel: Control = $MainPanel
@onready var btn_download: Button = $MainPanel/VBoxContainer/ButtonBox/BtnDownload
@onready var btn_replay: Button = $MainPanel/VBoxContainer/ButtonBox/BtnReplay
@onready var btn_close: Button = $MainPanel/CloseButton
@onready var domain_badge_label: Label = $MainPanel/VBoxContainer/DomainBadge

var is_open: bool = false
const DOWNLOAD_URL: String = "https://github.com/pushpendra-0809/dharohar"

func _ready() -> void:
	add_to_group("web_demo_end_ui")
	visible = false
	if color_rect:
		color_rect.visible = false
	if main_panel:
		main_panel.visible = false
		
	_setup_buttons()

func _setup_buttons() -> void:
	if btn_download and not btn_download.pressed.is_connected(_on_download_pressed):
		btn_download.pressed.connect(_on_download_pressed)
		
	if btn_replay and not btn_replay.pressed.is_connected(_on_replay_pressed):
		btn_replay.pressed.connect(_on_replay_pressed)
		
	if btn_close and not btn_close.pressed.is_connected(_on_close_pressed):
		btn_close.pressed.connect(_on_close_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if is_open and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close_ui()

func open_demo_end_popup() -> void:
	is_open = true
	visible = true
	if color_rect:
		color_rect.visible = true
	if main_panel:
		main_panel.visible = true
		
	if GameState:
		GameState.lock_player_movement()
		if domain_badge_label:
			var dom: String = GameState.selected_domain.capitalize()
			if dom == "":
				dom = "Scholar"
			domain_badge_label.text = "★ " + dom.to_upper() + " FOUNDATIONAL STUDY COMPLETE ★"
			
	# Animate smooth scale-in
	if main_panel:
		main_panel.scale = Vector2(0.9, 0.9)
		main_panel.modulate.a = 0.0
		var tw := create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tw.tween_property(main_panel, "scale", Vector2.ONE, 0.3)
		tw.tween_property(main_panel, "modulate:a", 1.0, 0.25)

func close_ui() -> void:
	is_open = false
	visible = false
	if color_rect:
		color_rect.visible = false
	if main_panel:
		main_panel.visible = false
		
	if GameState:
		GameState.unlock_player_movement()
		
	demo_end_closed.emit()

func _on_download_pressed() -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("if (window.parent) { window.parent.postMessage({ type: 'DHAROHAR_OPEN_DOWNLOAD_MODAL' }, '*'); } else if (window.dharoharOpenDownloadModal) { window.dharoharOpenDownloadModal(); } else { window.open('" + DOWNLOAD_URL + "', '_blank'); }")
	else:
		OS.shell_open(DOWNLOAD_URL)

func _on_replay_pressed() -> void:
	close_ui()
	if GameState:
		GameState.reset_for_new_game()
	get_tree().change_scene_to_file("res://scenes/main menu/main_menu.tscn")

func _on_close_pressed() -> void:
	close_ui()
