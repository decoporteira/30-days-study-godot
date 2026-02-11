class_name StatsResource
extends Resource

@export var max_health: int = 10
@export var attack: int = 2
@export var defense: int = 1
@export var inteligence: int = 1
@export var speed: int = 1
@export var max_mp: int = 10

var health: int
var mp: int

func _init():
	health = max_health
	mp = max_mp
