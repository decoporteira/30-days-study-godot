extends AnimatableBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
signal battle_started(enemy)
var health = 50
var max_health = 50
var character_name = "Ghost"
var type = "enemy"
var inventory = []
var status: Dictionary = {
	"attack": 7,
	"defese": 3,
	"speed": 10,
}

signal health_changed(current, max)

func _ready():
	emit_signal("health_changed", health, max_health)
	
	var chain = {
		"name": "Chain",
		"type": "weapon",
		"hp": 20,
		"critical_chance": 10 
	}
	inventory = [chain]
	
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
		 
