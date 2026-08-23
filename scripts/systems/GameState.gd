extends Node

signal player_movement_locked(locked: bool)
signal teacher_state_changed()
signal merchant_state_changed()
signal quest_state_changed()

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

# Water Quest state
var merchant_water_quest_started: bool = false
var water_collected: bool = false
var water_quest_completed: bool = false
var university_location_revealed: bool = false
var has_water: bool = false

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
		university_location_revealed = true
		nalanda_location_revealed = true
	merchant_state_changed.emit()
	quest_state_changed.emit()

func start_water_quest() -> void:
	merchant_water_quest_started = true
	water_collected = false
	has_water = false
	water_quest_completed = false
	merchant_state_changed.emit()
	quest_state_changed.emit()

func collect_water() -> void:
	water_collected = true
	has_water = true
	quest_state_changed.emit()

func complete_water_quest() -> void:
	water_quest_completed = true
	merchant_water_quest_started = false
	has_water = false
	water_collected = true
	university_location_revealed = true
	nalanda_location_revealed = true
	merchant_passed = true
	merchant_state_changed.emit()
	quest_state_changed.emit()
