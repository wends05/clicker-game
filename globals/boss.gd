extends Sprite2D

class_name Boss

@export var Name: String
@export var world: int = 1
@export_category("Stats")

@export var Max_HP: int = 200
@export var Current_HP: float = Max_HP

var die : bool = false

@export var attack: float = 5
@export var speed: float = 1

@export_category("Benefits")

@export var giveHealth: float
@export var giveExp: float

@onready var anim : AnimationPlayer = $AnimationPlayer

@onready var timer : Timer = $Timer
@onready var HPBar : ProgressBar = $CanvasLayer/HP

func _ready() -> void:
	anim.play('spawn')
	anim.queue("idle")

	Current_HP = Max_HP
	giveHealth = Max_HP * 0.15
	giveExp = giveHealth * 1.2 + 3

	Globals.connect("player_attacked", playerAttacked)
	Globals.supportAttacked.connect(petAttacked)

	print_debug(self, " connected")

func _process(_delta: float) -> void:
	HPBar.max_value = Max_HP
	HPBar.value = Current_HP

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
		Globals.player_level += 1
		Globals.player_exp = 0
		Globals.player_ready_to_attack = false

		anim.stop()
		anim.play("die")
		await anim.animation_finished
		Globals.bossDied.emit(self)
		timer.start(1)
		await timer.timeout
		Globals.current_world = world + 1
		Globals.player_exp = 0
		queue_free()


func cooldown() -> void:
	if not die and Globals.player_ready_to_attack:

		var cd : float = 2 / speed
		timer.start(cd)
		print_debug(cd, " : ", get_index())
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
