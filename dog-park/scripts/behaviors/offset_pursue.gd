class_name OffsetPursue extends SteeringBehavior

@export var leader_boid:Boid
var leader_offset:Vector3
var target:Vector3
var world_target:Vector3
var projected:Vector3


func calculate_offset():
	leader_offset = boid.global_transform.origin - leader_boid.global_transform.origin
	leader_offset = (leader_offset) * leader_boid.global_transform.basis	

func _ready():
	boid = get_parent()		
	call_deferred("calculate_offset")		

func calculate():		
	world_target = leader_boid.global_transform * (leader_offset)
	var dist = boid.global_transform.origin.distance_to(world_target)
	var time = dist / boid.max_speed
	projected = world_target + leader_boid.velocity * time
	

	return boid.arrive_force(projected, 30)
