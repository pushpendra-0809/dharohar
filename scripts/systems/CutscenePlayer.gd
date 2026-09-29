class_name CutscenePlayer
extends Node

const CUTSCENE_UI_SCENE = preload("res://scenes/ui/CutsceneUI.tscn")

static func play_video(parent: Node, video_path: String = "res://assets/videos/video1.ogv", on_finished_callback: Callable = Callable()) -> CanvasLayer:
	if not parent or not is_instance_valid(parent):
		return null
		
	var audio_mgr = parent.get_node_or_null("/root/AudioManager")
	if audio_mgr and audio_mgr.has_method("pause_bgm"):
		audio_mgr.pause_bgm()
		
	var cutscene_instance = CUTSCENE_UI_SCENE.instantiate()
	parent.add_child(cutscene_instance)
	
	var finish_wrapper = func():
		if audio_mgr and audio_mgr.has_method("resume_bgm"):
			audio_mgr.resume_bgm()
		if on_finished_callback.is_valid():
			on_finished_callback.call()
			
	cutscene_instance.cutscene_finished.connect(finish_wrapper, CONNECT_ONE_SHOT)
		
	var video_stream: VideoStream = _load_video_stream(video_path)
	cutscene_instance.start_cutscene(video_stream)
	return cutscene_instance

static func _load_video_stream(video_path: String) -> VideoStream:
	var ogv_path: String = video_path.replace(".mp4", ".ogv")
	
	# 1. Try loading via ResourceLoader on OGV
	if ResourceLoader.exists(ogv_path):
		var res = load(ogv_path)
		if res is VideoStream:
			return res
			
	# 2. Try loading via ResourceLoader on original path
	if ResourceLoader.exists(video_path):
		var res = load(video_path)
		if res is VideoStream:
			return res
			
	# 3. Direct instantiate VideoStreamTheora (Godot 4 native)
	if FileAccess.file_exists(ogv_path):
		var theora_stream := VideoStreamTheora.new()
		theora_stream.file = ogv_path
		return theora_stream
		
	if FileAccess.file_exists(video_path):
		var theora_stream := VideoStreamTheora.new()
		theora_stream.file = video_path
		return theora_stream
		
	return null
