extends Control

var player
	
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func open():
	show()
	get_tree().paused = true
	update_ui()

func close():
	hide()
	get_tree().paused = false
	queue_free()

func _on_button_pressed() -> void:
	close()

func update_ui():
	$HBoxContainer/NinePatchRect/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer/VBoxContainer/Name.text = player.character_name
	$HBoxContainer/NinePatchRect/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/Level.text = "Name: " + str(player.player_level)
	$HBoxContainer/NinePatchRect/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/HP.text = "HP: " + str(player.health) + " / " + str(player.max_health)
	$HBoxContainer/NinePatchRect/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/MP.text = "MP: " + str(player.mana) + " / " + str(player.max_mana)
