extends Control

var player = null

@onready var life_bar: ProgressBar = $LifeBar

func _ready():
	if player:
		player.health_changed.connect(update_life_bar)
	

func get_max_health():
	if player == null:
		return
	
	life_bar.max_value = player.max_health
	life_bar.value = player.health
	
func update_life_bar(current, max_health):
	life_bar.max_value = max_health
	life_bar.value = current
