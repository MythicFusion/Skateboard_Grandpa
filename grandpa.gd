extends CharacterBody2D
class_name Player

@export var speed = 300.0
@export var jump_speed = -400.0
@export var boost_speed = 300
@export var gravity = 400.0
@export var friction = 200
@onready var snap_length = floor_snap_length
@onready var prev_velocity = Vector2(0,0)
@onready var acceleration:Vector2 = Vector2(0,0)

@onready var added_points: int = 0
var current_jump_speed: float

@onready var raycast: RayCast2D = $RayCast2D
@onready var state_machine = $state_machine

func _ready() -> void:
	current_jump_speed = jump_speed
	floor_stop_on_slope = false
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _on_area_2d_area_entered(area: Area2D) -> void:
	added_points = area.points_given
	current_jump_speed += area.jump_boost


func _on_area_2d_area_exited(area: Area2D) -> void:
	added_points = 0
	current_jump_speed += jump_speed
