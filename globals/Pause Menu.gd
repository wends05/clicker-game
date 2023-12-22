extends Control

@onready var sound_system : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var black : ColorRect = $Panel

func _on_h_slider_value_changed(value: float) -> void:
	sound_system.volume_db = value

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = get_tree().paused
		visible = not visible
