extends Sprite2D

class_name Pet

@export var Name: String

@export_category("Stats")

@export var attack_multiplier: float = 0.5
@export var speed: float = 1
@export var heal_strength: float = 2

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

func _ready() -> void:
	anim.play("idle")
	Globals.connect("readyToAttack", pet_attack)
	pet_attack()

func cooldown() -> void:

	timer.start(speed)
	await timer.timeout
	if Globals.player_ready_to_attack:
		pet_attack()

func pet_attack() -> void:
	if Globals.player_ready_to_attack:
		anim.stop()
		anim.play("attack")
		anim.queue("idle")

		timer.start(0.4)
		await timer.timeout

		Globals.supportAttacked.emit(self)

	timer.start(speed)
	await timer.timeout

	anim.stop()
	anim.play("heal")
	timer.start(0.3)

	await timer.timeout
	Globals.supportHealed.emit(self)

	await anim.animation_finished
	anim.queue("idle")

	if Globals.player_ready_to_attack:
		cooldown()
