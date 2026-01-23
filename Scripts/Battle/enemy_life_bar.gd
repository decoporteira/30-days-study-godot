extends Control

var enemy = null

@onready var life_bar: ProgressBar = $LifeBar
@onready var life_bar_numbers: RichTextLabel = $RichTextLabel
@onready var character_name: RichTextLabel = $Name

var str_health

func _ready():
	if enemy:
		enemy.health_changed.connect(update_life_bar)
		
func get_max_health():
	if enemy == null:
		return
	character_name.append_text(enemy.character_name)
	print(enemy.character_name)
	str_health = str(enemy.health) + "/" + str(enemy.max_health)
	life_bar_numbers.append_text(str_health)
	life_bar.max_value = enemy.max_health
	life_bar.value = enemy.health
	
func update_life_bar(current, max_health):
	life_bar_numbers.clear()
	str_health = str(current) + "/" + str(max_health)
	life_bar_numbers.append_text(str_health)
	life_bar.max_value = max_health
	life_bar.value = current
