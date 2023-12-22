extends Button

class_name UpgradeButton

@export var increase: float = 1
@export var required_money : int = 50
@export var required_level : int = 1
@export var max_upgrades: int = -1
@export var ui: UI
var upgrades: int = 0

signal update_stat(button: UpgradeButton)

var upgradeable: bool

func _ready() -> void:
	connect("pressed", upgrade)

func _process(_delta: float) -> void:
	upgradeable = Globals.money >= required_money and Globals.player_level >= required_level and upgrades != max_upgrades
	if upgradeable:
		disabled = false
		text = "Upgrade: +%s" % increase
	elif upgrades == max_upgrades:
		disabled = true
		text = "Max Upgrades"
	else:
		disabled = true
		text = "money: %s\nlevel: %s" % [
			required_money, required_level
			]

func upgrade() -> void:
	if upgradeable:
		ui.update_stat(self)
		# play sound nga sucessful
	else:
		#play sound nga sucessful
		pass
