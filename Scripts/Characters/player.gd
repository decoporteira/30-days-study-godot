extends CharacterBody2D

@onready var attack_sfx: AudioStreamPlayer = $AttackSFX
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var damage_text: RichTextLabel = $DamageText
signal health_changed(current, max)
signal level_up(current_level)
enum PlayerMode {
	EXPLORATION,
	BATTLE
}

var mode = PlayerMode.EXPLORATION

var character_name = "Leora"
var type = "player"
@export var inventory: Array[ItemResource] = []
@export var spells: Array[Spell] = []
@onready var equipment_holder: EquipmentHolder = $EquipmentHolder
@export var stats: StatsResource
const SPEED = 200.0
var input_vector = Vector2.ZERO

var xp = 3
var player_level = 1

func _ready():
	emit_signal("health_changed", stats.health, stats.base_max_health)
	$EquipmentHolder.equipment_changed.connect(_on_equipment_changed)
	
func equip_item(item: ItemResource):
	equipment_holder.equip(item)
	#update_stats()

func take_damage(amount):
	stats.health -= amount
	if stats.health < 0:
		stats.health = 0
	emit_signal("health_changed", stats.health, stats.max_health)

func heal(amount):
	stats.health += amount
	if stats.health > stats.max_health:
		stats.health = stats.max_health
	emit_signal("health_changed", stats.health, stats.max_health)
	
func buff(amount):
	stats.speed += amount
	
func is_alive() -> bool:
	if stats.health <= 0:
		return false
	else:
		return true
		
func _physics_process(_delta: float) -> void:
	if mode != PlayerMode.EXPLORATION:
		velocity = Vector2.ZERO
		return
	var dir = get_input_direction()
	velocity = dir * SPEED
	move_and_slide()
	
func get_input_direction() -> Vector2:
	
	var direction := Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT
		sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		direction = Vector2.LEFT
		sprite.flip_h = true
	elif Input.is_action_pressed("ui_down"):
		direction = Vector2.DOWN
	elif Input.is_action_pressed("ui_up"):
		direction = Vector2.UP

	if direction != Vector2.ZERO:
		if sprite.animation != "walking":
			sprite.play("walking")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")

	return direction
func get_xp(xp_reward) -> void:
	xp += xp_reward
	if xp >= 5:
		player_level += 1
		emit_signal("level_up", player_level)
		update_status()
		update_max_health()

func update_status() -> void:
	stats.base_attack += 1
	stats.base_defense += 1
	stats.base_speed += 1
	
func update_max_health() -> void:
	stats.base_max_health += 10
	stats.health = stats.base_max_health
	emit_signal("health_changed", stats.health, stats.base_max_health)

func _on_equipment_changed():
	recalculate_stats()
	
func recalculate_stats():

	stats.bonus_attack = 0
	stats.bonus_defense = 0
	
	for slot in equipment_holder.slots.values():
		if slot.equipped_item:
			
			if slot.equipped_item is WeaponItemResource:
				stats.bonus_attack += slot.equipped_item.attack_power
				print(stats.bonus_attack)			
			if slot.equipped_item is ArmorItemResource:
				stats.bonus_defense += slot.equipped_item.defense_power
				print(stats.bonus_defense)
