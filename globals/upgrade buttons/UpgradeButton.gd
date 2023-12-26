extends Button

class_name UpgradeButton

@export var increase : float = 1
@export var required_money : int = 50
@export var required_level : int = 1
@export var max_upgrade : float = -1

var disable : bool = false

@export var ui : UI

signal update_stat(button: UpgradeButton)

var upgradeable: bool

func _ready() -> void:
	connect("pressed", upgrade)
	Globals.playerDied.connect(reset_upgrade_button)

func _process(_delta: float) -> void:
	upgradeable = Globals.money >= required_money and Globals.player_level >= required_level

	if disable:
		disabled = true
		text = "Max Upgrade"
	elif upgradeable:
		disabled = false
		text = "Upgrade: +%s" % increase
	else:
		disabled = true
		text = "money: %s\nlevel: %s" % [
			required_money, required_level
			]

func upgrade() -> void:
	if upgradeable:
		ui.update_stat(self)

func reset_upgrade_button() -> void:
	pass
