extends Control

var player = null #ref ainda nao foi atribuida. estou mandando a ref pelo battle_manager
signal spell_selected(spell)

var is_showing := false
@onready var spell_list: GridContainer = $ScrollContainer/SpellList

func _ready():
	
	# Exemplo: escutar um sinal para atualizar a UI quando o inventário mudar
	# Se não estiver usando sinais, chame update_inventory() manualmente
	update_spells()
	hide_spells()
	
func update_spells():
	#limpa lista antiga
	for child in spell_list.get_children():
		child.queue_free()
	
	#se nao houver player, nao faz nada
	if player == null:
		return
		
	for spell in player.spells:
		var btn = Button.new()
		btn.text = spell.name
		btn.connect("pressed", Callable(self, "_on_spell_pressed").bind(spell))
		
		spell_list.add_child(btn)
		btn.custom_minimum_size = Vector2(60, 20)

func show_spells():
	print('Entrou em show_spells em battle_ui')
	if is_showing == true:
		hide()
		is_showing = false
	else:
		show()
		is_showing = true
	print("Quantidade de botões:", spell_list.get_child_count())

func hide_spells():
	hide()
	is_showing = false
	
func _on_spell_pressed(spell):
	spell_selected.emit(spell)
	hide_spells()
	#chamar a funcao usar o item
	if has_node("/root/World/BattleManager"):
		var battle_manager = get_node("/root/World/BattleManager")
		battle_manager.player_cast_spell(spell)
		#update_spells()
	else:
		print("Nao achou a funcao")
		
