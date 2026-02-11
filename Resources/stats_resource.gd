class_name StatsResource
extends Resource

@export var max_health: int = 10
@export var attack: int = 2
@export var defense: int = 1
@export var speed: int = 1
@export var max_mp: int = 10

var health: int
var mp: int

func _init():
	health = max_health
	mp = max_mp
	
#funcoes estao duplicadas, preciso tirar fazer ela so funcionarem aqui
func setup():
	health = max_health
	mp = max_mp

#funcoes estao duplicadas, preciso tirar fazer ela so funcionarem aqui
func take_damage(amount: int):
	var damage = max(amount - defense, 0)
	health -= damage
	health = clamp(health, 0, max_health)
	return damage
#funcoes estao duplicadas, preciso tirar fazer ela so funcionarem aqui
func heal(amount: int):
	health += amount
	health = clamp(health, 0, max_health)
#funcoes estao duplicadas, preciso tirar fazer ela so funcionarem aqui
func is_dead() -> bool:
	return health <= 0
