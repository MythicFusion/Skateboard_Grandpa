extends Area2D

func _on_body_entered(body: Node2D) -> void:
	player_global.game_over.emit()
