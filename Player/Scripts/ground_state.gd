extends State

@export var grind_state: State
@export var air_state: State

var prev_angle

func enter() -> void:
	prev_angle = 0
	parent.edge_ray.enabled = true

func process_input(event: InputEvent) -> State:
	#Boost Action
	if Input.is_action_just_pressed("boost"):
		if parent.velocity.length() < parent.max_speed:
			parent.velocity.x += parent.boost_speed
		if parent.velocity.length() > parent.max_speed:
			parent.velocity.x = parent.max_speed
		
	#Jump Action
	if Input.is_action_just_pressed("jump"):
		parent.floor_snap_length = 0.0
		parent.velocity.y += parent.current_jump_speed
		if parent.jump_trick_area.has_overlapping_areas():
			player_global.update_points.emit(parent.added_points)
		return air_state
	return null

func process_physics(delta: float) -> State:
	if !parent.is_on_floor():
		return air_state
	
	if (!parent.current_sfx.playing and abs(parent.velocity.x) != 0):
		parent.current_sfx.play()
	elif (abs(parent.velocity.x) == 0):
		parent.current_sfx.stop()
	
	#Gets the current slope's direction vector 
	var normal = parent.raycast.get_collision_normal()
	var direction = normal.orthogonal()
	
	#Makes sure the slope's direction vector always points down along the slope
	if (direction.y < 0):
		direction = -1*direction 
	var angle_between = parent.prev_velocity.angle_to(normal.orthogonal())
	
	#Pushes the player depending on the slope direction and their current speed
	parent.acceleration.x = normal.x * parent.gravity * delta
	parent.acceleration.y = direction.y * parent.gravity * delta
	parent.velocity += parent.acceleration
	if parent.velocity.x > 0:
		parent.velocity.x += -parent.friction * delta
	elif parent.velocity.x < 0:
		parent.velocity.x += parent.friction * delta
	#if (direction.angle() > 0):
		#parent.velocity.x += -direction.x * parent.friction * delta
	
	if parent.increase_rail_speed and parent.velocity.y >= 0:
		parent.velocity.x = parent.velocity.x * 0.25 + parent.rail_speed
	
	#Makes sure the player is always oriented along the slope
	var surface_angle = normal.angle()*180/PI
	parent.rotation_degrees = surface_angle+90
	parent.prev_velocity = parent.velocity
	prev_angle = parent.rotation_degrees
	
	#Allows the player to properly slide off ramps when not jumping
	#if !parent.edge_ray.is_colliding() and parent.edge_ray.enabled and parent.velocity.y < 0:
		#parent.edge_ray.enabled = false
		#parent.floor_snap_length = 0.0
		#parent.velocity.y += -110.0
	parent.move_and_slide()
	return null

func _to_string() -> String:
	return "Ground State"
