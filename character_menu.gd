extends Control

var player
@onready var grid_inventory: GridContainer = $HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/InventoryContent/ScrollContainer/Grid
@onready var grid_spell: GridContainer = $HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/SpellContent/ScrollContainer/Grid
@onready var grid_equipment: GridContainer = $HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent/ScrollContainer/Grid
@onready var label: Label = $HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/Label

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
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/StatusContent/VBoxContainer2/HBoxContainer/VBoxContainer/Name.text = player.character_name
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/StatusContent/VBoxContainer2/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/Level.text = "Level: " + str(player.player_level)
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/StatusContent/VBoxContainer2/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/HP.text = "HP: " + str(player.stats.health) + " / " + str(player.stats.max_health)
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/StatusContent/VBoxContainer2/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/MP.text = "MP: " + str(player.stats.mp) + " / " + str(player.stats.max_mp)

func _on_bt_item_pressed() -> void:
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/StatusContent.hide()
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/SpellContent.hide()
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent.hide()
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/InventoryContent.show()
	for child in grid_inventory.get_children():
		child.queue_free()
	var item_slot_scene = preload("res://Scenes/UI/ItemSlot.tscn")
	for item in player.inventory:
		var slot = item_slot_scene.instantiate()
		grid_inventory.add_child(slot)
		slot.setup(item)


func _on_bt_status_pressed() -> void:
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/InventoryContent.hide()
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/SpellContent.hide()
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent.hide()
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/StatusContent.show()

func _on_bt_spell_pressed() -> void:
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/InventoryContent.hide()
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/StatusContent.hide()
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent.hide()
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/SpellContent.show()
	
	for child in grid_spell.get_children():
		child.queue_free()
	var spell_slot_scene = preload("res://Scenes/UI/SpellSlot.tscn")
	for spell in player.spells:
		var slot = spell_slot_scene.instantiate()
		slot.spell_selected.connect(_on_spell_selected)
		grid_spell.add_child(slot)
		slot.setup(spell)
		
	

func _on_bt_equip_pressed() -> void:
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/InventoryContent.hide()
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/StatusContent.hide()
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/SpellContent.hide()
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent.show()
	for child in grid_equipment.get_children():
		child.queue_free()
	var equipment_slot_scene = preload("res://Scenes/UI/EquipmentSlot.tscn")
	for item in player.inventory:
		if item is WeaponItemResource:
			
			var slot = equipment_slot_scene.instantiate()
			grid_equipment.add_child(slot)
			slot.setup(item)
			
func _on_spell_selected(spell: Spell) -> void:
	if player.stats.mp < spell.mp_cost:
		print("nao tem mp suficiente")
		return
	if spell.name == "Heal":
		player.heal(spell.power)
		player.stats.mp -= spell.mp_cost
		print("Healed " + str(spell.power))
		_on_bt_status_pressed()

		update_ui()
		label.text = "The character regained " + str(spell.power) + " health points." 
		label.show()
		await get_tree().create_timer(2).timeout
		label.hide()
