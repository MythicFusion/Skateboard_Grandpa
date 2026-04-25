extends Node

@export var starting_state:State
var current_state:State

func init(parent: Player) -> void:
	for child in get_children():
		child.parent = parent
	
	change_state(starting_state)

func change_state(next_state: State) -> void:
	if current_state:
		current_state.exit()

	current_state = next_state
	current_state.enter()

func process_input(event: InputEvent) -> void:
	var next_state = current_state.process_input(event)
	if next_state:
		change_state(next_state)

func process_physics(delta: float) -> void:
	var next_state = current_state.process_physics(delta)
	if next_state:
		change_state(next_state)

func process_frame(delta: float) -> void:
	var next_state = current_state.process_frame(delta)
	if next_state:
		change_state(next_state)
