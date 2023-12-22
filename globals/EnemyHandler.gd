extends Marker2D

@onready var timer : Timer = $Timer

func _ready() -> void:
	startRound()
	Globals.connect('enemyDied', enemyDiedHandler)

func startRound() -> void:
	Globals.player_ready_to_attack = false
	if Globals.boss_level:
		identifyBoss()
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
		_:
			print_debug("no enemy identified")

func identifyBoss() -> void:
	match Globals.current_world:
		1:
			var Chakadoll : Boss = preload("res://scenes/world1/boss_1.tscn").instantiate()
			spawnEnemy(Chakadoll)


func spawnEnemy(enemy: Sprite2D) -> void:
	add_child(enemy)
	if enemy is Boss:
		enemy.position.x = 64
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

func bossDiedHandler(boss: Boss) -> void:
	Globals.player_ready_to_attack = true

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
		if i is Enemy:
			i.cooldown()
	Globals.readyToAttack.emit()


