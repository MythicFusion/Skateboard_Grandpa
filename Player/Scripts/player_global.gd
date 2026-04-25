extends Node
signal update_points(added_points)
signal game_over()
var player_points:int

func _ready() -> void:
	player_points = 0
	update_points.connect(on_update_points)
	
func on_update_points(added_points):
	player_points += added_points
