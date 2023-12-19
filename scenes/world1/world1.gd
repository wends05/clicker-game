extends Node2D

@export var HPBar: ProgressBar
@export var EXPBar: ProgressBar
@export var Level: Label

# handle pets



func _process(_delta: float) -> void:
	HPBar.value = Globals.Current_HP
	HPBar.max_value = Globals.Max_HP
	EXPBar.value = Globals.player_exp
	EXPBar.max_value = Globals.player_max_exp
	Level.text = str(Globals.player_level)
