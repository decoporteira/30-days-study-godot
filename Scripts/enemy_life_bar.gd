extends Control

var enemy = null

@onready var life_bar: ProgressBar = $LifeBar

func _ready():
	if enemy:
		enemy.health_changed.connect(update_life_bar)
	
func get_max_health():
	if enemy == null:
		return
	life_bar.max_value = enemy.max_health
	life_bar.value = enemy.health
	
func update_life_bar(current, max_health):
	life_bar.max_value = max_health
	life_bar.value = current
