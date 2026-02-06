extends Control

var player
@onready var grid_inventory: GridContainer = $HBoxContainer/NinePatchRect/HBoxContainer/InventoryContent/ScrollContainer/Grid
@onready var grid_spell: GridContainer = $HBoxContainer/NinePatchRect/HBoxContainer/SpellContent/ScrollContainer/Grid
	
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	#hide()

func open():
	show()
	get_tree().paused = true
	update_ui()

func close():
	hide()
	get_tree().paused = false
	queue_free()

func _on_bt_exit_pressed() -> void:
	close()

func update_ui():
	$HBoxContainer/NinePatchRect/HBoxContainer/StatusContent/VBoxContainer2/HBoxContainer/VBoxContainer/Name.text = player.character_name
	$HBoxContainer/NinePatchRect/HBoxContainer/StatusContent/VBoxContainer2/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/Level.text = "Level: " + str(player.player_level)
	$HBoxContainer/NinePatchRect/HBoxContainer/StatusContent/VBoxContainer2/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/HP.text = "HP: " + str(player.health) + " / " + str(player.max_health)
	$HBoxContainer/NinePatchRect/HBoxContainer/StatusContent/VBoxContainer2/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/MP.text = "MP: " + str(player.mana) + " / " + str(player.max_mana)

func _on_bt_item_pressed() -> void:
	$HBoxContainer/NinePatchRect/HBoxContainer/StatusContent.hide()
	$HBoxContainer/NinePatchRect/HBoxContainer/SpellContent.hide()
	$HBoxContainer/NinePatchRect/HBoxContainer/InventoryContent.show()
	for child in grid_inventory.get_children():
		child.queue_free()
	var item_slot_scene = preload("res://Scenes/UI/ItemSlot.tscn")
	for item in player.inventory:
		var slot = item_slot_scene.instantiate()
		grid_inventory.add_child(slot)
		slot.setup(item)


func _on_bt_status_pressed() -> void:
	$HBoxContainer/NinePatchRect/HBoxContainer/InventoryContent.hide()
	$HBoxContainer/NinePatchRect/HBoxContainer/SpellContent.hide()
	$HBoxContainer/NinePatchRect/HBoxContainer/StatusContent.show()

func _on_bt_spell_pressed() -> void:
	$HBoxContainer/NinePatchRect/HBoxContainer/InventoryContent.hide()
	$HBoxContainer/NinePatchRect/HBoxContainer/StatusContent.hide()
	$HBoxContainer/NinePatchRect/HBoxContainer/SpellContent.show()
	for spell in player.spell:
		print(str(spell.name))
	for child in grid_spell.get_children():
		child.queue_free()
	var spell_slot_scene = preload("res://Scenes/UI/SpellSlot.tscn")
	for spell in player.spell:
		var slot = spell_slot_scene.instantiate()
		grid_spell.add_child(slot)
		slot.setup(spell)
