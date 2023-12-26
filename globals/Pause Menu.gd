extends Control

@onready var sound_system : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var black : ColorRect = $Panel
@onready var autosave : CheckBox = $VBoxContainer/Autosave

func _ready() -> void:
	print(Globals.autosave)
	autosave.button_pressed = Globals.autosave

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		togglePause()

func togglePause() -> void:

	get_tree().paused = get_tree().paused
	visible = not visible
	sound_system.stream_paused = not sound_system.stream_paused

func _on_h_slider_value_changed(value: float) -> void:
	sound_system.volume_db = value

func _on_autosave_toggled(toggled_on: bool) -> void:
	print_debug(toggled_on)
	Globals.autosave = toggled_on
func _on_save_pressed() -> void:
	Globals.save_data()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_reset_pressed() -> void:
	$ConfirmationDialog.visible = true

func _on_confirmation_dialog_2_confirmed() -> void:
	togglePause()
	get_tree().paused = false
	Globals.resetData()
	get_tree().reload_current_scene()

func _on_confirm_reset_confirmed() -> void:
	togglePause()
	get_tree().paused = false
	Globals.resetData()
	get_tree().reload_current_scene()
