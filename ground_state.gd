extends State

@export var grind_state: State
@export var air_state: State

var prev_angle

func enter() -> void:
	prev_angle = 0
	parent.edge_ray.enabled = true

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("boost"):
		parent.velocity.x += parent.boost_speed
	if Input.is_action_just_pressed("jump"):
		parent.floor_snap_length = 0.0
		parent.velocity.y += parent.current_jump_speed
		player_global.update_points.emit(parent.added_points)
		return air_state
	return null

func process_physics(delta: float) -> State:
	if !parent.is_on_floor():
		return air_state
	var normal = parent.raycast.get_collision_normal()
	var direction = normal.orthogonal()
	if (direction.y < 0):
		direction = -1*direction 
	var angle_between = parent.prev_velocity.angle_to(normal.orthogonal())
	parent.acceleration.x = normal.x * parent.gravity * delta
	parent.acceleration.y = direction.y * parent.gravity * delta
	parent.velocity += parent.acceleration
	#if (direction.angle() > 0):
		#parent.velocity.x += -direction.x * parent.friction * delta
	
	var surface_angle = normal.angle()*180/PI
	parent.rotation_degrees = surface_angle+90
	parent.prev_velocity = parent.velocity
	prev_angle = parent.rotation_degrees
	if !parent.edge_ray.is_colliding() and parent.edge_ray.enabled:
		parent.edge_ray.enabled = false
		parent.floor_snap_length = 0.0
		parent.velocity.y -= 200.0
	parent.move_and_slide()
	return null

func _to_string() -> String:
	return "Ground State"
