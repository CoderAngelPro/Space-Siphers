extends Control

@export_file("*.tscn") var game_scene_path: String = "res://Scene_Folders/Main_Game/SS_Game.tscn"

const SETTINGS_PATH: String = "user://settings.cfg"

@onready var play_button: Button = %PlayButton
@onready var settings_button: Button = %SettingsButton
@onready var settings_window: AcceptDialog = $SettingsWindow
@onready var volume_slider: HSlider = %VolumeSlider
@onready var volume_value: Label = %VolumeValue
@onready var fullscreen_toggle: CheckButton = %FullscreenToggle
@onready var status_label: Label = %StatusLabel


func _ready() -> void:
	var config := ConfigFile.new()
	config.load(SETTINGS_PATH)
	var volume := clampf(float(config.get_value("audio", "master_volume", 80.0)), 0.0, 100.0)
	var fullscreen := bool(config.get_value("display", "fullscreen", false))
	volume_slider.set_value_no_signal(volume)
	fullscreen_toggle.set_pressed_no_signal(fullscreen)
	_on_volume_changed(volume)
	_on_fullscreen_toggled(fullscreen)
	play_button.grab_focus()


func _on_play_pressed() -> void:
	var error := get_tree().change_scene_to_file(game_scene_path)
	if error != OK:
		status_label.text = "Unable to open the game. Please check the gameplay scene."


func _on_settings_pressed() -> void:
	settings_window.popup_centered(Vector2i(460, 300))
	volume_slider.grab_focus()


func _on_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(maxf(value / 100.0, 0.0001)))
	AudioServer.set_bus_mute(0, is_zero_approx(value))
	volume_value.text = "%d%%" % roundi(value)


func _on_fullscreen_toggled(enabled: bool) -> void:
	if enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_settings_closed() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "master_volume", volume_slider.value)
	config.set_value("display", "fullscreen", fullscreen_toggle.button_pressed)
	if config.save(SETTINGS_PATH) != OK:
		status_label.text = "Settings applied, but could not be saved."
	else:
		status_label.text = ""
	settings_button.grab_focus()


func _on_settings_visibility_changed() -> void:
	if is_node_ready() and not settings_window.visible:
		_on_settings_closed()


func _on_quit_pressed() -> void:
	get_tree().quit()
