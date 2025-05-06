extends CharacterBody3D

@export var target:Node3D
@export var force:Vector3
@export var accel:Vector3

@export var mass:float = 1
@export var max_speed = 10

@export var stopping_distance:=1.0

@export var seek_enabled = false
@export var arrive_enabled = true
@export var arrive_target:Node3D
@export var slowing_distance = 20

@export var avoidance_enabled = true
@export var avoidance_radius:=5.0
@export var avoidance_force:=15.0

@export var banking:float = 0.2

@export var damping:float = 0.3

@export var player_steering_enabled:bool = true
@export var s_force:float = 10

@export var pursue_enabled = true
@export var pursue_target:CharacterBody3D

@export var wander_enable = true
@export var wander_circle_distance = 100.0
@export var wander_circle_radius = 50.0
@export var wander_angle = 0.0
var wander_angle_change = 0.5  # Radians per frame


@export var offset_pursue_enabled = false
@export var leader:CharacterBody3D
var offset:Vector3

@onready var bark:=$AudioStreamPlayer3D

func offset_pursue(leader):

	var world_target = leader.global_transform * offset
	
	var dist = (world_target - global_position).length()
	
	var time = dist / max_speed	
	var projected = world_target + (leader.velocity * time)

	# DebugDraw3D.draw_arrow(pursue_target.global_position, projected)
		
	return arrive(projected)

func wander() -> Vector3:
	var forward: Vector3
	if velocity.length() > 0.1:
		forward = velocity.normalized()
	else:
		forward = -transform.basis.z  # Default forward (facing direction in Godot 3D)

	var circle_center = forward * wander_circle_distance

	# Modify the wander angle slightly
	wander_angle += randf_range(-wander_angle_change, wander_angle_change)

	# Create displacement on the XZ plane
	var displacement = Vector3(
		cos(wander_angle),
		0.0,
		sin(wander_angle)
	) * wander_circle_radius

	return circle_center + displacement

func avoid_obstacles() -> Vector3:
	if not avoidance_enabled:
		return Vector3.ZERO

	var space_state = get_world_3d().direct_space_state
	var result_force = Vector3.ZERO

	var origin = global_transform.origin
	var directions = [
		transform.basis.z.normalized(),  # forward
		-transform.basis.z.normalized(), # backward
		transform.basis.x.normalized(),  # right
		-transform.basis.x.normalized()  # left
	]

	for dir in directions:
		var query = PhysicsRayQueryParameters3D.create(origin, origin + dir * avoidance_radius)
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if result and result.collider is CollisionObject3D:
			var avoid_dir = (origin - result.position).normalized()
			result_force += avoid_dir * avoidance_force

	return result_force


func pursue(pursue_target):
	var dist = (pursue_target.global_position - global_position).length()
	
	var time = dist / max_speed	
	var projected = pursue_target.global_position + (pursue_target.velocity * time)

	return seek(projected)
	
	


func arrive(target) -> Vector3:
	
	var stop_distance=5.0
	var to_target = target.position - global_position
	to_target.y=0
	var dist = to_target.length()
	if dist<=stop_distance:
		return -velocity
	var ramped = (dist / slowing_distance) * max_speed
	var clamped = min(ramped, max_speed)
	var desired = (to_target * clamped) / dist
	var steering = desired - velocity
	steering.y=0
	return steering


func seek(target) -> Vector3:
	var to_target:Vector3 = target - global_position
	if to_target.length()<1:
		seek_enabled=false
		bark.play()
		wander_enable=true
		return Vector3(0,0,0)
	var desired = to_target.normalized() * max_speed
	return desired - velocity
	
	

func _ready() -> void:
	
	if offset_pursue_enabled:
		offset = global_position - leader.global_position
	
	pass
	
func calculate():
	var f:Vector3 = Vector3.ZERO	
	if seek_enabled:
		f += seek(target.global_position)
	if arrive_enabled:
		f += arrive(arrive_target)
	if path_follow_enabled:
		f += follow_path()
	if pursue_enabled:
		f += pursue(pursue_target)
	if offset_pursue_enabled:
		f += offset_pursue(leader)
	if wander_enable:
		f +=wander()
	if avoidance_enabled:
		f+=avoid_obstacles()
	return f

@export var path:Path3D

@export var path_follow_enabled:bool = true
var path_index = 0
var looped = false
	
	
func follow_path():
	
	var p = path.global_transform * path.get_curve().get_point_position(path_index)
	var d = (p - global_position).length()
	if d < 2:
		path_index = (path_index + 1) % path.get_curve().point_count
	
	return seek(p)
	
func set_behaviours(behaviors:Dictionary) -> void:
	seek_enabled = behaviors.get("seek", false)
	arrive_enabled = behaviors.get("arrive", false)
	wander_enable = behaviors.get("wander", true)
	path_follow_enabled = behaviors.get("path", false)
	
	
func list_behaviour(behaviour:String):
	$Label3D.text=behaviour
func _process(delta: float) -> void:
	force = calculate()	
	force.y=0
	accel = force / mass	
	velocity = (velocity + accel * delta)
	
	if velocity.length() > 0:
		# Implement Banking as described:
		# https://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/
		var tempUp = transform.basis.y.lerp(Vector3.UP + (accel * banking), delta * 2.0)
		look_at(global_transform.origin - velocity)
		
		velocity = velocity.limit_length(max_speed)			
		velocity = velocity - (velocity * damping * delta)
		# look_at(global_position + velocity)
		# global_position += velocity * delta
		
	move_and_slide()	
	
	pass
