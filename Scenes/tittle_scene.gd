extends Control

var transition
@onready var press_start: RichTextLabel = $VBoxContainer/PressStart

func _ready() -> void:
	start_blink()
	var transition_scene = preload("res://Scenes/Battle/transition.tscn")
	transition = transition_scene.instantiate()
	add_child(transition)

func start_blink():
	var tween = create_tween()
	tween.set_loops() # infinito
	tween.tween_property(press_start, "modulate:a", 0.0, 0.6)
	tween.tween_property(press_start, "modulate:a", 1.0, 0.6)
	
func _on_button_button_down() -> void:

	await transition.fade_in(0.4)

	var game_scene = preload("res://Scenes/World/world.tscn")
	var world_scene = game_scene.instantiate()
	get_tree().root.add_child(world_scene)
	queue_free()
