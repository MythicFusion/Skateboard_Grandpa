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

@onready var raycast: RayCast2D = $RayCast2D
@onready var state_machine = $state_machine

func _ready() -> void:
	floor_stop_on_slope = false
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
