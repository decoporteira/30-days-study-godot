extends Node2D

@onready var music: AudioStreamPlayer = $AudioStreamPlayer
@onready var world_map: TileMapLayer = $World_map
var battle_manager: Node
var transition
var enemy
@onready var player: CharacterBody2D = $Player_World
@onready var orc: AnimatableBody2D = $Orc
@onready var ghost: AnimatableBody2D = $Ghost
@onready var blue_orc: AnimatableBody2D = $BlueOrc
@export var character_menu_scene: PackedScene

var character_menu: Control

enum GameState {
	EXPLORATION,
	BATTLE
}

var current_state: GameState = GameState.EXPLORATION

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Orc.battle_started.connect(_on_battle_started)
	$Ghost.battle_started.connect(_on_battle_started)
	$BlueOrc.battle_started.connect(_on_battle_started)
	var transition_scene = preload("res://Scenes/Battle/transition.tscn")
	transition = transition_scene.instantiate()
	add_child(transition)

func _on_battle_started(current_enemy):
	enemy = current_enemy
	start_battle()
	music.stop()

func start_battle():
	await transition.fade_out(0.4)
	current_state = GameState.BATTLE
	player.mode = player.PlayerMode.BATTLE
	player.hide()
	player.set_process(false)
	player.set_physics_process(false)
	# esconde mundo
	
	world_map.hide()
	hide_all_enemies()

	var battle_scene = preload("res:////Scenes/Battle/battle_manager.tscn")
	battle_manager = battle_scene.instantiate()
	add_child(battle_manager)
	
	battle_manager.setup(player, enemy)
	battle_manager.initialize_battle()
	battle_manager.start_battle()
	
	battle_manager.battle_ended.connect(_on_battle_ended)

	await transition.fade_in(0.4)
	
func _on_battle_ended():
	await transition.fade_out(0.4)
	
	battle_manager.queue_free()
	
	music.play()
	
	enemy.queue_free()
	show_all_enemies()
	player.mode = player.PlayerMode.EXPLORATION
	player.set_process(true)
	player.set_physics_process(true)
	player.show()
	world_map.show()
	
	await transition.fade_in(0.4)

func hide_all_enemies():
	for en in get_tree().get_nodes_in_group("enemy"):
		en.hide()
		
func show_all_enemies():
	for en in get_tree().get_nodes_in_group("enemy"):
		en.show()
		
func _unhandled_input(event):
	if event.is_action_pressed("ui_character_menu"):
		toggle_character_menu()


func toggle_character_menu():
	if character_menu and is_instance_valid(character_menu):
		character_menu.close()
		character_menu = null
	else:
		open_character_menu()

func open_character_menu():
	character_menu = character_menu_scene.instantiate()
	character_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(character_menu)
	character_menu.open()
