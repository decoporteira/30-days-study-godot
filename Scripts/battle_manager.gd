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

enum BattleState { 
	PLAYER_TURN,
	PLAYER_ACTION,
	INVENTORY,
	ENEMY_TURN,
	END
}

var current_state : BattleState
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var battle_log_scene = preload("res://Scenes/battle_log.tscn")
	battle_log = battle_log_scene.instantiate()
	add_child(battle_log)

	var player_scene = preload("res://Scenes/player.tscn")
	player = player_scene.instantiate()
	add_child(player)
	
	
	var enemy_scene = preload("res://Scenes/enemy.tscn")
	enemy = enemy_scene.instantiate()
	add_child(enemy)
	
	
	var inventory_scene = preload("res://Scenes/inventory.tscn")
	inventory = inventory_scene.instantiate()
	add_child(inventory)
	#player life bar
	var player_life_bar_scene = preload("res://Scenes/player_life_bar.tscn")
	player_life_bar = player_life_bar_scene.instantiate()
	add_child(player_life_bar)
	
	#enemy life bar
	var enemy_life_bar_scene = preload("res://Scenes/enemy_life_bar.tscn")
	enemy_life_bar = enemy_life_bar_scene.instantiate()
	add_child(enemy_life_bar)
	
	#inventoty ui
	var inventory_ui_scene = preload("res://Scenes/inventory_ui.tscn")
	inventory_ui = inventory_ui_scene.instantiate()
	add_child(inventory_ui)
	inventory_ui.player = player
	inventory_ui.update_inventory()
	
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
	inventory_ui.item_selected.connect(
	Callable(self, "_on_item_selected")
)
	inventory.player = player
	
	var battle_menu_scene = preload("res://Scenes/battle_menu.tscn")
	battle_menu = battle_menu_scene.instantiate()
	add_child(battle_menu)
	battle_menu.battle_manager = self
	#mensagem inicial
	battle_log.add_message("You encouter a furious " + enemy.character_name + ". It wants to fight!")
	start_battle()
	
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
	change_state(BattleState.INVENTORY)
	
func run_away():
	battle_log.add_message("You tried to escape...")
	var run_away_percentage = rng.randf_range(0.0, 100.0)
	if run_away_percentage >= 50:
		battle_log.add_message(".. and you were sucessful! ")
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
	print("Entrou em func attack")
	if attacker.inventory.size() == 0:
		print("Nao tem arma")
		battle_log.add_message(attacker.character_name + " has no weapon.")
		return
	print("Ataque continua")
	var weapon = attacker.inventory[0]
	var damage = weapon.hp

	battle_log.add_message(
		attacker.character_name + " attacked with " + weapon.name +
		" and dealt " + str(damage) + " damage."
	)

	defender.take_damage(damage)
	
	if not defender.is_alive():
		if defender.type == "enemy":
			battle_log.add_message(defender.character_name + " was defeated!")
		else:
			battle_log.add_message("You died. Game Over!")

# =========================
# CONTROLE DE FLUXO
# =========================
func start_battle():
	change_state(BattleState.PLAYER_TURN)

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
	battle_menu.hide_menu()
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
