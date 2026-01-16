extends Node2D

var health = 40
var max_health = 40
var character_name = "Orc"
var type = "enemy"
var inventory = []

signal health_changed(current, max)

func _ready():
	emit_signal("health_changed", health, max_health)
	
	var bat = {
		"name": "Porrete",
		"type": "weapon",
		"hp": 10,
	}
	inventory = [bat]
	
func take_damage(amount):
	health -= amount
	if health < 0:
		health = 0
	emit_signal("health_changed", health, max_health)

func heal(amount):
	health += amount
	if health < max_health:
		health = max_health
	emit_signal("health_changed", health, max_health)

func is_alive() -> bool:
	if health <= 0:
		return false
	else:
		return true
