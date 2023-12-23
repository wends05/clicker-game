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

	# set stats based on player level

	if Globals.player_level > 0:
		Max_HP = 50 + Globals.player_level * 2

	Current_HP = Max_HP
	giveHealth = Max_HP * 0.15
	giveExp = giveHealth * 1.2 + 3

	if get_index() == 1:
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

func petAttacked(pet: Pet) -> void:
	print_debug(pet)

	var damage : float = pet.attack_multiplier * Globals.multiplier

	if not die:
		print(Current_HP)
		Current_HP -= damage
		Globals.money += damage
		print(Current_HP)
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

		Globals.current_world = world + 1
		queue_free()

func movePosition() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(self, "position:x", position.x - 64, 0.6)
	anim.stop()
	anim.play("move")
	anim.queue("idle")
	if get_index() == 1 and not Globals.is_connected("player_attacked", playerAttacked):
		Globals.connect("player_attacked", playerAttacked)
		Globals.supportAttacked.connect(petAttacked)

		print_debug(self, " connected")

func cooldown() -> void:
	if not die and Globals.player_ready_to_attack:

		var cd : float = 3 / (speed * get_index())
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
