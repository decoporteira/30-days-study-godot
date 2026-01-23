extends Control

@onready var battle_log: RichTextLabel = $MarginContainer/BattleLog

var messages: Array[String] = []
func add_message(msg: String) -> void:
		battle_log.append_text(msg + "\n")
		battle_log.scroll_to_line(battle_log.get_line_count())
		messages.append(msg)
		
func clear_log():
	battle_log.clear()
