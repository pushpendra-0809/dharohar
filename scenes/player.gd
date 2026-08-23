extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
@export var speed: float = 100.0
var can_move: bool = true

# Map boundary limits to keep player strictly inside the village map
@export var min_x: float = 20.0
@export var max_x: float = 1132.0
@export var min_y: float = 30.0
@export var max_y: float = 620.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if GameState:
		GameState.player_movement_locked.connect(_on_movement_locked)

func _on_movement_locked(locked: bool) -> void:
	can_move = not locked
	if not can_move:
		direction = Vector2.ZERO
		velocity = Vector2.ZERO
		if animated_sprite:
			animated_sprite.stop()
			animated_sprite.frame = 0

func _physics_process(_delta: float) -> void:
	if not can_move:
		return

	var x_input := 0.0
	var y_input := 0.0

	if Input.is_action_pressed("right") or Input.is_action_pressed("ui_right"):
		x_input += 1.0
	if Input.is_action_pressed("left") or Input.is_action_pressed("ui_left"):
		x_input -= 1.0
	if Input.is_action_pressed("backward") or Input.is_action_pressed("ui_down"):
		y_input += 1.0
	if Input.is_action_pressed("forward") or Input.is_action_pressed("ui_up"):
		y_input -= 1.0

	direction = Vector2(x_input, y_input).normalized()
	velocity = direction * speed
	
	update_animation()
	move_and_slide()

	# Clamp player global position so player cannot walk outside the map edges
	global_position.x = clamp(global_position.x, min_x, max_x)
	global_position.y = clamp(global_position.y, min_y, max_y)

func update_animation() -> void:
	if not animated_sprite:
		return

	if direction != Vector2.ZERO:
		animated_sprite.play()
		if direction.x != 0:
			animated_sprite.animation = "left"
			animated_sprite.flip_h = (direction.x > 0)
		elif direction.y > 0:
			animated_sprite.animation = "forward"
		elif direction.y < 0:
			animated_sprite.animation = "back"
	else:
		animated_sprite.stop()
		animated_sprite.frame = 0
