extends CanvasLayer

func _ready() -> void:
	$Panel.hide()
	$Label.hide()
	player_global.game_over.connect(_on_game_over)

func _on_game_over():
	$Panel.show()
	$Label.text = "Game Over\nPoints: " + str(player_global.player_points)
	$Label.show()
	$UI.hide()
	get_tree().paused = true
