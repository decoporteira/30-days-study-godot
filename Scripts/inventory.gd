extends Node

var inventory = []
var life_bar
var player
func add_item(character, item: Dictionary) -> void:
	#So adiciona se o inventário não tem item com o mesmo nome
	if has_item(character, item.name):
		print("Voce nao pode adicionar o " + item.name + " ao inventario.")
		list_items(character)
		return
	character.inventory.push_back(item)
	print("---- Add item to inventory ----")
	print("Voce adicionou " + item.name + " ao inventario.")
	list_items(character)

func use_item(character, item: Dictionary) -> void:
	if has_item(character, item.name):
		print("---- Voce tentou usar " + item.name + "----")
		if item.type == "consumable":
			get_cured(character, item.hp)
			remove_item(character, item)
		else:
			print("Voce nao pode usar " + item.name + " nesse momento.")
		print("-----------------------")
	else:
		print("---- Voce nao tem " + item.name + " no seu inventario ----")
		

func remove_item(character, item: Dictionary) -> void:
	if not has_item(character, item.name):
		print("Voce nao pode remover o " + item.name + " do inventario.")
		list_items(character)
		return
	var item_index = find_item_index(character, item.name)
	character.inventory.remove_at(item_index)
	print("---- Remove item do inventario ----")
	print("Voce removeu " + item.name + " do inventario.")
	
func list_items(character) -> void:
	print("---- Inventory ----")
	for item in character.inventory:
		print(item.name)
	print("-----------------------")
	
func get_cured(character, hitpoints):
	print("Voce recebeu cura de " + str(hitpoints) + " pontos")
	character.heal(hitpoints)
	print("Pontos de vida: " + str(character.health))
	print("-----------------------")
	
func has_item(character, item_name: String) -> bool:
	return find_item_index(character, item_name) != -1

func find_item_index(character, item_name: String) -> int:
	for i in range(character.inventory.size()):
		if character.inventory[i].name == item_name:
			return i
	return -1
