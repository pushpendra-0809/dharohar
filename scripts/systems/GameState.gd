extends Node

signal player_movement_locked(locked: bool)
signal teacher_state_changed()
signal merchant_state_changed()

# Teacher state
var selected_domain: String = ""
var teacher_quiz_score: int = 0
var teacher_quiz_completed: bool = false
var teacher_admitted: bool = false
var teacher_retry_available: bool = true

# Merchant state
var merchant_quiz_score: int = 0
var merchant_quiz_completed: bool = false
var merchant_passed: bool = false
var merchant_retry_available: bool = true
var nalanda_location_revealed: bool = false

func lock_player_movement() -> void:
	player_movement_locked.emit(true)

func unlock_player_movement() -> void:
	player_movement_locked.emit(false)

func reset_teacher_quiz_state() -> void:
	teacher_quiz_score = 0

func record_teacher_admission(domain: String, score: int) -> void:
	selected_domain = domain
	teacher_quiz_score = score
	teacher_quiz_completed = true
	teacher_admitted = true
	teacher_state_changed.emit()

func record_merchant_result(score: int, passed: bool) -> void:
	merchant_quiz_score = score
	merchant_quiz_completed = true
	merchant_passed = passed
	if passed:
		nalanda_location_revealed = true
	merchant_state_changed.emit()
