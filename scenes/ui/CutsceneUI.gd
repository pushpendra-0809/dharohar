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
	if is_playing or _is_transitioning:
		return
	is_playing = true
	_is_transitioning = true
	visible = true
	
	if video_resource:
		video_player.stream = video_resource
	elif not video_player.stream:
		var stream_ogv = load("res://assets/videos/video1.ogv")
		if stream_ogv:
			video_player.stream = stream_ogv
		else:
			var stream_mp4 = load("res://assets/videos/video1.mp4")
			if stream_mp4:
				video_player.stream = stream_mp4

	fade_rect.color.a = 1.0
	if video_player:
		video_player.loop = false
		video_player.play()
	
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, 0.4)
	await tween.finished
	_is_transitioning = false

func _process(_delta: float) -> void:
	if is_playing and not _is_transitioning:
		if video_player and not video_player.is_playing():
			_on_video_finished()

func _unhandled_input(event: InputEvent) -> void:
	if is_playing and visible:
		if event.is_action_pressed("ui_cancel") or event.is_action_pressed("escape"):
			get_viewport().set_input_as_handled()
			_on_skip_pressed()

func _on_skip_pressed() -> void:
	_end_cutscene()

func _on_video_finished() -> void:
	_end_cutscene()

func _end_cutscene() -> void:
	if not is_playing or _is_transitioning:
		return
	_is_transitioning = true
	
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 1.0, 0.4)
	await tween.finished
	
	if video_player:
		video_player.stop()
	
	var fade_out_tween = create_tween()
	fade_out_tween.tween_property(fade_rect, "color:a", 0.0, 0.3)
	await fade_out_tween.finished
	
	visible = false
	is_playing = false
	_is_transitioning = false
	
	cutscene_finished.emit()
	queue_free()
