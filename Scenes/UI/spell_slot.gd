extends Control

var spell_data
signal spell_selected(spell)

func setup(spell: Spell) -> void:
	
	spell_data = spell
	var is_disabled = spell_data.spell_context == Spell.SpellContext.BATTLE
	$TextureButton.texture_normal = spell.icon
	$Label.text = spell.name
	$TextureButton.disabled = is_disabled
	self.modulate = Color(0.5,0.5,0.5) if is_disabled else Color(1,1,1)
	$TextureButton.texture_hover = spell.icon
	$TextureButton.texture_pressed = spell.icon
	
func _on_texture_button_pressed() -> void:
	print("CLIQUE FUNCIONOU")
	emit_signal("spell_selected", spell_data)
	
