extends Control

class_name UI

var UI_Closed : bool = false

@onready var Stats : Label = $BoxContainer/Upgrades/Label
@onready var CloseButton : Button = $BoxContainer/Close/Close

func _ready() -> void:
	for upgrade : Node in $BoxContainer/Upgrades.get_children():
		if upgrade is UpgradeButton:
			check_max_upgrades(upgrade)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused

func _process(_delta: float) -> void:
	Stats.text = "
		$: %s
		x: %s
		c: %s%%
		s: %s
		a: %s
		h: %s
		" % [
			Globals.money,
			Globals.multiplier,
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

func buttonPressed() -> void:
	pass


func update_stat(button: UpgradeButton) -> void:
	print(button)

	Globals.money -= button.required_money

	match button.name:
		"Multiplier":
			button.required_money += 20
			Globals.multiplier += int(button.increase)
		"Lifesteal":
			button.required_money += 300
			Globals.lifesteal_multiplier += button.increase
		"Crit":
			button.required_money += 1
			Globals.crit += button.increase
		"Support":
			button.required_money += 1
			Globals.supports += int(button.increase)
			Globals.supportAdded.emit()
		"Aspd":
			button.required_money += 1
			Globals.support_speed += button.increase
		"Heal":
			button.required_money += 1
			Globals.support_heal_strength += button.increase
		_:
			push_error("Gaga wala ka button nga muna")
	check_max_upgrades(button)

func check_max_upgrades(button : UpgradeButton) -> void:

	var max : bool

	match button.name:
		"Lifesteal":
			if Globals.lifesteal_multiplier == button.max_upgrade:
				max = true
		"Crit":
			if Globals.crit == button.max_upgrade:
				max = true
		"Support":
			if Globals.supports == button.max_upgrade:
				max = true
		"Aspd":
			if Globals.support_speed == button.max_upgrade:
				max = true
		"Heal":
			if Globals.support_heal_strength == button.max_upgrade:
				max = true
	if max:
		button.disable = true

