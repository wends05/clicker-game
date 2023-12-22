extends Node

#player variables
var Max_HP: int = 100
var Current_HP: float = 100

var money: float = 2000
var multiplier: int = 1
var lifesteal_multiplier: float = 1
var crit: float = 0.04

var player_level: int = 1
var player_exp: float = 5
var player_max_exp: int = 10

var supports: int = 0
var support_speed: float = 3
var support_heal_strength: float = 1

#world variables
var current_world: int = 1
var boss_level: bool = true

#state (?) variables
var player_ready_to_attack: bool = false

#interaction signals
signal player_attacked(crit: bool)
signal readyToAttack

signal enemyDied(enemy: Enemy)
signal enemyAttacked(damage: float)

signal bossDied(boss: Boss)

signal supportAdded

signal supportAttacked(pet: Pet)
signal supportHealed(pet: Pet)

func _process(_delta: float) -> void:

	if player_exp >= player_max_exp:
		player_exp = player_exp - player_max_exp
		player_level += 1

	# levels
	if player_level > 0:
		player_max_exp = 60 + player_level * 2

	# check for boss level: level 10, 20 and 30
	if player_level == 5 or player_level == 10 or player_level == 15:
		boss_level = true
	else: boss_level = false







