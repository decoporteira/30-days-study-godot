extends Node

var inventory: Array[ItemResource] = []
var life_bar
var player

func use_item(character, item: ItemResource) -> void:
	if item is ConsumableItemResource:
		get_cured(character, item.heal_amount)
		remove_item(character, item)
	elif item is WeaponItemResource:
		print("Equipou com o item") #preciso fazer equipar
		
func remove_item(character, item: ItemResource) -> void:
	var item_index = find_item_index(character, item.name)
	character.inventory.remove_at(item_index)

func add_item(character, item: ItemResource) -> void:
	character.inventory.append(item)
	
func get_cured(character, hitpoints):
	character.heal(hitpoints)
	
func get_buff(character, speed_points):
	character.buff(speed_points)
	
func find_item_index(character, item_name: String) -> int:
	for i in range(character.inventory.size()):
		if character.inventory[i].name == item_name:
			return i
	return -1
