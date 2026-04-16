extends Control

var current_points:int

func _ready() -> void:
	current_points = 0
	player_global.update_points.connect(on_update_points)
	$Point_Total.text = "Points: " + str(current_points)

func on_update_points(added_points) -> void:
	current_points = player_global.player_points
	$Point_Total.text = "Points: " + str(current_points)
