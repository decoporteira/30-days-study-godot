extends Control

var player
@onready var grid_inventory: GridContainer = $HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/InventoryContent/ScrollContainer/Grid
@onready var grid_spell: GridContainer = $HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/SpellContent/ScrollContainer/Grid
@onready var grid_equipment: GridContainer = $HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent/VBoxContainer/ScrollContainer/Grid
@onready var label: Label = $HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/Label
@onready var status_content: MarginContainer = $HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/StatusContent
@onready var spell_content: MarginContainer = $HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/SpellContent
@onready var equipment_content: MarginContainer = $HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent
@onready var inventory_content: MarginContainer = $HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/InventoryContent
@onready var holder = player.equipment_holder
@onready var equip_sfx: AudioStreamPlayer = $EquipSFX

var weapon_slot
#var head_slot = holder.slots[EquipmentHolder.SlotType.HEAD]
var body_slot
#var legs_slot = holder.slots[EquipmentHolder.SlotType.LEGS]
var accessory_slot

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	status_content.show()
	spell_content.hide()
	equipment_content.hide()
	inventory_content.hide()
	
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
	weapon_slot = holder.slots[EquipmentHolder.SlotType.HAND]
	#var head_slot = holder.slots[EquipmentHolder.SlotType.HEAD]
	body_slot = holder.slots[EquipmentHolder.SlotType.BODY]
	#var legs_slot = holder.slots[EquipmentHolder.SlotType.LEGS]
	accessory_slot = holder.slots[EquipmentHolder.SlotType.ACCESSORY]

	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent/VBoxContainer/Control/HBoxContainer/Equipment/Weapon.text = weapon_slot.equipped_item.name if weapon_slot.equipped_item else "Nenhuma arma"
	#$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent/VBoxContainer/Control/HBoxContainer/Equipment/Armor.text = head_slot.equipped_item.item_name if head_slot.equipped_item else "Nenhum capacete"
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent/VBoxContainer/Control/HBoxContainer/Equipment/Armor.text = body_slot.equipped_item.name if body_slot.equipped_item else "Nenhuma armadura"
	#$LegsLabel.text = legs_slot.equipped_item.item_name if legs_slot.equipped_item else "Nenhuma perna"
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent/VBoxContainer/Control/HBoxContainer/Equipment/Accessory.text = accessory_slot.equipped_item.name if accessory_slot.equipped_item else "Nenhum acessório"
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/StatusContent/VBoxContainer2/HBoxContainer/VBoxContainer/Name.text = player.character_name
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/StatusContent/VBoxContainer2/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/Level.text = "Level: " + str(player.player_level)
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/StatusContent/VBoxContainer2/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/HP.text = "HP: " + str(player.stats.health) + " / " + str(player.stats.get_max_health())
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/StatusContent/VBoxContainer2/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/MP.text = "MP: " + str(player.stats.mana) + " / " + str(player.stats.get_max_mana())

func _on_bt_item_pressed() -> void:
	status_content.hide()
	spell_content.hide()
	equipment_content.hide()
	inventory_content.show()
	
	for child in grid_inventory.get_children():
		child.queue_free()
	var item_slot_scene = preload("res://Scenes/UI/ItemButtons.tscn")
	for item in player.inventory:
		var slot = item_slot_scene.instantiate()
		slot.item_selected.connect(_on_item_selected)
		grid_inventory.add_child(slot)
		slot.setup(item)


func _on_bt_status_pressed() -> void:
	status_content.show()
	spell_content.hide()
	equipment_content.hide()
	inventory_content.hide()

func _on_bt_spell_pressed() -> void:
	status_content.hide()
	spell_content.show()
	equipment_content.hide()
	inventory_content.hide()
	
	for child in grid_spell.get_children():
		child.queue_free()
	var spell_slot_scene = preload("res://Scenes/UI/SpellSlot.tscn")
	for spell in player.spells:
		var slot = spell_slot_scene.instantiate()
		slot.spell_selected.connect(_on_spell_selected)
		grid_spell.add_child(slot)
		slot.setup(spell)
		

func _on_bt_equip_pressed() -> void:
	status_content.hide()
	spell_content.hide()
	equipment_content.show()
	inventory_content.hide()
	
	var status_name = $HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent/VBoxContainer/Control/HBoxContainer/Status/Name
	var status_attack = $HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent/VBoxContainer/Control/HBoxContainer/Status/Attack
	var status_defense = $HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent/VBoxContainer/Control/HBoxContainer/Status/Defense
	var status_inteligence = $HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent/VBoxContainer/Control/HBoxContainer/Status/Inteligence
	var status_speed = $HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent/VBoxContainer/Control/HBoxContainer/Status/Speed
	
	weapon_slot = holder.slots[EquipmentHolder.SlotType.HAND]
	#var head_slot = holder.slots[EquipmentHolder.SlotType.HEAD]
	body_slot = holder.slots[EquipmentHolder.SlotType.BODY]
	#var legs_slot = holder.slots[EquipmentHolder.SlotType.LEGS]
	accessory_slot = holder.slots[EquipmentHolder.SlotType.ACCESSORY]

	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent/VBoxContainer/Control/HBoxContainer/Equipment/Weapon.text = weapon_slot.equipped_item.name if weapon_slot.equipped_item else "Nenhuma arma"
	#$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent/VBoxContainer/Control/HBoxContainer/Equipment/Armor.text = head_slot.equipped_item.item_name if head_slot.equipped_item else "Nenhum capacete"
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent/VBoxContainer/Control/HBoxContainer/Equipment/Armor.text = body_slot.equipped_item.name if body_slot.equipped_item else "Nenhuma armadura"
	#$LegsLabel.text = legs_slot.equipped_item.item_name if legs_slot.equipped_item else "Nenhuma perna"
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/EquipmentContent/VBoxContainer/Control/HBoxContainer/Equipment/Accessory.text = accessory_slot.equipped_item.name if accessory_slot.equipped_item else "Nenhum acessório"
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/StatusContent/VBoxContainer2/HBoxContainer/VBoxContainer/Name.text = player.character_name
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/StatusContent/VBoxContainer2/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/Level.text = "Level: " + str(player.player_level)
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/StatusContent/VBoxContainer2/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/HP.text = "HP: " + str(player.stats.health) + " / " + str(player.stats.get_max_health())
	$HBoxContainer/NinePatchRect/HBoxContainer/VBoxContainer/StatusContent/VBoxContainer2/HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/MP.text = "MP: " + str(player.stats.mana) + " / " + str(player.stats.get_max_mana())

	status_name.text = player.name
	status_attack.text = str(player.stats.get_attack())
	status_defense.text = str(player.stats.get_defense())
	status_inteligence.text = str(player.stats.get_inteligence())
	status_speed.text = str(player.stats.get_speed())
	
	for child in grid_equipment.get_children():
		child.queue_free()
	var equipment_slot_scene = preload("res://Scenes/UI/EquipmentButtons.tscn")
	for equipment in player.inventory:
		if equipment is WeaponItemResource or equipment is ArmorItemResource:
			
			var slot = equipment_slot_scene.instantiate()
			slot.equipment_selected.connect(_on_equipment_selected)
			grid_equipment.add_child(slot)
			slot.setup(equipment)
			
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
		
func _on_item_selected(item) -> void:
	print("usou um item " + item.name)
	use_item_in_menu(item)
	
func use_item_in_menu(item: ItemResource) -> void:
	if item is ConsumableItemResource:
		player.heal(item.heal_amount)
		player.inventory.erase(item)
		update_ui()
		_on_bt_item_pressed()
		label.text = "The character regained " + str(item.heal_amount) + " health points." 
		label.show()
		await get_tree().create_timer(2).timeout
		label.hide()
	elif item is WeaponItemResource:
		label.text = "You cant use it here." 
		label.show()
		await get_tree().create_timer(2).timeout
		label.hide()
	
func _on_bt_save_pressed() -> void:
	SaveManager.save_game(player)
	label.text = "The game was successfully saved." 
	label.show()
	await get_tree().create_timer(2).timeout
	label.hide()
	
func _on_bt_load_pressed() -> void:
	SaveManager.load_game(player)
	update_ui()
	label.text = "The game was successfully loaded." 
	label.show()
	await get_tree().create_timer(2).timeout
	label.hide()
	close()
	
func _on_equipment_selected(item: ItemResource) -> void:
	player.equip_item(item)
	equip_sfx.play()
	_on_bt_equip_pressed() # atualiza tela
	label.text = item.name + " equipped!"
	label.show()
	
	await get_tree().create_timer(1.5).timeout
	label.hide()

	 
