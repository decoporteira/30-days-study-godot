extends CharacterBody2D

signal health_changed(current, max)
enum PlayerMode {
	EXPLORATION,
	BATTLE
}

var mode = PlayerMode.EXPLORATION
var health = 100
var max_health = 100
var character_name = "Hero"
var type = "player"
@export var inventory: Array[ItemResource] = []

const SPEED = 200.0
var input_vector = Vector2.ZERO
var status: Dictionary = {
	"attack": 8,
	"defese": 5,
	"speed": 3,
}

func _ready():
	#var sword = preload("res://Resources/Items/Weapons/short_sword.tres")
	emit_signal("health_changed", health, max_health)

	#inventory = [sword]
	
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
	if Input.is_action_pressed("ui_right"):
		return Vector2.RIGHT
	elif Input.is_action_pressed("ui_left"):
		return Vector2.LEFT
	elif Input.is_action_pressed("ui_down"):
		return Vector2.DOWN
	elif Input.is_action_pressed("ui_up"):
		return Vector2.UP

	return Vector2.ZERO
