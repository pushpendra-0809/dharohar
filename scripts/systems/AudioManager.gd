extends Node

var bgm_player: AudioStreamPlayer = null
const BGM_PATH: String = "res://audio/background.mpeg"
const BGM_ALT_PATH: String = "res://audio/DHAROHAR-AUDIO FINAL.mp3.mpeg"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_setup_bgm_player()
	call_deferred("play_bgm")

func _setup_bgm_player() -> void:
	if not bgm_player:
		bgm_player = AudioStreamPlayer.new()
		bgm_player.name = "BGMPlayer"
		bgm_player.bus = &"Master"
		bgm_player.volume_db = 0.0
		add_child(bgm_player)
		bgm_player.finished.connect(_on_bgm_finished)

func _load_bgm_stream() -> AudioStream:
	var paths_to_try = [BGM_PATH, BGM_ALT_PATH]
	for p in paths_to_try:
		if ResourceLoader.exists(p):
			var res = load(p)
			if res is AudioStreamMP3:
				res.loop = true
				return res
			elif res is AudioStream:
				return res
		if FileAccess.file_exists(p):
			var bytes := FileAccess.get_file_as_bytes(p)
			if bytes.size() > 0:
				var mp3 := AudioStreamMP3.new()
				mp3.data = bytes
				mp3.loop = true
				return mp3
	return null

func play_bgm() -> void:
	if not bgm_player:
		_setup_bgm_player()
		
	if not bgm_player.playing:
		if bgm_player.stream == null:
			bgm_player.stream = _load_bgm_stream()
		if bgm_player.stream:
			bgm_player.play()

func stop_bgm() -> void:
	if bgm_player and bgm_player.playing:
		bgm_player.stop()

func pause_bgm() -> void:
	if bgm_player:
		bgm_player.stream_paused = true

func resume_bgm() -> void:
	if bgm_player:
		bgm_player.stream_paused = false

var current_volume_percent: float = 100.0

func set_bgm_volume(vol_db: float) -> void:
	if bgm_player:
		bgm_player.volume_db = vol_db

func set_volume_percent(percent: float) -> void:
	current_volume_percent = clampf(percent, 0.0, 100.0)
	if current_volume_percent <= 0.01:
		if bgm_player:
			bgm_player.volume_db = -80.0
	else:
		var linear_val: float = current_volume_percent / 100.0
		var db: float = linear_to_db(linear_val)
		if bgm_player:
			bgm_player.volume_db = db

func get_volume_percent() -> float:
	return current_volume_percent

func _on_bgm_finished() -> void:
	if bgm_player and bgm_player.stream:
		bgm_player.play()
