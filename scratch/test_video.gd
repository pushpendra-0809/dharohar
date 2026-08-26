extends SceneTree

func _init() -> void:
	print("--- TEST VIDEO RESOURCE LOADING ---")
	var paths = [
		"res://assets/videos/video1.ogv",
		"res://assets/videos/video2.ogv",
		"res://assets/videos/video3.ogv",
		"res://assets/videos/video1.mp4",
		"res://assets/videos/video2.mp4",
		"res://assets/videos/video3.mp4"
	]
	
	for p in paths:
		var res_exists = ResourceLoader.exists(p)
		var file_exists = FileAccess.file_exists(p)
		var res_obj = load(p) if (res_exists or file_exists) else null
		print(p, " -> ResourceLoader.exists: ", res_exists, " | FileAccess.file_exists: ", file_exists, " | loaded: ", res_obj != null)
		
	quit()
