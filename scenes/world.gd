extends Node2D

@export var HPBar: ProgressBar
@export var EXPBar: ProgressBar
@export var Level: Label

# handle pets
const SAVE_GAN_FILE = "res://SAVEDATA.dat"
# Called when the node enters the scene tree for the first time.
func _ready() -> void :
	var file = FileAccess.open(SAVE_GAN_FILE, FileAccess.READ)
	if FileAccess.file_exists(SAVE_GAN_FILE) == true :
		if not file.eof_reached() :
			var savers = JSON.parse_string(file.get_line())
			if savers :
				Globals.multiplier = savers["Multiplier"]
				Globals.Current_HP = savers["Health"]
				Globals.lifesteal_multiplier = savers["Lifesteal"]
				Globals.support_heal_strength = savers["Heal"]
				Globals.crit = savers["Critical"]
				Globals.support_speed = savers["Attack Speed"]
				Globals.supports = savers["Support"]
				Globals.player_exp = savers["EXP"]
				Globals.player_level = savers["Level"]
				Globals.money = savers["Money"]

func _process(_delta: float) -> void:
	HPBar.value = Globals.Current_HP
	HPBar.max_value = Globals.Max_HP
	EXPBar.value = Globals.player_exp
	EXPBar.max_value = Globals.player_max_exp
	Level.text = str(Globals.player_level)


func verify_safe_directory(path : String) :
	DirAccess.make_dir_absolute(path)

func _on_quit_pressed():
	var file = FileAccess.open(SAVE_GAN_FILE, FileAccess.WRITE)
	var data : Dictionary = {
		"Health" : Globals.Current_HP,
		"Level" : Globals.player_level,
		"Multiplier" : Globals.multiplier,
		"Money" : Globals.money,
		"Heal" :  Globals.support_heal_strength,
		"EXP" : Globals.player_exp,
		"Support" : Globals.supports,
		"Critical" : Globals.crit,
		"Attack Speed" : Globals.support_speed,
		"Lifesteal" : Globals.lifesteal_multiplier
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)

	get_tree().quit()
