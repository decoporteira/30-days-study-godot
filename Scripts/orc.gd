extends AnimatableBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var data: EnemyData

signal battle_started(enemy)
signal health_changed(current, max)

var health: int
var max_health: int
var character_name: String
var type = "enemy"
var inventory = []

var status: Dictionary


func _ready():
	character_name = data.name
	max_health = data.max_hp
	health = data.max_hp
	
	status = {
		"attack": data.attack,
		"defese": data.defense,
		"speed": data.speed
	}
	
	emit_signal("health_changed", health, max_health)
	
	var bat = {
		"name": "Porrete",
		"type": "weapon",
		"hp": 10,
		"critical_chance": 10 
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

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Bateu no inimigo")
		emit_signal("battle_started", self)
