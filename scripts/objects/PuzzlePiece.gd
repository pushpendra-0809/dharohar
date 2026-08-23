extends Area2D

@export var piece_id: int = 1

var _player_in_range: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var indicator_label: Label = $IndicatorLabel
@onready var press_e_label: Label = $PressELabel

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)
		
	set_piece_id(piece_id)
	_update_ui_elements()

func set_piece_id(id: int) -> void:
	piece_id = id
	var formatted_num: String = "%02d" % piece_id
	var tex_path: String = "res://assets/puzzles/teacher2/puzzle_pieces/seal_piece_" + formatted_num + ".png"
	if ResourceLoader.exists(tex_path):
		var tex: Texture2D = load(tex_path)
		if sprite and tex:
			sprite.texture = tex
			
	if indicator_label:
		indicator_label.text = "Sealing Piece #" + str(piece_id)

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range:
		if event.is_action_pressed("interact"):
			get_viewport().set_input_as_handled()
			_collect_piece()

func _collect_piece() -> void:
	if GameState:
		GameState.collect_puzzle_piece(piece_id)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = true
		_update_ui_elements()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body is CharacterBody2D:
		_player_in_range = false
		_update_ui_elements()

func _update_ui_elements() -> void:
	var show_prompt: bool = _player_in_range
	if indicator_label:
		indicator_label.visible = show_prompt
	if press_e_label:
		press_e_label.visible = show_prompt
