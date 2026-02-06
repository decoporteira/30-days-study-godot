extends Control

var spell_data

func setup(spell):
	spell_data = spell
	$TextureButton.texture_normal = spell.icon
	$Label.text = str(spell.name)
