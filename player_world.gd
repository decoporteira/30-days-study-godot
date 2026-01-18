extends CharacterBody2D


const SPEED = 200.0
var input_vector = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	#get input
	var dir = get_input_direction()
	velocity = dir * SPEED
	move_and_slide()
	
func get_input_direction() -> Vector2:
	if Input.is_action_pressed("ui_right"):
		return Vector2.RIGHT
	elif Input.is_action_pressed("ui_left"):
		return Vector2.LEFT
	elif Input.is_action_pressed("ui_down"):
		return Vector2.DOWN
	elif Input.is_action_pressed("ui_up"):
		return Vector2.UP

	return Vector2.ZERO
