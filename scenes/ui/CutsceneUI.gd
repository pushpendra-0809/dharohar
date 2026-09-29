extends CanvasLayer

signal cutscene_finished

@onready var control: Control = $Control
@onready var video_player: VideoStreamPlayer = $Control/VideoStreamPlayer
@onready var skip_button: Button = $Control/SkipButton
@onready var fade_rect: ColorRect = $Control/FadeRect

var is_playing: bool = false
var _is_transitioning: bool = false

func _ready() -> void:
	visible = false
	fade_rect.color.a = 0.0
	if skip_button:
		if not skip_button.pressed.is_connected(_on_skip_pressed):
			skip_button.pressed.connect(_on_skip_pressed)
	if video_player:
		if not video_player.finished.is_connected(_on_video_finished):
			video_player.finished.connect(_on_video_finished)

func start_cutscene(video_resource: VideoStream = null) -> void:
	if is_playing:
		return
	is_playing = true
	visible = true
	
	if video_resource:
		video_player.stream = video_resource
	else:
		video_player.stream = null

	fade_rect.color.a = 1.0
	if video_player and video_player.stream:
		video_player.loop = false
		video_player.play()
	else:
		call_deferred("_end_cutscene")
		return
	
	_is_transitioning = true
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, 0.4)
	await tween.finished
	_is_transitioning = false

func _unhandled_input(event: InputEvent) -> void:
	if is_playing and visible:
		if event.is_action_pressed("ui_cancel") or event.is_action_pressed("escape") or event.is_action_pressed("ui_accept"):
			get_viewport().set_input_as_handled()
			_on_skip_pressed()

func _on_skip_pressed() -> void:
	_end_cutscene()

func _on_video_finished() -> void:
	_end_cutscene()

func _end_cutscene() -> void:
	if not is_playing:
		return
	is_playing = false
	_is_transitioning = false
	
	if video_player:
		video_player.stop()
	
	visible = false
	cutscene_finished.emit()
	queue_free()
