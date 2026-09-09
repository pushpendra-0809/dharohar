extends Node

var bgm_player: AudioStreamPlayer = null
const BGM_PATH: String = "res://audio/background.mpeg"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_setup_bgm_player()
	call_deferred("play_bgm")

func _setup_bgm_player() -> void:
	if not bgm_player:
		bgm_player = AudioStreamPlayer.new()
		bgm_player.name = "BGMPlayer"
		bgm_player.bus = &"Master"
		bgm_player.volume_db = -8.0
		add_child(bgm_player)
		bgm_player.finished.connect(_on_bgm_finished)

func _load_bgm_stream() -> AudioStream:
	if ResourceLoader.exists(BGM_PATH):
		var res = load(BGM_PATH)
		if res is AudioStream:
			return res
	if FileAccess.file_exists(BGM_PATH):
		var bytes := FileAccess.get_file_as_bytes(BGM_PATH)
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

func set_bgm_volume(vol_db: float) -> void:
	if bgm_player:
		bgm_player.volume_db = vol_db

func _on_bgm_finished() -> void:
	if bgm_player and bgm_player.stream:
		bgm_player.play()
