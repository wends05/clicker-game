extends Node

#player variables
var Max_HP: int = 100
var Current_HP: float = 100

var money: float = 0
var multiplier: int = 1
var lifesteal_multiplier: float = 1
var crit: float = 0.04

var player_level: int = 1
var player_exp: float = 5
var player_max_exp: int = 10

var supports: int = 0
var support_speed: float = 0.3
var support_heal_strength: float = 1

#world variables
var current_world: int = 1
var boss_level: bool = true

var autosave : bool

#state (?) variables
var player_ready_to_attack: bool = false

#interaction signals
signal player_attacked(crit: bool)
signal readyToAttack
signal playerDied

signal enemyDied(enemy: Enemy)
signal enemyAttacked(damage: float)

signal bossDied(boss: Boss)

signal supportAdded

signal supportAttacked(damage : float)
signal supportHealed(amount : float)

var data : Dictionary

func _process(_delta: float) -> void:

	# increase level if full exp
	if player_exp >= player_max_exp:
		player_exp = player_exp - player_max_exp
		player_level += 1

	# increase HP and exp requirement after leveling
	# after level 0
	if player_level > 0:
		player_max_exp = 60 + player_level * 2
		Max_HP = 100 + player_level * 7

	# check for boss level: level 10, 20 and 30
	if player_level == 10 or player_level == 20 or player_level == 30:
		boss_level = true
	else: boss_level = false

# save and load function

const SAVE_FILE_PATH : String = "res://SAVEDATA.json"

func _ready() -> void:

	player_ready_to_attack = false

	var file : FileAccess = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_FILE_PATH):
		if not file.eof_reached():

			var saved : Variant = JSON.parse_string(file.get_line())

			if saved:

				Max_HP = saved["Max_HP"]
				Current_HP = saved["Current_HP"]
				money = saved["Money"]
				multiplier = saved["multiplier"]

				lifesteal_multiplier = saved["lifesteal"]
				crit = saved["crit"]

				player_level = saved["player_level"]
				player_exp = saved["player_exp"]
				player_max_exp = saved["player_max_exp"]

				supports = saved["supports"]
				support_speed = saved["support_speed"]
				support_heal_strength = saved["support_heal_strength"]

				current_world = saved["current_world"]
				boss_level = saved["boss_level"]

				autosave = saved["autosave"]

	save_data()

func _exit_tree() -> void:
	var file_new : FileAccess = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)

	if autosave:
		save_data()

	data["autosave"] = autosave
	file_new.store_line(JSON.stringify(data))

func save_data() -> void:
	data = {
			"Max_HP" : Max_HP,
			"Current_HP" : Current_HP,
			"Money" : money,
			"multiplier" : multiplier,

			"lifesteal" : lifesteal_multiplier,
			"crit" : crit,

			"player_level" : player_level,
			"player_exp" : player_exp,
			"player_max_exp" : player_max_exp,

			"supports" : supports,
			"support_speed" : support_speed,
			"support_heal_strength" : support_heal_strength,

			"current_world" : current_world,
			"boss_level" : boss_level,
		}

func resetData() -> void:
	Max_HP = 100
	Current_HP = 100

	money = 0
	multiplier = 1
	lifesteal_multiplier = 1
	crit = 0.04

	player_level = 0
	player_exp = 0
	player_max_exp = 10

	supports = 0
	support_speed = 0.3
	support_heal_strength = 1

	current_world = 1
	boss_level = true

func respawn() -> void:
	Current_HP = Max_HP
	multiplier /= 2
	money /= 2
	lifesteal_multiplier = 2
