extends Node

const SAVE_PATH := "user://savegame.json"

func save_game(player: Node) -> void:
	var inventory_data: Array = []
	
	for item in player.inventory:
		inventory_data.append(item.id) # só salva o ID
	
	var save_data = {
		"hp": player.stats.health,
		"mana": player.stats.mp,
		"level": player.player_level,
		"inventory": inventory_data,
		"position": {
			"x": player.global_position.x,
			"y": player.global_position.y
		}
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	

func load_game(player: Node) -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var data = JSON.parse_string(content)
	player.stats.health = data["hp"]
	player.stats.mp = data["mana"]
	player.player_level = int(data["level"])
	#limpar inventario
	player.inventory.clear()
	for item_id in data["inventory"]:
		var item_data = ItemDatabase.get_item(item_id)

		if item_data:
			var item = item_data.duplicate(true)
			player.inventory.append(item)
		else:
			print("NOT FOUND IN DATABASE")
			
	player.global_position = Vector2(
		data["position"]["x"],
		data["position"]["y"]
	)
	
