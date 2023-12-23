extends Node2D

@export var HPBar: ProgressBar
@export var EXPBar: ProgressBar
@export var Level: Label

var world1bg : PackedScene = preload("res://scenes/world1/bg.tscn")
var world2bg : PackedScene = preload("res://scenes/world2/bg2.tscn")
var world3bg : PackedScene = preload("res://scenes/world3/bg3.tscn")

@onready var blackbg : AnimationPlayer = $UI/blackbg/AnimationPlayer

func _ready() -> void:
	blackbg.play_backwards("fade")
	match Globals.current_world:
		1:
			add_child(world1bg.instantiate())
		2:
			add_child(world2bg.instantiate())
		3:
			add_child(world3bg.instantiate())

	Globals.bossDied.connect(change_world)

func _process(_delta: float) -> void:
	if HPBar and EXPBar and Level:
		HPBar.value = Globals.Current_HP
		HPBar.max_value = Globals.Max_HP
		EXPBar.value = Globals.player_exp
		EXPBar.max_value = Globals.player_max_exp
		Level.text = str(Globals.player_level)

func change_world(boss : Boss):
	blackbg.play("fade")
	await blackbg.animation_finished
	get_tree().reload_current_scene()
