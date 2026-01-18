extends CanvasLayer

@onready var rect: ColorRect = $ColorRect

func fade_out(duration := 0.5) -> void:
	rect.visible = true
	var tween = create_tween()
	tween.tween_property(rect, "color:a", 1.0, duration)
	await tween.finished

func fade_in(duration := 0.5) -> void:
	var tween = create_tween()
	tween.tween_property(rect, "color:a", 0.0, duration)
	await tween.finished
	rect.visible = false
