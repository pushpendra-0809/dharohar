extends CanvasLayer

signal tutorial_closed

@onready var control: Control = $Control
@onready var got_it_button: Button = $Control/PanelContainer/MarginContainer/VBoxContainer/GotItButton
@onready var fade_rect: ColorRect = $Control/FadeRect

var _is_closing: bool = false

func _ready() -> void:
	visible = false
	if fade_rect:
		fade_rect.color.a = 0.0
	if got_it_button:
		if not got_it_button.pressed.is_connected(_on_got_it_pressed):
			got_it_button.pressed.connect(_on_got_it_pressed)

func show_popup() -> void:
	visible = true
	_is_closing = false
	if fade_rect:
		fade_rect.color.a = 1.0
		var tween = create_tween()
		tween.tween_property(fade_rect, "color:a", 0.0, 0.3)
	if got_it_button:
		got_it_button.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if visible and not _is_closing:
		if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select") or event.is_action_pressed("interact") or event.is_action_pressed("escape"):
			get_viewport().set_input_as_handled()
			_on_got_it_pressed()

func _on_got_it_pressed() -> void:
	if _is_closing:
		return
	_is_closing = true
	
	if fade_rect:
		var tween = create_tween()
		tween.tween_property(fade_rect, "color:a", 1.0, 0.25)
		await tween.finished
		
	visible = false
	tutorial_closed.emit()
	queue_free()
