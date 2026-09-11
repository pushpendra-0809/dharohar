extends Area2D

var _player_in_range: bool = false
var _is_transitioning: bool = false

@onready var indicator_label: Label = $IndicatorLabel
@onready var press_e_label: Label = $PressELabel

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)
		
	_update_ui_elements()

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and not _is_transitioning:
		if event.is_action_pressed("interact") or (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E):
			get_viewport().set_input_as_handled()
			_trigger_vihara_transition()

func _trigger_vihara_transition() -> void:
	if GameState and not GameState.vihara_unlocked:
		_show_locked_dialogue()
		return
		
	_is_transitioning = true
	_update_ui_elements()
	
	var arrival_seq: Array = [
		{"speaker": "Vihara Warden", "text": "This Vihara is the residential sanctuary of Nalanda's scholars."},
		{"speaker": "Vihara Warden", "text": "Education here extends beyond books. Within these living halls, scholars learn communal harmony, mindfulness, and discipline."}
	]
	
	if GameState:
		GameState.set_target_spawn(Vector2(576, 480), arrival_seq)
	get_tree().change_scene_to_file("res://scenes/innerVihar.tscn")

func _show_locked_dialogue() -> void:
	var d_mgr: Node = null
	var scene = get_tree().current_scene
	if scene and "dialogue_manager" in scene and scene.dialogue_manager:
		d_mgr = scene.dialogue_manager
	elif scene:
		for child in scene.get_children():
			if child is DialogueManager:
				d_mgr = child
				break
				
	var locked_seq: Array = [
		{"speaker": "Vihara Monastic Gate", "text": "The Vihara residential quarters are currently closed to new students."},
		{"speaker": "Vihara Monastic Gate", "text": "Complete the Dharmaganja Library investigation and assist the people of Nalanda to gain recommendation before entering."}
	]
	
	if d_mgr and d_mgr.has_method("start_dialogue"):
		d_mgr.start_dialogue(locked_seq, func():
			if GameState:
				GameState.unlock_player_movement()
			_update_ui_elements()
		)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = true
		_update_ui_elements()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = false
		_update_ui_elements()

func _update_ui_elements() -> void:
	var show_prompt: bool = _player_in_range and not _is_transitioning
	
	if indicator_label:
		indicator_label.visible = show_prompt
	if press_e_label:
		press_e_label.visible = show_prompt
		if GameState and not GameState.vihara_unlocked:
			press_e_label.text = "[Press E to Inspect Vihara Gate]"
		else:
			press_e_label.text = "[Press E to Enter Vihara]"
