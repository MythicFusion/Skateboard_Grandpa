@tool
extends Node2D

@export_range(0.0, 1.0, 0.001) var sweet_spot_percent:float = 0.25
@export var length:float = 50.0
@export var height:float = 15.0

@onready var ramp_jump = $Ramp_Jump_Area/CollisionShape2D
@onready var ramp_sweet_spot = $Ramp_Sweet_Spot_Area/CollisionShape2D

var ramp_jump_length:float
var ramp_sweet_spot_length:float

func _process(delta: float) -> void:
	ramp_jump_length = (1 - sweet_spot_percent) * length
	ramp_sweet_spot_length = sweet_spot_percent * length
	
	ramp_jump.shape.size = Vector2(ramp_jump_length, height)
	ramp_sweet_spot.shape.size = Vector2(ramp_sweet_spot_length, height)
	
	ramp_jump.position.x = (ramp_jump_length * 0.5)
	ramp_sweet_spot.position.x = ramp_jump_length + (ramp_sweet_spot_length * 0.5)
	
	
