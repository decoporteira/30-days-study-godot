extends Control

var equipment_data
signal equipment_selected(equipment)

func setup(equipment):
	equipment_data = equipment
	$TextureButton.texture_normal = equipment.icon
	$Label.text = str(equipment.name)


func _on_texture_button_pressed() -> void:
	emit_signal("equipment_selected", equipment_data)
	print(equipment_data)
