extends Control

var transition
@onready var press_start: Button = $VBoxContainer/Button
@onready var title: RichTextLabel = $VBoxContainer/Title

func _ready() -> void:
	start_blink()
	start_descend()
	var transition_scene = preload("res://Scenes/Battle/transition.tscn")
	transition = transition_scene.instantiate()
	add_child(transition)

func start_descend():
	var start_pos := title.position

	var tween := create_tween()
	tween.tween_property(
		title,
		"position",
		start_pos + Vector2(0, 20),
		4
	)

func start_blink():
	var tween = create_tween()
	tween.set_loops() # infinito
	tween.tween_property(press_start, "modulate:a", 0.0, 0.6)
	tween.tween_property(press_start, "modulate:a", 1.0, 0.6)
	
func _on_button_button_down() -> void:

	await transition.fade_in(0.4)

	get_tree().change_scene_to_file("res://Scenes/World/world.tscn")
