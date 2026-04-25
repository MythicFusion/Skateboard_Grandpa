extends CharacterBody2D
class_name Player

@export var speed = 300.0
@export var jump_speed = -400.0
@export var boost_speed = 300
@export var max_speed = 450

@export var rail_speed = 200
@onready var increase_rail_speed = false
@export var gravity = 400.0
@export var friction = 90
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
@onready var land_trick_added_points: int = 7
@onready var state_machine = $state_machine

@onready var rolling_sfx = $Rolling_SFX
@onready var rail_grind_sfx = $Rial_Grind_SFX
@onready var current_sfx = $Rolling_SFX

func _ready() -> void:
	current_jump_speed = jump_speed
	floor_stop_on_slope = false
	state_machine.init(self)
	rolling_sfx.stream = preload("uid://gke0r64lwt5v")
	rail_grind_sfx.stream = preload("uid://opw080qtj0af")

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
		current_sfx.stop()
		current_sfx = rolling_sfx
		set_collision_mask_value(3, false)
	if land_trick_area_ground_type == "RAIL":
		increase_rail_speed = true
		added_points = int(land_trick_added_points * 1.5)
		set_collision_mask_value(3, true)
		current_sfx.stop()
		current_sfx = rail_grind_sfx


func _on_land_trick_area_body_exited(body: Node2D) -> void:
	land_trick_area_ground_type = body.ground_type
	increase_rail_speed = false
	added_points = 0
	return
