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
var health = 2
var max_health = 100
var mana = 20
var max_mana = 40
var character_name = "Leora"
var type = "player"
@export var inventory: Array[ItemResource] = []
@export var spells: Array[Spell] = []
@onready var equipment_holder: EquipmentHolder = $EquipmentHolder

const SPEED = 200.0
var input_vector = Vector2.ZERO
var status: Dictionary = {
	"attack": 8,
	"defese": 5,
	"speed": 3,
}
var xp = 3
var player_level = 1

func _ready():
	
	emit_signal("health_changed", health, max_health)
	$EquipmentHolder.equipment_changed.connect(_on_equipment_changed)
func take_damage(amount):
	health -= amount
	if health < 0:
		health = 0
	emit_signal("health_changed", health, max_health)

func heal(amount):
	health += amount
	if health > max_health:
		health = max_health
	emit_signal("health_changed", health, max_health)
	
func buff(amount):
	status.speed += amount
	
func is_alive() -> bool:
	if health <= 0:
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
	status.attack += 1
	status.defese += 1
	status.speed += 1
	
func update_max_health() -> void:
	max_health += 10
	health = max_health
	emit_signal("health_changed", health, max_health)

func _on_equipment_changed():
	#stats.recalculate()
	print('Equipou')
