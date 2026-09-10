extends Area2D

@export var item_id: String = ""
@export var item_name: String = "Item"
@export var quest_id: String = ""
@export var prompt_text: String = "E"
@export var sprite_texture: Texture2D
@export var sprite_scale: Vector2 = Vector2(0.03, 0.03)

var _player_in_range: bool = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var indicator: Label = $InteractionIndicator
@onready var press_e_label: Label = $PressELabel
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	add_to_group("pickup_items")
	
	if sprite_texture and sprite_2d:
		sprite_2d.texture = sprite_texture
		sprite_2d.scale = sprite_scale
		
	if press_e_label:
		press_e_label.text = "E"
			
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)
		
	if GameState:
		if not GameState.quest_state_changed.is_connected(_on_quest_state_changed):
			GameState.quest_state_changed.connect(_on_quest_state_changed)
		if GameState.has_signal("player_movement_locked") and not GameState.player_movement_locked.is_connected(_on_movement_locked):
			GameState.player_movement_locked.connect(_on_movement_locked)
			
	_update_state()

func _on_movement_locked(_locked: bool) -> void:
	_update_ui_elements()

func _on_quest_state_changed() -> void:
	_update_state()

func _update_state() -> void:
	if not GameState or item_id == "":
		return
		
	var is_collected: bool = GameState.is_quest_item_collected(item_id)
	var is_complete: bool = GameState.is_side_quest_complete(quest_id)
	var is_active: bool = GameState.is_side_quest_active(quest_id)
	
	var dev = get_node_or_null("/root/DevModeManager")
	var is_dev: bool = dev != null and dev.dev_mode_enabled
	
	# Only show item if its specific NPC task/quest is currently ACTIVE!
	var should_be_visible: bool = (is_active or is_dev) and not is_collected and not is_complete
	
	visible = should_be_visible
	if collision_shape:
		collision_shape.disabled = not should_be_visible
		
	if not should_be_visible:
		_player_in_range = false
		
	_update_ui_elements()

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and _can_pickup():
		if event.is_action_pressed("interact") or (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E):
			get_viewport().set_input_as_handled()
			_collect()

func _can_pickup() -> bool:
	if not GameState or item_id == "":
		return false
	if GameState.is_movement_locked:
		return false
	if not visible:
		return false
	var dev = get_node_or_null("/root/DevModeManager")
	var is_dev: bool = dev != null and dev.dev_mode_enabled
	return (is_dev or GameState.is_side_quest_active(quest_id)) and not GameState.is_quest_item_collected(item_id)

func _collect() -> void:
	if GameState:
		GameState.collect_quest_item(quest_id, item_id)
	_update_state()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = true
		_update_ui_elements()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = false
		_update_ui_elements()

func _update_ui_elements() -> void:
	var in_dialogue: bool = GameState != null and GameState.is_movement_locked
	var show_prompt: bool = _player_in_range and _can_pickup() and visible and not in_dialogue
	if indicator:
		indicator.visible = false
	if press_e_label:
		press_e_label.visible = show_prompt
