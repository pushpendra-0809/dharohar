class_name CutscenePlayer
extends Node

const CUTSCENE_UI_SCENE = preload("res://scenes/ui/CutsceneUI.tscn")

static func play_video(parent: Node, video_path: String = "res://assets/videos/video1.ogv", on_finished_callback: Callable = Callable()) -> CanvasLayer:
	if not parent or not is_instance_valid(parent):
		return null
		
	var cutscene_instance = CUTSCENE_UI_SCENE.instantiate()
	parent.add_child(cutscene_instance)
	
	if on_finished_callback.is_valid():
		cutscene_instance.cutscene_finished.connect(on_finished_callback, CONNECT_ONE_SHOT)
		
	var video_stream: VideoStream = null
	if ResourceLoader.exists(video_path):
		video_stream = load(video_path)
		
	cutscene_instance.start_cutscene(video_stream)
	return cutscene_instance
