extends Label

@onready var timer : Timer = $Timer

func _ready() -> void:
	text = ""


func write() -> void:
	var displays : Array[String] = ["Boss incoming!", "Get ready for the boss.", "Warning!", "Prepare yourself"]

	var pick_line : String = displays[ randi_range(0, len(displays) - 1) ]

	for letter : String in pick_line:
		text += letter
		if letter not in "',: ":
			timer.start(0.1)
			await timer.timeout
