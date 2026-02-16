extends Node
class_name Equipment

# O que está equipado agora
var weapon: WeaponItemResource = null
var armor_head: ArmorItemResource = null
var armor_body: ArmorItemResource = null

func equip(item: ItemResource):
	if item.item_type == ItemResource.ItemType.WEAPON:
		weapon = item
	elif item.item_type == ItemResource.ItemType.ARMOR:
		match item.slot:
			"head":
				armor_head = item
			"body":
				armor_body = item

func get_attack_bonus() -> int:
	if weapon:
		return weapon.attack_power
	return 0
	
func get_defense_bonus() -> int:
	var def := 0
	if armor_head:
		def += armor_head.defense
	if armor_body:
		def += armor_body.defense
	return def
