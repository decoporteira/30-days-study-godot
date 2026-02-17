extends AnimatableBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var damage_text: RichTextLabel = $DamageText

signal battle_started(enemy)
signal health_changed(current, max)

var health: int
var max_health: int
var character_name: String
var type = "enemy"
@export var stats: StatsResource
@export var inventory: Array[ItemResource] = []
@export var loot_inventory: Array[ItemResource] = []
@onready var equipment_holder: EquipmentHolder = $EquipmentHolder
@export var starting_weapon: WeaponItemResource
var status: Dictionary
var xp_reward

func _ready():
	character_name = stats.name
	max_health = stats.get_max_health()
	health = stats.get_max_health()
	xp_reward = stats.xp_reward
	emit_signal("health_changed", health, max_health)

func equip_item(item: ItemResource):
	equipment_holder.equip(item)
	
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
		
func drop_loot() -> Array:
	return loot_inventory
