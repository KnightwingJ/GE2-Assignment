extends CharacterBody3D

# Sensitivity
@export var mouse_sensitivity := 0.1
@export var move_speed := 5.0
@export var sprint_multiplier := 1.5
@export var jump_velocity := 4.5
@export var gravity := 9.8


var pitch := 0.0
var velocity_y := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		# Rotate character (yaw)
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))

		# Rotate head (pitch)
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, -90, 90)

	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	var input_dir = Vector3.ZERO

	var forward = -transform.basis.z
	var right = transform.basis.x

	if Input.is_action_pressed("move_forward"):
		input_dir += forward
	if Input.is_action_pressed("move_back"):
		input_dir -= forward
	if Input.is_action_pressed("move_right"):
		input_dir += right
	if Input.is_action_pressed("move_left"):
		input_dir -= right

	input_dir = input_dir.normalized()

	var speed = move_speed
	if Input.is_action_pressed("sprint"):
		speed *= sprint_multiplier

	var horizontal_velocity = input_dir * speed

	# Apply gravity and jumping
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
		else:
			velocity.y = 0.0

	# Combine vertical and horizontal velocity
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z

	move_and_slide()
