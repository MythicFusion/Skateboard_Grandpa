extends State

@export var grind_state: State
@export var ground_state: State

func enter() -> void:
	parent.rotation_degrees = 0

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("trick"):
		player_global.update_points.emit(parent.added_points)
	return null

func process_physics(delta: float) -> State:
	if !parent.is_on_floor():
		parent.velocity.y += parent.gravity * delta
	else:
		parent.floor_snap_length = parent.snap_length
		return ground_state
	parent.move_and_slide()
	return null

func _to_string() -> String:
	return "Air State"
