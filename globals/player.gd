extends AnimatedSprite2D

@onready var animator: AnimationPlayer = $AnimationPlayer
var die : bool = false

func _ready() -> void:
	Globals.connect("enemyAttacked", takeDamage)
	Globals.connect("enemyDied", gainBenefits)
	Globals.supportHealed.connect(supportHealed)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if not die and Globals.player_ready_to_attack:

				var critRandomizer: float = snapped(randf_range(0, 1), 0.01)

				if critRandomizer <= Globals.crit:
					Globals.player_attacked.emit(true)
				else:
					Globals.player_attacked.emit(false)

				animator.stop()
				animator.play("attack")
				animator.queue("idle")

func takeDamage(damageTaken: float) -> void:
	Globals.Current_HP -= damageTaken

func handleDie() -> void:
	die = Globals.Current_HP <= 0
	if die:
		animator.stop()
		animator.play("die")

func gainBenefits(enemy: Enemy) -> void:
	Globals.player_exp += enemy.giveExp

	print(enemy.giveHealth + Globals.Current_HP, " ", Globals.Max_HP)
	if enemy.giveHealth * Globals.lifesteal_multiplier + Globals.Current_HP > Globals.Max_HP:
		Globals.Current_HP = Globals.Max_HP
	else:
		Globals.Current_HP += enemy.giveHealth * Globals.lifesteal_multiplier

func supportHealed(pet: Pet) -> void:
	Globals.Current_HP += pet.heal_strength * Globals.support_heal_strength
