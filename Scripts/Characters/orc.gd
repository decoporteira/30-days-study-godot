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
	$EquipmentHolder.equipment_changed.connect(_on_equipment_changed)
	if starting_weapon:
		equip_item(starting_weapon)
	print(stats.name)
	print(stats.get_attack())

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
		emit_signal("battle_started", self)
		
func drop_loot() -> Array:
	return loot_inventory

func _on_equipment_changed():
	recalculate_stats()
	
func recalculate_stats():

	stats.bonus_attack = 0
	stats.bonus_defense = 0
	
	for slot in equipment_holder.slots.values():
		if slot.equipped_item:
			
			if slot.equipped_item is WeaponItemResource:
				stats.bonus_attack += slot.equipped_item.attack_power
		
			if slot.equipped_item is ArmorItemResource:
				stats.bonus_defense += slot.equipped_item.defense_power
