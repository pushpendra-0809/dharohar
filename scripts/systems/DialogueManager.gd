class_name DialogueManager
extends Node

signal dialogue_started
signal dialogue_step_changed(speaker_name: String, text: String)
signal dialogue_ended

var _sequence: Array = []
var _current_index: int = -1
var _on_complete_callback: Callable = Callable()
var _is_active: bool = false

func is_active() -> bool:
	return _is_active

func start_dialogue(sequence: Array, on_complete: Callable = Callable()) -> void:
	if sequence.is_empty():
		return
	
	_sequence = sequence.duplicate()
	_current_index = 0
	_on_complete_callback = on_complete
	_is_active = true
	
	GameState.lock_player_movement()
	dialogue_started.emit()
	_show_current_step()

func advance_dialogue() -> void:
	if not _is_active:
		return
		
	_current_index += 1
	if _current_index < _sequence.size():
		_show_current_step()
	else:
		close_dialogue()

func close_dialogue() -> void:
	if not _is_active:
		return
		
	_is_active = false
	var cb := _on_complete_callback
	_on_complete_callback = Callable()
	
	dialogue_ended.emit()
	
	if cb.is_valid():
		cb.call()

func _show_current_step() -> void:
	if _current_index >= 0 and _current_index < _sequence.size():
		var step: Dictionary = _sequence[_current_index]
		var speaker: String = step.get("speaker", "???")
		var text: String = step.get("text", "")
		dialogue_step_changed.emit(speaker, text)
