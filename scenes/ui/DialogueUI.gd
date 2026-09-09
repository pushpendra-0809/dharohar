class_name DialogueUI
extends CanvasLayer

@onready var dialogue_box: Control = $DialogueBox
@onready var speaker_label: Label = $DialogueBox/SpeakerName
@onready var text_label: Control = $DialogueBox/DialogueText
@onready var continue_label: Label = $DialogueBox/ContinueLabel

var _dialogue_manager: DialogueManager = null

func setup(manager: DialogueManager) -> void:
	_dialogue_manager = manager
	if not _dialogue_manager.dialogue_started.is_connected(_on_dialogue_started):
		_dialogue_manager.dialogue_started.connect(_on_dialogue_started)
	if not _dialogue_manager.dialogue_step_changed.is_connected(_on_dialogue_step_changed):
		_dialogue_manager.dialogue_step_changed.connect(_on_dialogue_step_changed)
	if not _dialogue_manager.dialogue_ended.is_connected(_on_dialogue_ended):
		_dialogue_manager.dialogue_ended.connect(_on_dialogue_ended)
	hide_dialogue()

func _unhandled_input(event: InputEvent) -> void:
	if dialogue_box and dialogue_box.visible and _dialogue_manager and _dialogue_manager.is_active():
		if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
			get_viewport().set_input_as_handled()
			_dialogue_manager.advance_dialogue()

func _on_dialogue_started() -> void:
	if dialogue_box:
		dialogue_box.visible = true

func _on_dialogue_step_changed(speaker: String, text: String) -> void:
	if speaker_label:
		speaker_label.text = speaker
	if text_label:
		text_label.text = text
	if continue_label:
		continue_label.text = "[Press E to Continue]"

func _on_dialogue_ended() -> void:
	hide_dialogue()

func hide_dialogue() -> void:
	if dialogue_box:
		dialogue_box.visible = false
