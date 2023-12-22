extends AudioStreamPlayer2D

func _on_h_slider_value_changed(value : int) -> void:
	$".".volume_db = value
