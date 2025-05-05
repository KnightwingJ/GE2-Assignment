extends Node3D

@export var dog:PackedScene
@export var dog_count=5
@export var spawn_radius:float=20
@export var ball:PackedScene

@onready var heeled=false
var dog_instance
var dogs=[]

func _ready() -> void:
	for i in range(dog_count):
		dog_instance = dog.instantiate()
		var random_position = Vector3(
				randf_range(-spawn_radius,spawn_radius),
				0,
				randf_range(-spawn_radius,spawn_radius)
				)
		dog_instance.position=position+random_position
		add_child(dog_instance)
		#dog_instance.path_follow_enabled=true
		#dog_instance.path=$Path3D
		
		dogs.append(dog_instance)
func _process(delta: float):
	if Input.is_action_just_pressed("whistle"):
		print("Whistle")
		heeled=!heeled
		if heeled:
			heel()
		if not heeled:
			run()
	if Input.is_action_just_pressed("go"):
		go()
	if Input.is_action_just_pressed("throw"):
		throw_ball()
func heel():
	for dog_instance in dogs:
			dog_instance.path_follow_enabled=false
			dog_instance.wander_enable=false
			dog_instance.seek_enabled = false
			dog_instance.arrive_enabled=true
			dog_instance.arrive_target=$PlayerBody

func run():
	for dog_instance in dogs:
			dog_instance.wander_enable=true
			dog_instance.arrive_enabled=false
			dog_instance.seek_enabled = false

func go():
	for dog_instance in dogs:
		dog_instance.wander_enable=false
		dog_instance.arrive_enabled=false
		dog_instance.seek_enabled = false
		dog_instance.path_follow_enabled=true
		dog_instance.path=$Path3D
		
func throw_ball():
	if not ball:
		return
	var player = $PlayerBody
	var ball_instance = ball.instantiate()
	get_tree().current_scene.add_child(ball_instance)
	
	ball_instance.global_transform.origin=player.global_transform.origin+Vector3(0.02,0.5,0)
	
	var direction = -player.global_transform.basis.z.normalized()
	var throw_force=20.0
	
	ball_instance.linear_velocity=direction*throw_force
	ball_instance.connect("ball_resting",Callable(self,"_on_ball_resting"))
	
func _on_ball_resting(position: Vector3):
	print("Ball has come to rest at: ", position)

	# Create a dummy target node at the ball's resting position
	var temp_target = Node3D.new()
	temp_target.global_position = position
	add_child(temp_target)  # Add it to the scene so it's valid

	for dog_instance in dogs:
		dog_instance.wander_enable = false
		dog_instance.arrive_enabled = false
		dog_instance.path_follow_enabled = false
		dog_instance.seek_enabled = true
		dog_instance.target = temp_target
