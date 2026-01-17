extends Control

var player = null #ref ainda nao foi atribuida
signal item_selected(item)
@onready var item_list = $ItemList
var is_showing := false

func _ready():
	
	# Exemplo: escutar um sinal para atualizar a UI quando o inventário mudar
	# Se não estiver usando sinais, chame update_inventory() manualmente
	update_inventory()
	hide_inventory()
	
func update_inventory():
	#limpa lista antiga
	for child in item_list.get_children():
		child.queue_free()
	
	#se nao houver player, nao faz nada
	if player == null:
		return
		
	for item in player.inventory:
		var btn = Button.new()
		btn.text = item.name
		btn.connect("pressed", Callable(self, "_on_item_pressed").bind(item))
		
		item_list.add_child(btn)

func show_inventory():
	if is_showing == true:
		hide()
		is_showing = false
	else:
		show()
		is_showing = true

func hide_inventory():
	hide()
	is_showing = false
	
func _on_item_pressed(item):
	item_selected.emit(item)
	
	print("Usado item: " + item.name)
	#chamar a funcao usar o item
	if has_node("/root/BattleManager"):
		var battle_manager = get_node("/root/BattleManager")
		battle_manager.inventory.use_item(player, item)
		update_inventory()
	else:
		print("Nao achou a funcao")
