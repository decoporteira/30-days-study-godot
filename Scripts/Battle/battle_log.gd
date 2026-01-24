extends Control

@onready var battle_log: RichTextLabel = $MarginContainer/BattleLog

var messages: Array[String] = []
func add_message(msg: String) -> void:
		show()
		battle_log.append_text(msg)
		messages.append(msg)
		await get_tree().create_timer(1.5).timeout 
		hide()
		clear_log()
		
func clear_log():
	battle_log.clear()
