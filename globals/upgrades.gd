extends Control

class_name UI

var UI_Closed : bool = false
var required_checked : bool = false

@onready var Stats : Label = $BoxContainer/Upgrades/Label
@onready var CloseButton : Button = $BoxContainer/Close/Close
@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D


# upgrades that needs to reset when died

func _ready() -> void:
	for upgrade : Node in $BoxContainer/Upgrades.get_children():
		if upgrade is UpgradeButton:
			check_upgrades(upgrade)
	required_checked = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused

func _process(_delta: float) -> void:
	Stats.text = "
		$: %s
		x: %s
		l: %s
		c: %s%%
		s: %s
		a: %s
		h: %s
		" % [
			snapped(Globals.money, 0.01),
			Globals.multiplier,
			Globals.lifesteal_multiplier,
			Globals.crit * 100,
			Globals.supports ,
			Globals.support_speed,
			Globals.support_heal_strength
		]

func _on_close_pressed() -> void:
	var closing : Tween = create_tween()
	if not UI_Closed:
		closing.tween_property(self, "position:x", -256, .5).set_trans(Tween.TRANS_QUAD)
		CloseButton.text = "Open"
		UI_Closed = true
	else:
		closing.tween_property(self, "position:x", 0, .5).set_trans(Tween.TRANS_QUAD)
		CloseButton.text = "Close"
		UI_Closed = false

func update_stat(button: UpgradeButton) -> void:
	audio.play()

	Globals.money -= button.required_money

	match button.name:
		"Multiplier":
			button.required_money += 20
			Globals.multiplier += int(button.increase)
		"Lifesteal":
			button.required_money += 300
			Globals.lifesteal_multiplier += button.increase
		"Crit":
			button.required_money += 60
			Globals.crit += button.increase
		"Support":
			button.required_money += 500
			Globals.supports += int(button.increase)
			Globals.supportAdded.emit()
		"Aspd":
			button.required_money += 300
			Globals.support_speed += button.increase
		"Heal":
			button.required_money += 400
			Globals.support_heal_strength += button.increase
		_:
			push_error("Gaga wala ka button nga muna")
	check_upgrades(button)

func check_upgrades(button : UpgradeButton) -> void:
	var Max : bool
	match button.name:
		"Multiplier":
			if not required_checked: button.required_money += 20 * int(Globals.multiplier - 1)
		"Lifesteal":
			if Globals.lifesteal_multiplier == button.max_upgrade:
				Max = true
			if not required_checked: button.required_money += 500 * ((Globals.lifesteal_multiplier - 0.8) / 0.2 - 1)
		"Crit":
			if Globals.crit == button.max_upgrade:
				Max = true
			if not required_checked: button.required_money += 300 * int(Globals.crit / 0.04 - 1)
		"Support":
			if Globals.supports == button.max_upgrade:
				Max = true
			if not required_checked: button.required_money += 500 * int(Globals.supports)
		"Aspd":
			if Globals.support_speed == button.max_upgrade:
				Max = true
			if not required_checked: button.required_money += 300 * int(Globals.support_speed / 0.3 - 1)
		"Heal":
			if Globals.support_heal_strength == button.max_upgrade:
				Max = true
			if not required_checked: button.required_money += 400 * int((Globals.support_heal_strength - 0.8) / 0.2 - 1)
	if Max: button.disable = true

