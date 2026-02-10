extends Control

var player = null #ref ainda nao foi atribuida. estou mandando a ref pelo battle_manager
signal equipment_selected(equipment)

var is_showing := false
@onready var equipment_list: GridContainer = $ScrollContainer/EquipmentList

func _ready():
	
	# Exemplo: escutar um sinal para atualizar a UI quando o inventário mudar
	# Se não estiver usando sinais, chame update_inventory() manualmente
	update_equipments()
	hide_equipments()
	
func update_equipments():
	#limpa lista antiga
	for child in equipment_list.get_children():
		child.queue_free()
	
	#se nao houver player, nao faz nada
	if player == null:
		return
		
	for equipment in player.equipments:
		var btn = Button.new()
		btn.text = equipment.name
		btn.connect("pressed", Callable(self, "_on_equipment_pressed").bind(equipment))
		
		equipment_list.add_child(btn)
		btn.custom_minimum_size = Vector2(60, 20)

func show_equipments():
	print('Entrou em show_equipments em battle_ui')
	if is_showing == true:
		hide()
		is_showing = false
	else:
		show()
		is_showing = true
	print("Quantidade de botões:", equipment_list.get_child_count())

func hide_equipments():
	hide()
	is_showing = false
	
func _on_equipmentpressed(equipment):
	equipment_selected.emit(equipment)
	
	#chamar a funcao usar o item
	if has_node("/root/World/BattleManager"):
		var battle_manager = get_node("/root/World/BattleManager")
		battle_manager.equipments.use_equipment(player, equipment)
		update_equipments()
	else:
		print("Nao achou a funcao")
