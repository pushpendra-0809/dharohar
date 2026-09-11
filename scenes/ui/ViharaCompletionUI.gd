class_name ViharaCompletionUI
extends CanvasLayer

signal completion_dismissed()

@onready var color_rect: ColorRect = $ColorRect
@onready var main_panel: Control = $MainPanel
@onready var warden_speech: Label = $MainPanel/DialogueLabel
@onready var btn_return: Button = $MainPanel/BtnReturn

func _ready() -> void:
	add_to_group("vihara_completion_ui")
	visible = false
	if color_rect:
		color_rect.visible = false
	if main_panel:
		main_panel.visible = false
	
	if btn_return and not btn_return.pressed.is_connected(_on_return_pressed):
		btn_return.pressed.connect(_on_return_pressed)

func show_completion() -> void:
	visible = true
	if color_rect:
		color_rect.visible = true
	if main_panel:
		main_panel.visible = true
	
	if warden_speech:
		warden_speech.text = "“Evening preparations across the Vihara are complete.\n\nToday, you did not just solve a theoretical puzzle. You ensured that scholars, monks, and students can begin their study and life in peace and harmony.\n\nThis was the true beauty of Nalanda — education was not confined to lecture halls alone.\n\nYou are hereby awarded the Vihara Scroll of Communal Harmony.”"
		
	if GameState:
		GameState.lock_player_movement()
		GameState.complete_vihara_mastery()

func _on_return_pressed() -> void:
	visible = false
	if color_rect:
		color_rect.visible = false
	if main_panel:
		main_panel.visible = false
	
	if GameState:
		GameState.unlock_player_movement()
		
	completion_dismissed.emit()
	get_tree().change_scene_to_file("res://scenes/nalanda_university.tscn")
