extends RichTextLabel


func show_damage(value: int):
	text = str(value)
	show()
	await get_tree().create_timer(1.0).timeout
	hide()
