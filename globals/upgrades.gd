extends Control

class_name UI

var UI_Closed : bool = false

@onready var Stats : Label = $BoxContainer/Upgrades/Label
@onready var CloseButton : Button = $BoxContainer/Close/Close

func _ready() -> void:
	pass

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

	button.upgrades += 1
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
