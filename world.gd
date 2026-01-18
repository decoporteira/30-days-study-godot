extends Node2D

@onready var enemy = $Enemy_world
@onready var player: CharacterBody2D = $Player_World
@onready var world_map: TileMapLayer = $World_map
var battle_manager: Node
var transition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Enemy_world.battle_started.connect(_on_battle_started)
	var transition_scene = preload("res://transition.tscn")
	transition = transition_scene.instantiate()
	add_child(transition)
	

	
func _on_battle_started(enemy):
	print("BATALHA COM:", enemy.name)
	start_battle(enemy)

func start_battle(enemy):
	await transition.fade_out(0.4)
	# esconde mundo
	player.hide()
	world_map.hide()
	enemy.hide()

	print("Batalhar comecou")
	# carrega batalha
	var battle_scene = preload("res:////Scenes/battle_manager.tscn")
	battle_manager = battle_scene.instantiate()
	add_child(battle_manager)
	battle_manager.battle_ended.connect(_on_battle_ended)

	await transition.fade_in(0.4)
	
func _on_battle_ended():
	await get_tree().create_timer(0.8).timeout
	await transition.fade_out(0.4)
	print("BATALHA ACabou")
	battle_manager.queue_free()
	enemy.queue_free()
	player.show()
	world_map.show()
	await transition.fade_in(0.4)

	
