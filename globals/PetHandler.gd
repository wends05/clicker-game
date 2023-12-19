extends Marker2D


func _ready() -> void:
	Globals.connect("supportAdded", addSupport)

func addSupport() -> void:
	if Globals.supports == 1:
		var Sammy : Pet = preload("res://globals/supports/sammy.tscn").instantiate()
		add_child(Sammy)
	if Globals.supports == 2:
		var posay : Pet = preload("res://globals/supports/bogart.tscn").instantiate()
		add_child(posay)
		posay.position.x += 64
