extends Node2D

@export var HPBar: ProgressBar
@export var EXPBar: ProgressBar
@export var Level: Label

var world1bg = preload("res://scenes/world1/bg.tscn")
var world2bg = preload("res://scenes/world2/bg2.tscn")
var world3bg = preload("res://scenes/world3/bg3.tscn")


func _ready() -> void:
	match Globals.current_world:
		1:
			add_child(world1bg.instantiate())
		2:
			add_child(world2bg)
		3:
			add_child(world3bg)

func _process(_delta: float) -> void:
	if HPBar and EXPBar and Level:
		HPBar.value = Globals.Current_HP
		HPBar.max_value = Globals.Max_HP
		EXPBar.value = Globals.player_exp
		EXPBar.max_value = Globals.player_max_exp
		Level.text = str(Globals.player_level)
