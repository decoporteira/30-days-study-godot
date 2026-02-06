extends Control

var battle_manager

func _ready():
	hide()

func show_menu():
	show()
	
func hide_menu():
	hide()
	
func end_battle():
	return

func _on_button_attack_pressed() -> void:
	battle_manager.player_attack()
	hide_menu()

func _on_button_item_pressed() -> void:
	battle_manager.open_inventory()

func _on_button_run_pressed() -> void:
	battle_manager.run_away()
	end_battle()

func _on_button_spells_pressed() -> void:
	battle_manager.open_spell_book()
