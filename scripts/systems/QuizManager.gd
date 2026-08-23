class_name QuizManager
extends Node

signal quiz_started(domain_id: String)
signal question_changed(current_index: int, total_questions: int, question_data: Dictionary)
signal quiz_completed(score: int, total_questions: int, passed: bool)

var _domain_id: String = ""
var _questions: Array = []
var _current_index: int = 0
var _score: int = 0
var _is_active: bool = false
var _answering_locked: bool = false

func is_active() -> bool:
	return _is_active

func start_quiz(domain_id: String) -> void:
	_domain_id = domain_id
	_questions = QuestionData.get_questions(domain_id)
	
	if _questions.is_empty():
		push_error("QuizManager: No questions found for domain: " + domain_id)
		return

	_current_index = 0
	_score = 0
	_is_active = true
	_answering_locked = false
	
	GameState.lock_player_movement()
	quiz_started.emit(domain_id)
	_emit_current_question()

func submit_answer(option_index: int) -> void:
	if not _is_active or _answering_locked:
		return

	_answering_locked = true

	var q: Dictionary = _questions[_current_index]
	var correct_idx: int = int(q.get("answer", 0))

	if option_index == correct_idx:
		_score += 1

	_current_index += 1

	if _current_index < _questions.size():
		_emit_current_question()
		_answering_locked = false
	else:
		_finish_quiz()

func _emit_current_question() -> void:
	if _current_index < _questions.size():
		var q: Dictionary = _questions[_current_index]
		question_changed.emit(_current_index + 1, _questions.size(), q)

func _finish_quiz() -> void:
	_is_active = false
	_answering_locked = false
	var passed: bool = (_score >= 3)
	quiz_completed.emit(_score, _questions.size(), passed)
