extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
@export var speed: float = 120.0
var can_move: bool = true

# Last facing direction tracking
var last_facing_anim: String = "forward"
var last_flip_h: bool = false

# Map boundary limits
@export var enable_clamp: bool = true
@export var min_x: float = 20.0
@export var max_x: float = 1132.0
@export var min_y: float = 30.0
@export var max_y: float = 620.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if GameState:
		if not GameState.player_movement_locked.is_connected(_on_movement_locked):
			GameState.player_movement_locked.connect(_on_movement_locked)
		if GameState.use_target_spawn:
			global_position = GameState.target_spawn_position
			GameState.use_target_spawn = false
		can_move = not GameState.is_movement_locked

func set_camera_limits(l_left: int, l_top: int, l_right: int, l_bottom: int) -> void:
	var cam: Camera2D = get_node_or_null("Camera2D")
	if cam:
		cam.limit_left = l_left
		cam.limit_top = l_top
		cam.limit_right = l_right
		cam.limit_bottom = l_bottom
		cam.limit_smoothed = true
		cam.position_smoothing_enabled = true

func set_camera_zoom(p_zoom: Vector2) -> void:
	var cam: Camera2D = get_node_or_null("Camera2D")
	if cam:
		cam.zoom = p_zoom

func set_map_limits(cam_left: int, cam_top: int, cam_right: int, cam_bottom: int, p_min_x: float, p_max_x: float, p_min_y: float, p_max_y: float) -> void:
	set_camera_limits(cam_left, cam_top, cam_right, cam_bottom)
	enable_clamp = true
	min_x = p_min_x
	max_x = p_max_x
	min_y = p_min_y
	max_y = p_max_y

func _on_movement_locked(locked: bool) -> void:
	can_move = not locked
	if not can_move:
		direction = Vector2.ZERO
		velocity = Vector2.ZERO
		if animated_sprite:
			animated_sprite.stop()
			animated_sprite.frame = 0

func _is_act_pressed(action_name: String) -> bool:
	return InputMap.has_action(action_name) and Input.is_action_pressed(action_name)

func _physics_process(_delta: float) -> void:
	if not can_move:
		return

	var x_input := 0.0
	var y_input := 0.0

	if _is_act_pressed("right") or Input.is_action_pressed("ui_right") or Input.is_physical_key_pressed(KEY_D):
		x_input += 1.0
	if _is_act_pressed("left") or Input.is_action_pressed("ui_left") or Input.is_physical_key_pressed(KEY_A):
		x_input -= 1.0
	if _is_act_pressed("backward") or _is_act_pressed("back") or _is_act_pressed("down") or Input.is_action_pressed("ui_down") or Input.is_physical_key_pressed(KEY_S):
		y_input += 1.0
	if _is_act_pressed("forward") or _is_act_pressed("up") or Input.is_action_pressed("ui_up") or Input.is_physical_key_pressed(KEY_W):
		y_input -= 1.0

	direction = Vector2(x_input, y_input).normalized()
	velocity = direction * speed
	
	update_animation()
	move_and_slide()

	if enable_clamp:
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
			last_facing_anim = "left"
			last_flip_h = animated_sprite.flip_h
		elif direction.y > 0:
			if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("forward"):
				animated_sprite.animation = "forward"
				last_facing_anim = "forward"
				last_flip_h = false
			elif animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("back"):
				animated_sprite.animation = "back"
				last_facing_anim = "back"
				last_flip_h = false
		elif direction.y < 0:
			if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("back"):
				animated_sprite.animation = "back"
				last_facing_anim = "back"
				last_flip_h = false
			elif animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("forward"):
				animated_sprite.animation = "forward"
				last_facing_anim = "forward"
				last_flip_h = false
	else:
		animated_sprite.stop()
		animated_sprite.animation = last_facing_anim
		animated_sprite.flip_h = last_flip_h
		animated_sprite.frame = 0
