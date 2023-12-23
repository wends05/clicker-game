extends Marker2D

@onready var timer : Timer = $Timer

func _ready() -> void:
	# wait for animation
	timer.start(1)
	await timer.timeout

	startRound()
	Globals.connect('enemyDied', enemyDiedHandler)
	#Globals.bossDied.connect(bossDiedHandler)

func startRound() -> void:
	Globals.player_ready_to_attack = false
	if Globals.boss_level:
		identifyBoss()
		Globals.player_ready_to_attack = true
	else:
		for i : int in range(randi_range(2, 4)):
			timer.start(1)
			await timer.timeout
			identifyEnemy()
		Globals.player_ready_to_attack = true
	enemiesAttack()

func identifyEnemy() -> void:
	match Globals.current_world:
		1:
			var Slime : Enemy = preload("res://scenes/world1/slime.tscn").instantiate()
			spawnEnemy(Slime)
		2:
			var Multo : Enemy = preload("res://scenes/world2/multo.tscn").instantiate()
			spawnEnemy(Multo)
		_:
			print_debug("no enemy identified, spawning slime for the meantime")
			var Slime : Enemy = preload("res://scenes/world1/slime.tscn").instantiate()
			spawnEnemy(Slime)

func identifyBoss() -> void:
	match Globals.current_world:
		1:
			var Chakadoll : Boss = preload("res://scenes/world1/boss_1.tscn").instantiate()
			spawnEnemy(Chakadoll)
		2:
			var Witch : Boss = preload("res://scenes/world2/witch.tscn").instantiate()
			spawnEnemy(Witch)

func spawnEnemy(enemy: Sprite2D) -> void:
	add_child(enemy)
	if enemy is Boss:
		enemy.position.x = 128
	else:
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
		if i is Enemy:
			i.movePosition()
		timer.start(1)
		await timer.timeout
	enemiesAttack()

func enemiesAttack() -> void:
	Globals.player_ready_to_attack = true
	for i : Node in get_children():
		if i is Enemy or i is Boss:
			i.cooldown()
	Globals.readyToAttack.emit()


