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
@onready var edge_ray: RayCast2D = $Edge_Ray
@onready var jump_trick_area: Area2D = $Jump_Trick_Area
@onready var land_trick_area: Area2D = $Land_Trick_Area
var land_trick_area_ground_type: String
@onready var land_trick_added_points: int = 5
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

func _on_jump_trick_area_entered(area: Area2D) -> void:
	added_points = area.points_given
	current_jump_speed += area.jump_boost
	#floor_snap_length = 0.0


func _on_jump_trick_area_exited(area: Area2D) -> void:
	added_points = 0
	current_jump_speed = jump_speed
	#floor_snap_length = snap_length


func _on_land_trick_area_body_entered(body: Node2D) -> void:
	land_trick_area_ground_type = body.ground_type
	if land_trick_area_ground_type == "GROUND":
		added_points = land_trick_added_points
	if land_trick_area_ground_type == "RAIL":
		added_points = int(land_trick_added_points * 1.5)


func _on_land_trick_area_body_exited(body: Node2D) -> void:
	added_points = 0
