extends Control

var item_data

func setup(item):
	item_data = item
	$TextureButton.texture_normal = item.icon
	$Label.text = str(item.name)
