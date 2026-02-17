class_name StatsResource
extends Resource

@export var name: String
@export var base_max_health: int = 10
@export var base_attack: int = 2
@export var base_defense: int = 1
@export var base_inteligence: int = 1
@export var base_speed: int = 1
@export var base_max_mana: int = 10
@export var xp_reward: int
@export var is_final_boss := false
@export var sprite: PackedScene


var bonus_attack: int = 0
var bonus_defense: int = 0
var bonus_inteligence: int = 0
var bonus_speed: int = 0

var health: int
var mana: int

func _init():
	health = base_max_health
	mana = base_max_mana
	
func get_attack() -> int:
	return base_attack + bonus_attack

func get_defense() -> int:
	return base_defense + bonus_defense

func get_max_health() -> int:
	return base_max_health

func get_max_mana() -> int:
	return base_max_mana
	
func get_inteligence() -> int:
	return base_inteligence + bonus_inteligence
	
func get_speed() -> int:
	return base_speed + bonus_speed
