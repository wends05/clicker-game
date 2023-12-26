extends Sprite2D

class_name Enemy

@export var Name: String

@export_category("Stats")

@export var Max_HP: int = 10
@export var Current_HP: float = Max_HP

var die : bool = false

@export var attack: float = 3
@export var speed: float = 1

@export_category("Benefits")

@export var giveHealth: float = 10
var giveExp: float

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var HP : ProgressBar = $HP
@onready var timer : Timer = $Timer

func _ready() -> void:
	anim.play('spawn')
	anim.queue("idle")

	# set stats based on player level

	if Globals.player_level > 0:
		Max_HP += 50 + Globals.player_level ** 2

	print_debug("Enemy HP is: ", Max_HP)

	attack += Globals.player_level
	Current_HP = Max_HP

	giveHealth += giveHealth * 0.15 + Max_HP * 0.02
	giveExp = giveHealth * 1.2 + 2

	if get_index() == 1:
		Globals.connect("player_attacked", playerAttacked)
		Globals.supportAttacked.connect(petAttacked)

func _process(_delta: float) -> void:
	HP.max_value = Max_HP
	HP.value = Current_HP

func playerAttacked(crit: bool) -> void:
	if not die:
		# money returned
		if Globals.multiplier * (2 if crit else 1) > Current_HP:
			Globals.money += int(Current_HP)
		else: Globals.money += Globals.multiplier * (2 if crit else 1)

		Current_HP -= Globals.multiplier * 2 if crit else Globals.multiplier
		handleDie()

func petAttacked(damage : float) -> void:
	if not die:
		Current_HP -= damage
		Globals.money += damage
		handleDie()

func handleDie() -> void:
	die =  (Current_HP <= 0)
	if die:
		Globals.player_ready_to_attack = false
		anim.stop()
		anim.play("die")
		await anim.animation_finished
		Globals.enemyDied.emit(self)

func movePosition() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(self, "position:x", position.x - 64, 0.6)
	anim.stop()
	anim.play("move")
	anim.queue("idle")
	if get_index() == 1 and not Globals.is_connected("player_attacked", playerAttacked):
		Globals.connect("player_attacked", playerAttacked)
		Globals.supportAttacked.connect(petAttacked)

func cooldown() -> void:
	if not die and Globals.player_ready_to_attack:

		var cd : float = 2 * get_index() / (speed)
		timer.start(cd)
		await timer.timeout
		enemyAttack()

func enemyAttack() -> void:
	if not die and Globals.player_ready_to_attack:
		anim.stop()
		anim.play("attack")
		anim.queue("idle")
		timer.start(0.6)

		await timer.timeout
		Globals.enemyAttacked.emit(attack)
		if not die and Globals.player_ready_to_attack:
			cooldown()



