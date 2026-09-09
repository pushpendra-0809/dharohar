extends StaticBody2D

enum State {
	AVAILABLE,
	INTRO_DIALOGUE,
	DOMAIN_SELECTION,
	HERITAGE,
	TRANSITION_DIALOGUE,
	QUIZ,
	ADMITTED,
	WAITING
}

const DOMAIN_AUDIO: Dictionary = {
	"mathematics": {
		"teaching": "res://audio/mathematics 1.mp3.mpeg",
		"transition": "res://audio/mathematics 2.mp3.mpeg"
	},
	"astronomy": {
		"teaching": "res://audio/Astronomy 1.mp3.mpeg",
		"transition": "res://audio/Astronomy 2.mp3.mpeg"
	},
	"medicine": {
		"teaching": "res://audio/Ayurveda 1.mp3.mpeg",
		"transition": "res://audio/Ayurveda 2.mp3.mpeg"
	},
	"philosophy": {
		"teaching": "res://audio/Philosophy 1.mp3.mpeg",
		"transition": "res://audio/Philosophy 2.mp3.mpeg"
	}
}

var current_state: State = State.AVAILABLE
var _player_in_range: bool = false
var _selected_domain: String = ""
var _audio_cache: Dictionary = {}

@onready var interaction_area: Area2D = $InteractionArea
@onready var indicator: Label = $InteractionIndicator
@onready var press_e_label: Label = $PressELabel
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var voice_player: AudioStreamPlayer = $VoiceAudioPlayer

# Managers (initialized or referenced from scene tree)
var dialogue_manager: DialogueManager = null
var quiz_manager: QuizManager = null
var domain_ui: DomainSelectionUI = null
var math_heritage_ui: Node = null
var astro_heritage_ui: Node = null
var med_heritage_ui: Node = null
var phil_heritage_ui: Node = null
var logic_heritage_ui: Node = null
var knowledge_book_ui: Node = null

func setup_managers(d_mgr: DialogueManager, q_mgr: QuizManager, dom_ui: DomainSelectionUI, math_h_ui: Node = null, astro_h_ui: Node = null, med_h_ui: Node = null, phil_h_ui: Node = null, logic_h_ui: Node = null, kb_ui: Node = null) -> void:
	dialogue_manager = d_mgr
	quiz_manager = q_mgr
	domain_ui = dom_ui
	math_heritage_ui = math_h_ui
	astro_heritage_ui = astro_h_ui
	med_heritage_ui = med_h_ui
	phil_heritage_ui = phil_h_ui
	logic_heritage_ui = logic_h_ui
	knowledge_book_ui = kb_ui
	
	if domain_ui:
		if not domain_ui.domain_selected.is_connected(_on_domain_selected):
			domain_ui.domain_selected.connect(_on_domain_selected)
		if not domain_ui.selection_cancelled.is_connected(_on_interaction_cancelled):
			domain_ui.selection_cancelled.connect(_on_interaction_cancelled)
			
	if quiz_manager:
		if not quiz_manager.quiz_completed.is_connected(_on_quiz_completed):
			quiz_manager.quiz_completed.connect(_on_quiz_completed)
		if not quiz_manager.quiz_cancelled.is_connected(_on_interaction_cancelled):
			quiz_manager.quiz_cancelled.connect(_on_interaction_cancelled)
			
	if dialogue_manager:
		if not dialogue_manager.dialogue_cancelled.is_connected(_on_interaction_cancelled):
			dialogue_manager.dialogue_cancelled.connect(_on_interaction_cancelled)

	if knowledge_book_ui:
		if not knowledge_book_ui.book_completed.is_connected(_on_knowledge_book_completed):
			knowledge_book_ui.book_completed.connect(_on_knowledge_book_completed)
		if not knowledge_book_ui.book_closed.is_connected(_on_interaction_cancelled):
			knowledge_book_ui.book_closed.connect(_on_interaction_cancelled)

	if math_heritage_ui:
		if not math_heritage_ui.heritage_completed.is_connected(_on_math_heritage_completed):
			math_heritage_ui.heritage_completed.connect(_on_math_heritage_completed)

	if astro_heritage_ui:
		if not astro_heritage_ui.heritage_completed.is_connected(_on_astro_heritage_completed):
			astro_heritage_ui.heritage_completed.connect(_on_astro_heritage_completed)

	if med_heritage_ui:
		if not med_heritage_ui.heritage_completed.is_connected(_on_med_heritage_completed):
			med_heritage_ui.heritage_completed.connect(_on_med_heritage_completed)

	if phil_heritage_ui:
		if not phil_heritage_ui.heritage_completed.is_connected(_on_phil_heritage_completed):
			phil_heritage_ui.heritage_completed.connect(_on_phil_heritage_completed)

	if logic_heritage_ui:
		if not logic_heritage_ui.heritage_completed.is_connected(_on_logic_heritage_completed):
			logic_heritage_ui.heritage_completed.connect(_on_logic_heritage_completed)

func _is_dev_mode() -> bool:
	var dev = get_node_or_null("/root/DevModeManager")
	return dev != null and dev.dev_mode_enabled

func is_teacher_unlocked() -> bool:
	if _is_dev_mode():
		return true
	if not GameState:
		return false
	return GameState.water_quest_completed or GameState.university_location_revealed or GameState.merchant_passed

func _on_merchant_state_changed() -> void:
	_update_ui_elements()

func _ready() -> void:
	if not voice_player:
		voice_player = get_node_or_null("VoiceAudioPlayer")
	if not voice_player:
		voice_player = AudioStreamPlayer.new()
		voice_player.name = "VoiceAudioPlayer"
		voice_player.bus = &"Master"
		add_child(voice_player)
		
	if interaction_area:
		if not interaction_area.body_entered.is_connected(_on_body_entered):
			interaction_area.body_entered.connect(_on_body_entered)
		if not interaction_area.body_exited.is_connected(_on_body_exited):
			interaction_area.body_exited.connect(_on_body_exited)
			
	if cooldown_timer and not cooldown_timer.timeout.is_connected(_on_cooldown_timeout):
		cooldown_timer.timeout.connect(_on_cooldown_timeout)
	
	if GameState:
		if GameState.teacher_admitted and not _is_dev_mode():
			current_state = State.ADMITTED
		if not GameState.merchant_state_changed.is_connected(_on_merchant_state_changed):
			GameState.merchant_state_changed.connect(_on_merchant_state_changed)
		if not GameState.quest_state_changed.is_connected(_on_merchant_state_changed):
			GameState.quest_state_changed.connect(_on_merchant_state_changed)

	_update_ui_elements()

# ==================================================
# AUDIO MANAGEMENT
# ==================================================
func _get_canonical_domain(d: String) -> String:
	var d_lower := d.to_lower()
	if "math" in d_lower:
		return "mathematics"
	elif "astro" in d_lower:
		return "astronomy"
	elif "med" in d_lower or "ayur" in d_lower:
		return "medicine"
	elif "phil" in d_lower or "logic" in d_lower or "darshan" in d_lower:
		return "philosophy"
	return d_lower

func _get_audio_stream(path: String) -> AudioStream:
	if _audio_cache.has(path):
		return _audio_cache[path]
		
	var stream: AudioStream = null
	if ResourceLoader.exists(path):
		var res = load(path)
		if res is AudioStream:
			stream = res
			
	if stream == null and FileAccess.file_exists(path):
		var bytes := FileAccess.get_file_as_bytes(path)
		if bytes.size() > 0:
			var mp3 := AudioStreamMP3.new()
			mp3.data = bytes
			stream = mp3
			
	if stream:
		_audio_cache[path] = stream
	else:
		push_warning("Teacher1: Could not load audio from: " + path)
		
	return stream

func _play_voice_audio(path: String, on_finished: Callable = Callable()) -> void:
	_stop_voice_audio()
	
	if path == "":
		if on_finished.is_valid():
			on_finished.call()
		return
		
	var stream := _get_audio_stream(path)
	if not stream or not voice_player:
		if on_finished.is_valid():
			on_finished.call()
		return
		
	# Pause background music when teacher starts speaking
	var audio_mgr = get_node_or_null("/root/AudioManager")
	if audio_mgr and audio_mgr.has_method("pause_bgm"):
		audio_mgr.pause_bgm()
		
	voice_player.stream = stream
	
	var conn_callable: Callable
	conn_callable = func():
		if voice_player.finished.is_connected(conn_callable):
			voice_player.finished.disconnect(conn_callable)
		# Resume background music when teacher finishes speaking
		var a_mgr = get_node_or_null("/root/AudioManager")
		if a_mgr and a_mgr.has_method("resume_bgm"):
			a_mgr.resume_bgm()
		if on_finished.is_valid():
			on_finished.call()
			
	voice_player.finished.connect(conn_callable)
	voice_player.play()

func _stop_voice_audio() -> void:
	if voice_player and voice_player.playing:
		voice_player.stop()
	# Resume background music whenever teacher audio is stopped
	var audio_mgr = get_node_or_null("/root/AudioManager")
	if audio_mgr and audio_mgr.has_method("resume_bgm"):
		audio_mgr.resume_bgm()

# ==================================================
# INTERACTION & DIALOGUE FLOW
# ==================================================
func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and (_is_dev_mode() or current_state == State.AVAILABLE) and is_teacher_unlocked():
		if event.is_action_pressed("interact"):
			get_viewport().set_input_as_handled()
			_start_teacher_interaction()

func _start_teacher_interaction() -> void:
	if not dialogue_manager:
		push_error("Silabhadra: DialogueManager not assigned.")
		return
		
	_stop_voice_audio()
	current_state = State.INTRO_DIALOGUE
	_update_ui_elements()
	
	var intro_seq: Array = [
		{"speaker": "Silabhadra", "text": "Choose the field you wish to study, and I shall share the knowledge preserved by the great scholars of Nalanda."}
	]
	
	dialogue_manager.start_dialogue(intro_seq, _on_intro_dialogue_finished)

func _on_intro_dialogue_finished() -> void:
	if not domain_ui:
		push_error("Silabhadra: DomainSelectionUI not assigned.")
		return
		
	current_state = State.DOMAIN_SELECTION
	_update_ui_elements()
	domain_ui.open_selection()

func _on_domain_selected(domain_id: String) -> void:
	if current_state != State.DOMAIN_SELECTION:
		return
		
	_selected_domain = domain_id
	GameState.selected_domain = domain_id
	
	var canon_domain := _get_canonical_domain(domain_id)
	current_state = State.HERITAGE
	_update_ui_elements()
	
	# Start domain teaching audio
	var audio_info: Dictionary = DOMAIN_AUDIO.get(canon_domain, {})
	var teaching_audio: String = audio_info.get("teaching", "")
	if teaching_audio != "":
		_play_voice_audio(teaching_audio)
		
	var teaching_seq: Array = []
	match canon_domain:
		"mathematics":
			teaching_seq = [
				{"speaker": "Silabhadra", "text": "At Nalanda, Gaṇita was more than numbers. It helped scholars understand trade, architecture, astronomy, and the measurement of time."},
				{"speaker": "Silabhadra", "text": "Before we begin your entrance test, study this ancient granth with great care—[u]all the admission questions in the quiz ahead will be based entirely on these teachings.[/u]"}
			]
		"astronomy":
			teaching_seq = [
				{"speaker": "Silabhadra", "text": "Jyotiṣa taught scholars to observe the heavens, measure time, understand seasons, and study the movements of the stars and planets."},
				{"speaker": "Silabhadra", "text": "Before we begin your entrance test, study this ancient granth with great care—[u]all the admission questions in the quiz ahead will be based entirely on these teachings.[/u]"}
			]
		"medicine":
			teaching_seq = [
				{"speaker": "Silabhadra", "text": "Āyurveda teaches that true health comes from balance. The body, mind, food, and nature must remain in harmony."},
				{"speaker": "Silabhadra", "text": "Before we begin your entrance test, study this ancient granth with great care—[u]all the admission questions in the quiz ahead will be based entirely on these teachings.[/u]"}
			]
		"philosophy":
			teaching_seq = [
				{"speaker": "Silabhadra", "text": "At Nalanda, wisdom was not accepted blindly. Scholars questioned, reasoned, debated, and searched for truth through knowledge and logic."},
				{"speaker": "Silabhadra", "text": "Before we begin your entrance test, study this ancient granth with great care—[u]all the admission questions in the quiz ahead will be based entirely on these teachings.[/u]"}
			]
		_:
			teaching_seq = [
				{"speaker": "Silabhadra", "text": "Before we begin your entrance test, study this ancient granth with great care—[u]all the admission questions in the quiz ahead will be based entirely on these teachings.[/u]"}
			]
			
	dialogue_manager.start_dialogue(teaching_seq, func(): _open_knowledge_book(_selected_domain))

func _open_knowledge_book(domain_id: String) -> void:
	if knowledge_book_ui and is_instance_valid(knowledge_book_ui) and knowledge_book_ui.has_method("open_knowledge_book"):
		knowledge_book_ui.open_knowledge_book(domain_id)
	else:
		KnowledgeBook.open_book(get_tree().root, domain_id, _on_knowledge_book_completed, _on_interaction_cancelled)

func _on_knowledge_book_completed(_domain_id: String) -> void:
	_stop_voice_audio()
	current_state = State.TRANSITION_DIALOGUE
	_update_ui_elements()
	
	var canon_domain := _get_canonical_domain(_selected_domain)
	var audio_info: Dictionary = DOMAIN_AUDIO.get(canon_domain, {})
	var transition_audio: String = audio_info.get("transition", "")
	
	if transition_audio != "":
		_play_voice_audio(transition_audio)
		
	var domain_transition_line := ""
	match canon_domain:
		"mathematics":
			domain_transition_line = "Now, let us see how well you have understood the mathematical wisdom of our ancient scholars."
		"astronomy":
			domain_transition_line = "Now, look to the heavens within your mind, and show me what you have learned."
		"medicine":
			domain_transition_line = "Now, let us test your knowledge of the ancient science of healing."
		"philosophy":
			domain_transition_line = "Now, use reason as your guide, and prove what you have learned."
		_:
			domain_transition_line = "Now, let us test what you have learned from the granth."
			
	var transition_seq: Array = [
		{"speaker": "Silabhadra", "text": domain_transition_line},
		{"speaker": "Silabhadra", "text": "You have studied the teachings. Now, answer carefully and show whether you are ready to walk the path of knowledge."}
	]
	
	dialogue_manager.start_dialogue(transition_seq, func():
		_stop_voice_audio()
		_start_domain_quiz()
	)

func _on_math_heritage_completed() -> void:
	_on_knowledge_book_completed("mathematics")

func _on_astro_heritage_completed() -> void:
	_on_knowledge_book_completed("astronomy")

func _on_med_heritage_completed() -> void:
	_on_knowledge_book_completed("medicine")

func _on_phil_heritage_completed() -> void:
	_on_knowledge_book_completed("philosophy")

func _on_logic_heritage_completed() -> void:
	_on_knowledge_book_completed("philosophy")

func _start_domain_quiz() -> void:
	if not quiz_manager:
		push_error("Silabhadra: QuizManager not assigned.")
		return
		
	current_state = State.QUIZ
	_update_ui_elements()
	quiz_manager.start_quiz(_selected_domain)

func _on_quiz_completed(score: int, _total: int, passed: bool) -> void:
	if current_state != State.QUIZ:
		return
		
	if passed:
		current_state = State.ADMITTED
		GameState.record_teacher_admission(_selected_domain, score)
		_update_ui_elements()
		
		var pass_seq: Array = [
			{"speaker": "Silabhadra", "text": "Well done. Knowledge grows when we learn, question, and apply what we have understood."},
			{"speaker": "Silabhadra", "text": "You are worthy of entering Nalanda Mahavihara. Proceed to the university gates—your journey as a scholar begins!"}
		]
		
		if dialogue_manager:
			dialogue_manager.start_dialogue(pass_seq, _on_pass_dialogue_finished)
		else:
			_on_pass_dialogue_finished()
	else:
		current_state = State.WAITING
		GameState.teacher_retry_available = false
		_update_ui_elements()
		
		var fail_msg: String = "You have much to learn. Reflect on what you have studied and try again."
		if _selected_domain.to_lower() == "mathematics" or _selected_domain.to_lower() == "math":
			fail_msg = "Not quite. Think back to the teachings of Aryabhata and Brahmagupta, and try again."
			
		var fail_seq: Array = [
			{"speaker": "Silabhadra", "text": fail_msg}
		]
		if dialogue_manager:
			dialogue_manager.start_dialogue(fail_seq, _on_fail_dialogue_finished)
		else:
			_on_fail_dialogue_finished()

func _on_interaction_cancelled() -> void:
	_stop_voice_audio()
	if current_state != State.ADMITTED and current_state != State.WAITING:
		current_state = State.AVAILABLE
		_selected_domain = ""
		_update_ui_elements()

func _on_pass_dialogue_finished() -> void:
	if _is_dev_mode():
		current_state = State.AVAILABLE
	GameState.unlock_player_movement()
	_update_ui_elements()

func _on_fail_dialogue_finished() -> void:
	if _is_dev_mode():
		current_state = State.AVAILABLE
		GameState.teacher_retry_available = true
	GameState.unlock_player_movement()
	_update_ui_elements()
	if cooldown_timer and not _is_dev_mode():
		cooldown_timer.start(15.0)

func _on_cooldown_timeout() -> void:
	if current_state != State.ADMITTED or _is_dev_mode():
		current_state = State.AVAILABLE
		GameState.teacher_retry_available = true
		_update_ui_elements()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = true
		_update_ui_elements()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = false
		_update_ui_elements()

func _update_ui_elements() -> void:
	var is_available: bool = _is_dev_mode() or (current_state == State.AVAILABLE and GameState.teacher_retry_available and is_teacher_unlocked())
	var show_indicator: bool = _player_in_range and is_available
	var show_press_e: bool = _player_in_range and is_available
	
	if indicator:
		indicator.visible = show_indicator
	if press_e_label:
		press_e_label.visible = show_press_e
