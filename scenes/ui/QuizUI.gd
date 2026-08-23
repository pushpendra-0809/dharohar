class_name QuizUI
extends CanvasLayer

@onready var container: Control = $QuizBox
@onready var counter_label: Label = $QuizBox/CounterLabel
@onready var question_label: Label = $QuizBox/QuestionText
@onready var btn_a: Button = $QuizBox/OptionsContainer/OptionA
@onready var btn_b: Button = $QuizBox/OptionsContainer/OptionB
@onready var btn_c: Button = $QuizBox/OptionsContainer/OptionC
@onready var btn_d: Button = $QuizBox/OptionsContainer/OptionD

var _quiz_manager: QuizManager = null
var _option_buttons: Array[Button] = []

func setup(manager: QuizManager) -> void:
	_quiz_manager = manager
	if not _quiz_manager.quiz_started.is_connected(_on_quiz_started):
		_quiz_manager.quiz_started.connect(_on_quiz_started)
	if not _quiz_manager.question_changed.is_connected(_on_question_changed):
		_quiz_manager.question_changed.connect(_on_question_changed)
	if not _quiz_manager.quiz_completed.is_connected(_on_quiz_completed):
		_quiz_manager.quiz_completed.connect(_on_quiz_completed)
	if not _quiz_manager.quiz_cancelled.is_connected(_on_quiz_cancelled):
		_quiz_manager.quiz_cancelled.connect(_on_quiz_cancelled)
	
	_option_buttons = [btn_a, btn_b, btn_c, btn_d]
	
	for i in range(_option_buttons.size()):
		var idx := i
		if not _option_buttons[i].pressed.is_connected(_on_option_pressed.bind(idx)):
			_option_buttons[i].pressed.connect(_on_option_pressed.bind(idx))
		
	hide_quiz()

func hide_quiz() -> void:
	if container:
		container.visible = false

func _on_quiz_started(_domain_id: String) -> void:
	if container:
		container.visible = true

func _on_question_changed(current: int, total: int, q_data: Dictionary) -> void:
	_set_buttons_enabled(true)
	if counter_label:
		counter_label.text = "Question " + str(current) + "/" + str(total)
	if question_label:
		question_label.text = q_data.get("question", "")
	
	var options: Array = q_data.get("options", [])
	var prefixes: Array = ["A. ", "B. ", "C. ", "D. "]
	
	for i in range(_option_buttons.size()):
		if i < options.size():
			_option_buttons[i].visible = true
			_option_buttons[i].text = prefixes[i] + str(options[i])
		else:
			_option_buttons[i].visible = false

func _on_option_pressed(index: int) -> void:
	_set_buttons_enabled(false)
	if _quiz_manager and _quiz_manager.is_active():
		_quiz_manager.submit_answer(index)

func _on_quiz_completed(_score: int, _total: int, _passed: bool) -> void:
	hide_quiz()

func _on_quiz_cancelled() -> void:
	hide_quiz()

func _set_buttons_enabled(enabled: bool) -> void:
	for btn in _option_buttons:
		if btn:
			btn.disabled = not enabled
