extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func open():
	show()
	get_tree().paused = true

func close():
	hide()
	get_tree().paused = false
	queue_free()


func _on_button_pressed() -> void:
	close()
