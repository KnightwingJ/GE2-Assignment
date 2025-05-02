extends Node3D

@export var dog:PackedScene
@export var dog_count=5
@export var spawn_radius:float=20

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
		dog_instance.path_follow_enabled=true
		dog_instance.path=$Path3D
		
		dogs.append(dog_instance)
func _process(delta: float):
	if Input.is_action_just_pressed("whistle"):
		print("Whistle")
		for dog_instance in dogs:
			dog_instance.path_follow_enabled=false
			dog_instance.arrive_enabled=true
			dog_instance.arrive_target=$PlayerBody
