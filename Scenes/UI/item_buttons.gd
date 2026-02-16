extends Control
#item_slot.gd item e equipment estao dividindo o mesmo script para criar os botoes
var item_data
signal item_selected(item)

func setup(item):
	item_data = item
	$TextureButton.texture_normal = item.icon
	$Label.text = str(item.name)


func _on_texture_button_pressed() -> void:
	emit_signal("item_selected", item_data)
	print(item_data)
