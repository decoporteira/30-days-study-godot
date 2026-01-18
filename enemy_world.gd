extends AnimatableBody2D

signal battle_started(enemy)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("battle_started", self)
		print("Bateu no inimigo") # Replace with function body.
