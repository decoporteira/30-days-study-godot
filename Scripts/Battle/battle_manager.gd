extends Node

var inventory
var player
var enemy
var battle_menu
var player_life_bar
var current_turn
var battle_log
var inventory_ui
var rng = RandomNumberGenerator.new()
var enemy_sprite_ui: AnimatedSprite2D
var player_sprite_ui: AnimatedSprite2D
var player_damage_text_ui: RichTextLabel
var enemy_damage_text_ui: RichTextLabel
var battle_ui
var first_turn
var player_used_action: bool = false
var enemy_used_action: bool = false
enum BattleState { 
	TURN_ORDER,
	PLAYER_TURN,
	PLAYER_ACTION,
	INVENTORY,
	ENEMY_TURN,
	VICTORY,
	DEFEAT,
	END
}
signal battle_ended
var current_state : BattleState

func _ready() -> void:
	var battle_ui_scene = preload("res://Scenes/Battle/battle_ui.tscn")
	battle_ui = battle_ui_scene.instantiate()
	add_child(battle_ui)
	battle_log = battle_ui.get_node("MarginContainer/MainVBox/TopArea/BattleLog")
	player_life_bar = battle_ui.get_node("MarginContainer/MainVBox/BottomArea/Margin/NinePatchRect/PlayerLifeBar")
	
	battle_menu = battle_ui.get_node("MarginContainer/MainVBox/BottomArea/Margin/NinePatchRect/BattleMenu")
	inventory_ui = battle_ui.get_node("MarginContainer/MainVBox/BottomArea/Margin/NinePatchRect/InventoryUI")
	
	var inventory_scene = preload("res://Scenes/Battle/inventory.tscn")
	inventory = inventory_scene.instantiate()
	add_child(inventory)

	inventory_ui.item_selected.connect(
		Callable(self, "_on_item_selected")
	)

	battle_menu.battle_manager = self

func setup(world_player, world_enemy): #1
	player = world_player
	enemy = world_enemy
	
func initialize_battle(): #2
	if player == null or enemy == null:
		push_error("BattleManager initialized without player or enemy")
		return
	#coloca sprite na luta
	var enemy_world_sprite = enemy.sprite
	enemy_sprite_ui = enemy_world_sprite.duplicate()
	enemy_sprite_ui.scale = Vector2(2, 2)
	enemy_sprite_ui.position = Vector2(100, 100)
	enemy_sprite_ui.z_index = 5
	enemy_sprite_ui.flip_h = false
	enemy_sprite_ui.play(enemy_world_sprite.animation)

	# Remove qualquer processamento desnecessário
	enemy_sprite_ui.set_physics_process(false)
	enemy_sprite_ui.set_process(false)
	
	var player_world_sprite = player.sprite
	player_sprite_ui = player_world_sprite.duplicate()
	player_sprite_ui.scale = Vector2(2, 2)
	player_sprite_ui.position = Vector2(100, 100)
	player_sprite_ui.z_index = 5
	player_sprite_ui.flip_h = false
	player_sprite_ui.play(player_world_sprite.animation)
	
	var player_damage_text = player.damage_text
	player_damage_text_ui = player_damage_text.duplicate()
	player_damage_text_ui.position = Vector2(100,100)
	
	var enemy_damage_text = enemy.damage_text
	enemy_damage_text_ui = enemy_damage_text.duplicate()
	enemy_damage_text_ui.position = Vector2(100,100)
	
	# Remove qualquer processamento desnecessário
	player_sprite_ui.set_physics_process(false)
	player_sprite_ui.set_process(false)
	
	# Adiciona na UI
	var enemy_holder = battle_ui.get_node(
		"MarginContainer/MainVBox/CenterArea/EnemySpriteHolder"
	)
	enemy_holder.add_child(enemy_sprite_ui)
	enemy_holder.add_child(enemy_damage_text_ui)
	
	var player_holder = battle_ui.get_node(
		"MarginContainer/MainVBox/CenterArea/PlayerSpriteHolder"
	)
	player_holder.add_child(player_sprite_ui)
	player_holder.add_child(player_damage_text_ui)
	
	inventory_ui.player = player
	inventory_ui.update_inventory()
	#C
	player_life_bar.player = player
	
	player.health_changed.connect(
		Callable(player_life_bar, "update_life_bar")
	)
	player.level_up.connect(
		Callable(self, "_on_player_level_up")
	)
	player_life_bar.get_max_health()

	inventory.player = player

	await get_tree().create_timer(1.5).timeout

func start_battle(): #3
	change_state(BattleState.TURN_ORDER)
	
# =========================
# AÇÕES
# =========================
func player_attack():
	if current_state != BattleState.PLAYER_TURN:
		return

	change_state(BattleState.PLAYER_ACTION)
	attack(player, enemy)
	
func _on_item_selected(item):
	battle_log.add_message("Hero used " + item.name)
	change_state(BattleState.PLAYER_ACTION)
	
func open_inventory():
	if current_state != BattleState.PLAYER_TURN:
		return
	battle_log.add_message("Choose an item:")
	inventory_ui.show_inventory()
	
func run_away():
	change_state(BattleState.PLAYER_ACTION)
	var run_away_percentage = rng.randf_range(0.0, 100.0)
	if run_away_percentage >= 50:
		battle_log.add_message("You tried to escape... and you were sucessful!")
		change_state(BattleState.END)
	else:
		battle_log.add_message("You tried to escape... and you fail!")
		
# =========================
# STATE MACHINE
# =========================
func change_state(new_state: BattleState) -> void:
	if current_state == BattleState.END:
		return

	current_state = new_state

	match current_state:
		BattleState.PLAYER_TURN:
			on_player_turn()

		BattleState.PLAYER_ACTION:
			on_player_action()

		BattleState.TURN_ORDER:
			on_turn_order()

		BattleState.INVENTORY:
			on_inventory()

		BattleState.ENEMY_TURN:
			on_enemy_turn()

		BattleState.VICTORY:
			on_victory()

		BattleState.DEFEAT:
			on_defeat()

		BattleState.END:
			on_battle_end()
# =========================
# COMBATE
# =========================
func attack(attacker, defender) -> void:
	if battle_is_over():
		return
	if not attacker.is_alive():
		print(attacker.name, " está morto, turno ignorado")
		return
	var weapon_name = get_weapon_name(attacker)
	var damage = get_weapon_damage(attacker)
	var critical_chance = get_weapon_crit_chance(attacker)
	var damage_delt = calc_damage(attacker.status.attack, damage, defender.status.defese, critical_chance)
	battle_log.add_message(
		attacker.character_name + " attacked with " + weapon_name +
		" and dealt " + str(damage_delt) + " damage."
	)
	if attacker == enemy:
		player_damage_text_ui.add_text(str(damage_delt))
		player_damage_text_ui.show()
		await animation_attack(enemy_sprite_ui, -1)
		await hit_shake(player_sprite_ui)
		player.attack_sfx.play()
		player.take_damage(damage_delt)
		await get_tree().create_timer(1.5).timeout
		player_damage_text_ui.hide()
		player_damage_text_ui.clear()
		
	else:
		enemy_damage_text_ui.add_text(str(damage_delt))
		enemy_damage_text_ui.show()
		await animation_attack(player_sprite_ui, 1)
		await hit_shake(enemy_sprite_ui)
		player.attack_sfx.play()
		enemy.take_damage(damage_delt)
		
		await get_tree().create_timer(1.5).timeout
		enemy_damage_text_ui.hide()
		enemy_damage_text_ui.clear()
		
	
	#defender.take_damage(damage_delt)
	
	if not defender.is_alive():
		if defender == enemy:
			change_state(BattleState.VICTORY)
			return
		else:
			change_state(BattleState.DEFEAT)
			return

		return # deveria cortar o fluxo

func get_weapon_damage(attacker):
	if attacker.inventory.size() == 0:
		return 1
	for item in attacker.inventory:
		if item is WeaponItemResource:
			return item.attack_power
	return 1 # dano base sem arma
	
func get_weapon_name(attacker):
	if attacker.inventory.size() == 0:
		return "Hands"
	for item in attacker.inventory:
		if item is WeaponItemResource:
			return item.name
			
func get_weapon_crit_chance(attacker):
	if attacker.inventory.size() == 0:
		return 1
	for item in attacker.inventory:
		if item is WeaponItemResource:
			return item.critical_chance
			
func calc_damage(char_attack: int, weapon: int, defese: int, crit_chance: int) -> int:
	var base_damage = max(1, int(char_attack*weapon)/max(defese,1)) 
	var base_damage_crit = base_damage * randf_range(0.9, 1.1) #apenas para dar aleatoridade para o ataque 
	
	if crit_chance > randf_range(1, 100):
		base_damage_crit *= 1.5

	return max(1, int(base_damage_crit))
	
# =========================
# CONTROLE DE FLUXO
# =========================
func check_end_or_next():
	if current_state in [BattleState.VICTORY, BattleState.DEFEAT, BattleState.END]:
		return
	# Fim de batalha
	if not player.is_alive():
		await get_tree().create_timer(5).timeout
		change_state(BattleState.END)
		return

	if not enemy.is_alive():
		await get_tree().create_timer(5).timeout
		change_state(BattleState.END)
		return

	# Fim da rodada
	if player_used_action and enemy_used_action:
		player_used_action = false
		enemy_used_action = false

		change_state(BattleState.TURN_ORDER)
		return

	# Próximo turno
	if current_state == BattleState.PLAYER_ACTION:
		change_state(BattleState.ENEMY_TURN)
	elif current_state == BattleState.ENEMY_TURN:
		change_state(BattleState.PLAYER_TURN)
	
# =========================
# ESTADOS
# =========================
func on_player_turn():
	if not player.is_alive():
		change_state(BattleState.END)
		return
	battle_log.add_message("Your turn!!!")
	battle_menu.show_menu()
	inventory_ui.hide_inventory()

func on_inventory():
	battle_log.add_message("Choose an item:")
	inventory_ui.show_inventory()

func on_player_action():
	if battle_is_over():
		return
	battle_menu.hide_menu()
	inventory_ui.hide_inventory()
	
	await get_tree().create_timer(1.5).timeout
	player_used_action= true
	check_end_or_next()
		
func on_enemy_turn():
	if battle_is_over() or not enemy.is_alive():
		return
	print('Entrou no turno do inimigo!')
	battle_log.add_message("Enemy turn!")
	
	await get_tree().create_timer(1.5).timeout
	attack(enemy, player)

	await get_tree().create_timer(1.5).timeout
	enemy_used_action = true
	check_end_or_next()

func on_victory():
	battle_menu.hide_menu()
	inventory_ui.hide_inventory()

	battle_log.add_message(enemy.character_name + " was defeated!")
	await get_tree().create_timer(0.8).timeout

	await enemy_defeat_effect()
	await get_tree().create_timer(0.6).timeout

	battle_log.add_message("You got " + str(enemy.xp_reward) + " XP")
	await get_tree().create_timer(1.2).timeout

	check_level(enemy.xp_reward)
	await get_tree().create_timer(0.8).timeout

	await get_loot()
	await get_tree().create_timer(1.0).timeout

	change_state(BattleState.END)

func on_defeat():
	battle_menu.hide_menu()
	inventory_ui.hide_inventory()

	battle_log.add_message("You died. Game Over!")
	await get_tree().create_timer(1.5).timeout

	change_state(BattleState.END)
	
func on_battle_end():
	battle_menu.hide_menu()
	inventory_ui.hide_inventory()
	battle_log.add_message("Battle ended.")
	emit_signal("battle_ended")

func on_turn_order():
	define_turn_order()

func define_turn_order():
	if player.status.speed > enemy.status.speed:
		first_turn = player
	elif enemy.status.speed > player.status.speed:
		first_turn = enemy
	else:
		first_turn = player

	start_first_turn()

func battle_is_over() -> bool:
	return current_state == BattleState.END

func start_first_turn():
	if first_turn == player:
		change_state(BattleState.PLAYER_TURN)
	else:
		change_state(BattleState.ENEMY_TURN)
		
func animation_attack(attacker_sprite: AnimatedSprite2D, direction := 1):
	var start_pos := attacker_sprite.position
	var advance := Vector2(30 * direction, 0)
	
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	
	# Avança rápido
	tween.tween_property(
		attacker_sprite,
		"position",
		start_pos + advance,
		0.08
	)
	
	# Volta
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(
		attacker_sprite,
		"position",
		start_pos,
		0.12
	)

	await tween.finished
	
func hit_shake(target_sprite: AnimatedSprite2D):
	var start_pos := target_sprite.position

	var tween := create_tween()
	tween.tween_property(
		target_sprite,
		"position",
		start_pos + Vector2(4, 0),
		0.03
	)
	tween.tween_property(
		target_sprite,
		"position",
		start_pos - Vector2(4, 0),
		0.03
	)
	tween.tween_property(
		target_sprite,
		"position",
		start_pos,
		0.03
	)
func enemy_defeat_effect():
	if enemy_sprite_ui == null:
		return

	var tween := create_tween()
	tween.set_parallel(true)

	# Fade out
	tween.tween_property(
		enemy_sprite_ui,
		"modulate:a",
		0.0,
		0.4
	)

	# Encolhe um pouco
	tween.tween_property(
		enemy_sprite_ui,
		"scale",
		enemy_sprite_ui.scale * 0.8,
		0.4
	)

	# Sobe levemente
	tween.tween_property(
		enemy_sprite_ui,
		"position",
		enemy_sprite_ui.position + Vector2(0, -10),
		0.4
	)

	await tween.finished
	enemy_sprite_ui.hide()

func check_level(xp_reward) -> void:
	player.get_xp(xp_reward)
	
func _on_player_level_up(new_level: int) -> void:
	battle_log.add_message("🎉 Level up! You reached level " + str(new_level))

func get_loot():
	for item in enemy.drop_loot():
		inventory.add_item(player, item)
		battle_log.add_message("Você obteve %s" % item.name)
		await get_tree().create_timer(0.8).timeout
