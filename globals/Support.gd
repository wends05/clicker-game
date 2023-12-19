extends Button

func _process(_delta: float) -> void:
	if Globals.supports == 2: text = "Max Supports"

func _ready() -> void:
	connect("pressed", addSupports)

func addSupports() -> void:
	if Globals.supports < 2:
		Globals.supports += 1
		Globals.supportAdded.emit()
