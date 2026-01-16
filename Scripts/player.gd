class_name Player
extends Node2D

signal health_changed(current, max)

var health = 20
var max_health = 30
var character_name = "Hero"
var type = "player"
var inventory: Array = []

func _ready():
	emit_signal("health_changed", health, max_health)
	var potion = {
			"name": "Health Potion",
			"type": "consumable",
			"hp": 10,
	}
	var sword = {
			"name": "Short Sword",
			"type": "weapon",
			"hp": 20,
	}
	inventory = [sword, potion]
	
func take_damage(amount):
	health -= amount
	if health < 0:
		health = 0
	emit_signal("health_changed", health, max_health)

func heal(amount):
	health += amount
	if health > max_health:
		health = max_health
	emit_signal("health_changed", health, max_health)
	
func is_alive() -> bool:
	if health <= 0:
		return false
	else:
		return true
