extends AnimatableBody2D
#######################
# Movimentacao
#######################
@export var speed := 20.0
@export var change_dir_time := 1.0

var direction := Vector2.ZERO
var last_direction := Vector2.DOWN
var stop_moving := false

@onready var timer: Timer = $Timer
#####################

@onready var damage_text: RichTextLabel = $DamageText
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

#@export var data: EnemyData

signal battle_started(enemy)
signal health_changed(current, max)

var health: int
var max_health: int
var character_name: String
var type := "enemy"

@export var inventory: Array[ItemResource] = []
@export var loot_inventory: Array[ItemResource] = []
@export var stats: StatsResource
var status: Dictionary
var xp_reward
@onready var equipment_holder: EquipmentHolder = $EquipmentHolder
@export var starting_weapon: WeaponItemResource
	
var has_battle_started := false

func _ready():
	_pick_random_direction()
	if starting_weapon:
		equip_item(starting_weapon)
	timer.wait_time = change_dir_time
	timer.one_shot = false
	timer.start()

	character_name = stats.name
	max_health = stats.get_max_health()
	health = stats.get_max_health()
	xp_reward = stats.xp_reward
	emit_signal("health_changed", health, max_health)

func equip_item(item: ItemResource):
	equipment_holder.equip(item)
##############################################
# COMBATE / STATUS
##############################################

func take_damage(amount: int):
	health -= amount
	if health < 0:
		health = 0
	emit_signal("health_changed", health, max_health)

func heal(amount: int):
	health += amount
	if health > max_health:
		health = max_health
	emit_signal("health_changed", health, max_health)

func is_alive() -> bool:
	return health > 0

##############################################
# BATALHA
##############################################

func _on_area_2d_body_entered(body: Node2D) -> void:
	if has_battle_started:
		return

	if body.is_in_group("player"):
		has_battle_started = true
		emit_signal("battle_started", self)

##############################################
# MOVIMENTO & ANIMAÇÃO
##############################################

func _physics_process(delta):
	var world = get_tree().current_scene
	
	if world.current_state != world.GameState.EXPLORATION:
		direction = Vector2.ZERO
		sprite.play("idle")
		return
		
	if stop_moving:
		sprite.play("idle")
		return

	if direction != Vector2.ZERO:
		last_direction = direction
		_play_walk()

		var motion: Vector2 = direction * speed * delta
		var collision = move_and_collide(motion)

		if collision:
			_pick_random_direction(direction)
	else:
		sprite.play("idle")

##############################################
# ANIMAÇÕES
##############################################

func _play_walk():
	match direction:
		Vector2.RIGHT:
				sprite.play("walking")
				sprite.flip_h = true
		Vector2.LEFT:
				sprite.play("walking")
				sprite.flip_h = false
		Vector2.UP:
				sprite.play("walking")
		Vector2.DOWN:
				sprite.play("walking")
	
	

##############################################
# IA SIMPLES
##############################################

func _pick_random_direction(exclude := Vector2.ZERO):
	var dirs = [
		Vector2.RIGHT,
		Vector2.LEFT,
		Vector2.UP,
		Vector2.DOWN,
	]

	if exclude != Vector2.ZERO:
		dirs.erase(exclude)

	direction = dirs.pick_random()

func _on_timer_timeout():
	# chance de parar para dar vida ao inimigo
	if randi() % 5 == 0:
		direction = Vector2.ZERO
	else:
		_pick_random_direction()

func drop_loot() -> Array:
	return loot_inventory
