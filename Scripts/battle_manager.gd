extends Node

var inventory

var player
var enemy
var battle_menu
var player_life_bar
var enemy_life_bar
var current_turn
var battle_log
var inventory_ui
var rng = RandomNumberGenerator.new()
var enemy_sprite_ui: AnimatedSprite2D
var battle_ui
var first_turn
enum BattleState { 
	TURN_ORDER,
	PLAYER_TURN,
	PLAYER_ACTION,
	INVENTORY,
	ENEMY_TURN,
	END
}
signal battle_ended
var current_state : BattleState
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(self.get_path())
	var battle_ui_scene = preload("res://Scenes/battle_ui.tscn")
	battle_ui = battle_ui_scene.instantiate()
	add_child(battle_ui)
	battle_log = battle_ui.get_node("MarginContainer/MainVBox/CenterArea/BattleLog")
	enemy_life_bar = battle_ui.get_node("MarginContainer/MainVBox/TopArea/EnemyArea/EnemyLifeBar")
	player_life_bar = battle_ui.get_node("MarginContainer/MainVBox/TopArea/PlayerArea/PlayerLifeBar")
	battle_menu = battle_ui.get_node("MarginContainer/MainVBox/BottomArea/BattleMenu")
	inventory_ui = battle_ui.get_node("MarginContainer/MainVBox/BottomArea/InventoryUI")
	
	var inventory_scene = preload("res://Scenes/inventory.tscn")
	inventory = inventory_scene.instantiate()
	add_child(inventory)

	inventory_ui.item_selected.connect(
	Callable(self, "_on_item_selected")
)

	battle_menu.battle_manager = self

func setup(world_player, world_enemy):
	player = world_player
	enemy = world_enemy
	
func initialize_battle():
	if player == null or enemy == null:
		push_error("BattleManager initialized without player or enemy")
		return
	#coloca sprite na luta
	var world_sprite = enemy.sprite
	enemy_sprite_ui = world_sprite.duplicate()
	enemy_sprite_ui.scale = Vector2(3, 3)
	enemy_sprite_ui.position = Vector2(100,100)
	enemy_sprite_ui.z_index = 5
	enemy_sprite_ui.play(world_sprite.animation)

	# Remove qualquer processamento desnecessário
	enemy_sprite_ui.set_physics_process(false)
	enemy_sprite_ui.set_process(false)

	# Adiciona na UI
	var holder = battle_ui.get_node(
		"MarginContainer/MainVBox/TopArea/EnemyArea/EnemySpriteHolder"
	)
	holder.add_child(enemy_sprite_ui)
	inventory_ui.player = player
	inventory_ui.update_inventory()
	#C
	player_life_bar.player = player
	player.health_changed.connect(
		Callable(player_life_bar, "update_life_bar")
	)
	player_life_bar.get_max_health()

	enemy_life_bar.enemy = enemy
	enemy.health_changed.connect(
		Callable(enemy_life_bar, "update_life_bar")
	)
	enemy_life_bar.get_max_health()

	inventory.player = player

	battle_log.add_message(
		"You encountered a furious " + enemy.character_name + ". It wants to fight!"
	)

func start_battle():
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
	#aplicar efeito
	check_end_or_next()
	
func open_inventory():
	if current_state != BattleState.PLAYER_TURN:
		return
	battle_log.add_message("Choose an item:")
	inventory_ui.show_inventory()
	#change_state(BattleState.INVENTORY)
	
func run_away():
	battle_log.add_message("You tried to escape...")
	change_state(BattleState.PLAYER_ACTION)
	var run_away_percentage = rng.randf_range(0.0, 100.0)
	if run_away_percentage >= 50:
		battle_log.add_message(".. and you were sucessful! ")
		change_state(BattleState.END)
	else:
		battle_log.add_message(".. and you fail!")
		
# =========================
# STATE MACHINE
# =========================
func change_state(new_state: BattleState) -> void:
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

		BattleState.END:
			on_battle_end()
# =========================
# COMBATE
# =========================
func attack(attacker, defender) -> void:
	#print("Entrou em func attack")
	if attacker.inventory.size() == 0:
		print("Nao tem arma")
		battle_log.add_message(attacker.character_name + " has no weapon.")
		return
	#print("Ataque continua")
	var weapon = attacker.inventory[0]
	var damage = weapon.hp
	var damage_delt = calc_damage(attacker.status.attack, damage, defender.status.defese, weapon.critical_chance)
	battle_log.add_message(
		attacker.character_name + " attacked with " + weapon.name +
		" and dealt " + str(damage_delt) + " damage."
	)
	if attacker == enemy:
		await pokemon_attack(enemy_sprite_ui, -1)
	else:
		await hit_shake(enemy_sprite_ui)
		
	
	defender.take_damage(damage_delt)
	
	if not defender.is_alive():
		if defender.type == "enemy":
			battle_log.add_message(defender.character_name + " was defeated!")
		else:
			battle_log.add_message("You died. Game Over!")
			
func calc_damage(attack: int, weapon: int, defese: int, crit_chance: int) -> int:
	var base_damage = max(1, int(attack*weapon)/max(defese,1)) 
	var base_damage_crit = base_damage * randf_range(0.9, 1.1) #apenas para dar aleatoridade para o ataque 
	
	if crit_chance > randf_range(1, 100):
		base_damage_crit *= 1.5

	return max(1, int(base_damage_crit))
	
# =========================
# CONTROLE DE FLUXO
# =========================

func check_end_or_next():
	# Player morreu
	if not player.is_alive():
		change_state(BattleState.END)
		battle_log.clear_log()
		battle_log.add_message("You died. Game Over!")
		return

	# Enemy morreu
	if not enemy.is_alive():
		change_state(BattleState.END)
		battle_log.clear_log()
		battle_log.add_message("Enemy defeated!")
		return

	# Troca de turno baseada em quem AGIU
	if current_state == BattleState.PLAYER_ACTION:
		change_state(BattleState.ENEMY_TURN)
	elif current_state == BattleState.ENEMY_TURN:
		change_state(BattleState.PLAYER_TURN)
	
	

# =========================
# ESTADOS
# =========================
func on_player_turn():
	battle_log.add_message("Your turn!!!")
	battle_menu.show_menu()
	inventory_ui.hide_inventory()

func on_inventory():
	battle_log.add_message("Choose an item:")
	#battle_menu.hide_menu()
	inventory_ui.show_inventory()

func on_player_action():
	battle_menu.hide_menu()
	inventory_ui.hide_inventory()
	await get_tree().create_timer(1.5).timeout
	check_end_or_next()
		
func on_enemy_turn():
	battle_log.add_message("Enemy turn!")
	await get_tree().create_timer(0.8).timeout
	attack(enemy, player)
	await get_tree().create_timer(1.5).timeout
	check_end_or_next()

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
	
func start_first_turn():
	if first_turn == player:
		change_state(BattleState.PLAYER_TURN)
	else:
		change_state(BattleState.ENEMY_TURN)
		
func pokemon_attack(attacker_sprite: AnimatedSprite2D, direction := 1):
	# direction:
	#  1  = atacante vai pra direita (player)
	# -1  = atacante vai pra esquerda (enemy)

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
