extends Control

var player = null

@onready var life_bar: ProgressBar = $HBoxContainer/LifeBar
@onready var life_bar_numbers: RichTextLabel = $HBoxContainer/LifeBar/LifeBarNumbers
@onready var character_name: RichTextLabel = $HBoxContainer/Name

func _ready():
	if player:
		player.health_changed.connect(update_life_bar)

func get_max_health():
	if player == null:
		return
	character_name.append_text(player.character_name)
	var str_health = str(player.health) + "/" + str(player.max_health)
	life_bar_numbers.append_text(str_health)
	life_bar.max_value = player.max_health
	life_bar.value = player.health
	
func update_life_bar(current, max_health):
	life_bar_numbers.clear()
	var str_health = str(current) + "/" + str(player.max_health)
	life_bar_numbers.append_text(str_health)
	life_bar.max_value = max_health
	life_bar.value = current
