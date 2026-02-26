extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const gravity = 400.0
var friction = 200
@onready var prev_velocity = Vector2(0,0)
@onready var acceleration:Vector2 = Vector2(0,0)

func _ready() -> void:
	floor_stop_on_slope = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if (!is_on_floor()):
		velocity += Vector2(0,gravity)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	#velocity = prev_velocity
	var normal = $RayCast2D.get_collision_normal()
	var direction = normal.orthogonal()
	if (direction.y < 0):
		direction = -1*direction 
	var angle_between = prev_velocity.angle_to(normal.orthogonal())
	acceleration = direction * gravity * delta
	#velocity.x = prev_velocity.length() * sin(angle_between) * delta
	#velocity.y = prev_velocity.length() * cos(angle_between) * delta 
	velocity += acceleration
	print(velocity)
	if (direction.y < 0):
		velocity.x += -direction.x * friction
	var surface_angle = normal.angle()*180/PI
	rotation_degrees = surface_angle+90
	prev_velocity = velocity
