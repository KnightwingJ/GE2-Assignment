extends RigidBody3D

signal ball_resting(position: Vector3)

@export var resting_threshold:=0.2
@export var rest_time:=1

var rest_timer := 0.0

func _physics_process(delta):
	if linear_velocity.length() < resting_threshold:
		rest_timer += delta
		if rest_timer >= rest_time:
			emit_signal("ball_resting", global_transform.origin)
			queue_free()  # Optional: remove the ball after throwing
	else:
		rest_timer = 0.0
