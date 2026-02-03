extends Control

@onready var battle_log: RichTextLabel = $MarginContainer/BattleLog
var processing := false
var messages: Array[String] = []

func add_message(msg: String) -> void:
	messages.append(msg)
	
	if messages.size() == 1:
		_process_queue()

func _process_queue() -> void:
	processing = true

	while messages.size() > 0:
		var msg = messages.pop_front()

		show()
		battle_log.clear()
		battle_log.append_text(msg)

		await get_tree().create_timer(1).timeout

	processing = false
	hide()
	battle_log.clear()
	
func clear_log():
	battle_log.clear()
