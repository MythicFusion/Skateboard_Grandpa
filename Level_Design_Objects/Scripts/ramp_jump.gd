@tool
extends Node2D

@export_range(0.0, 1.0, 0.001) var sweet_spot_percent:float = 0.25
@export var length:float = 50.0
@export var height:float = 15.0

@export var points_given: int = 5
@export var jump_boost: float = -100.0

@export var sweet_spot_points_given: int = 10
@export var sweet_spot_jump_boost: float = -200.0

@onready var ramp_jump = $Ramp_Jump_Area
@onready var ramp_jump_collison = $Ramp_Jump_Area/CollisionShape2D
@onready var ramp_sweet_spot = $Ramp_Sweet_Spot_Area
@onready var ramp_sweet_spot_collision = $Ramp_Sweet_Spot_Area/CollisionShape2D

var ramp_jump_length:float
var ramp_sweet_spot_length:float

func _ready() -> void:
	ramp_jump.points_given = points_given
	ramp_jump.jump_boost = jump_boost
	ramp_sweet_spot.points_given = sweet_spot_points_given
	ramp_sweet_spot.jump_boost = sweet_spot_jump_boost

func _process(delta: float) -> void:
	ramp_jump_length = (1 - sweet_spot_percent) * length
	ramp_sweet_spot_length = sweet_spot_percent * length
	
	ramp_jump_collison.shape.size = Vector2(ramp_jump_length, height)
	ramp_sweet_spot_collision.shape.size = Vector2(ramp_sweet_spot_length, height)
	
	ramp_jump_collison.position.x = (ramp_jump_length * 0.5)
	ramp_sweet_spot_collision.position.x = ramp_jump_length + (ramp_sweet_spot_length * 0.5)
	
	
