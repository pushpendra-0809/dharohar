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
		
	var video_stream: VideoStream = null
	var ogv_path = video_path.replace(".mp4", ".ogv")
	if ResourceLoader.exists(ogv_path):
		video_stream = load(ogv_path)
	elif ResourceLoader.exists(video_path):
		video_stream = load(video_path)
		
	cutscene_instance.start_cutscene(video_stream)
	return cutscene_instance
