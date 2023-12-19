extends Marker2D

@onready var timer : Timer = $Timer

func _ready() -> void:
	startRound()
	Globals.connect('enemyDied', enemyDiedHandler)

func startRound() -> void:
	Globals.player_ready_to_attack = false
	#if Globals.boss_level:
		#pass
	#else:
	for i : int in range(randi_range(2, 4)):
		timer.start(1)
		await timer.timeout
		identifyEnemy()
	Globals.player_ready_to_attack = true
	enemiesAttack()

func identifyEnemy() -> void:
	match Globals.current_world:
		1:
			var Slime : Node = preload("res://scenes/world1/slime.tscn").instantiate()
			spawnEnemy(Slime)
		_:
			print_debug("no enemy identified")

func spawnEnemy(enemy: Enemy) -> void:
	add_child(enemy)
	enemy.position.x = 64 * (enemy.get_index() - 1)

func enemyDiedHandler(body: Enemy) -> void:
	body.queue_free()
	Globals.player_ready_to_attack = false
	print_debug("Enemy died. Enemy: ", body)
	if get_child_count() == 2:
		startRound()
	else:
		moveEnemies()

func moveEnemies() -> void:
	timer.start(0.1)
	await timer.timeout
	for i : Node in get_children():
		if i.has_method("movePosition"):
			i.movePosition()
		timer.start(1)
		await timer.timeout
	enemiesAttack()

func enemiesAttack() -> void:
	Globals.player_ready_to_attack = true
	for i : Node in get_children():
		if i.has_method("enemyAttack"):
			i.enemyAttack()
	Globals.readyToAttack.emit()


