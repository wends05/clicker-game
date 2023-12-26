extends AnimatedSprite2D

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

var normalA : AudioStream = preload("res://Sounds/sfx/slash-21834.mp3")
var critA : AudioStream = preload("res://Sounds/sfx/mixkit-fast-sword-whoosh-2792.wav")

var die : bool = false

func _ready() -> void:
	Globals.connect("enemyAttacked", takeDamage)
	Globals.connect("enemyDied", gainBenefits)
	Globals.bossDied.connect(gainBenefits)
	Globals.supportHealed.connect(supportHealed)
	handleDie()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if not die and Globals.player_ready_to_attack:

				var critRandomizer: float = snapped(randf_range(0, 1), 0.01)

				if critRandomizer <= Globals.crit:
					Globals.player_attacked.emit(true)
					audio.stream = critA
				else:
					Globals.player_attacked.emit(false)
					audio.stream = normalA

				audio.play()

				animator.stop()
				animator.play("attack")
				animator.queue("idle")

func takeDamage(damageTaken: float) -> void:
	Globals.Current_HP -= damageTaken
	handleDie()

func handleDie() -> void:
	die = Globals.Current_HP <= 0
	if die:
		animator.stop()
		animator.play("die")
		Globals.player_ready_to_attack = false
		await animator.animation_finished
		Globals.playerDied.emit()

func gainBenefits(enemy: Sprite2D) -> void:
	Globals.player_exp += enemy.giveExp
	var currentHP = Globals.Current_HP
	if enemy.giveHealth * Globals.lifesteal_multiplier + Globals.Current_HP > Globals.Max_HP:
		Globals.Current_HP = Globals.Max_HP
	else:
		Globals.Current_HP += enemy.giveHealth * Globals.lifesteal_multiplier
	print_debug("The HP received is ", Globals.Current_HP - currentHP)


func supportHealed(pet: Pet) -> void:
	Globals.Current_HP += pet.heal_strength * Globals.support_heal_strength

