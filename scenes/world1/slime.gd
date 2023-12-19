extends Sprite2D

class_name Enemy

@export var Name: String

@export_category("Stats")

@export var Max_HP: int = 10
@export var Current_HP: float = Max_HP

var die : bool = false

@export var attack: float = 2.5
@export var speed: float = 1

@export_category("Benefits")

@export var giveHealth: float
@export var giveExp: float

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var HP : ProgressBar = $HP
@onready var timer : Timer = $Timer

func _ready() -> void:
	anim.play('spawn')
	anim.queue("idle")
	print_debug(get_index())

	# set stats based on player level

	if Globals.player_level > 0:
		Max_HP = 50 + Globals.player_level * 2

	Current_HP = Max_HP
	giveHealth = Max_HP * 0.15
	giveExp = giveHealth * 1.2 + 3

	if get_index() == 1:
		Globals.connect("player_attacked", playerAttacked)
		Globals.connect("supportAttacked", petAttacked)

func _process(_delta: float) -> void:
	HP.max_value = Max_HP
	HP.value = Current_HP

func playerAttacked(crit: bool) -> void:
	if not die:
		print_debug(crit, " crit")
		# money returned
		if Globals.multiplier * (2 if crit else 1) > Current_HP:
			Globals.money += Current_HP
		else: Globals.money += Globals.multiplier * (2 if crit else 1)

		Current_HP -= Globals.multiplier * 2 if crit else Globals.multiplier
		handleDie()

func petAttacked(pet: Pet) -> void:
	if not die:
		Current_HP -= pet.attack_multiplier * Globals.multiplier
		handleDie()

func handleDie() -> void:
	die =  (Current_HP <= 0)
	if die:
		anim.stop()
		anim.play("die")
		await anim.animation_finished
		Globals.emit_signal('enemyDied', self)

func movePosition() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(self, "position:x", position.x - 64, 0.6)
	anim.stop()
	anim.play("move")
	anim.queue("idle")
	if get_index() == 1 and not Globals.is_connected("player_attacked", playerAttacked):
		Globals.connect("player_attacked", playerAttacked)

func cooldown() -> void:
	if not die and Globals.player_ready_to_attack:

		var cd : float = speed * get_index()
		timer.start(cd)
		await timer.timeout
		enemyAttack()

func enemyAttack() -> void:
	if not die and Globals.player_ready_to_attack:
		timer.start(speed * 0.5 * get_index())
		await timer.timeout
		if not die and Globals.player_ready_to_attack:
			anim.stop()
			anim.play("attack")
			anim.queue("idle")
			timer.start(0.6)

			await timer.timeout
			Globals.enemyAttacked.emit(attack)
			if not die and Globals.player_ready_to_attack:
				cooldown()



