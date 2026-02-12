extends Node

var items = {
	"health_potion": preload("res://Resources/Items/Consumables/health_potion.tres"),
	"short_sword": preload("res://Resources/Items/Weapons/short_sword.tres"),
	"bat": preload("res://Resources/Items/Weapons/bat.tres"),
	"knife": preload("res://Resources/Items/Weapons/knife.tres"),
	
}

func get_item(id: String):
	return items.get(id)
