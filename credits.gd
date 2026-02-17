extends Control

func _ready():
	$AnimationPlayer.play("scroll")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Tittle_Scene.tscn")
