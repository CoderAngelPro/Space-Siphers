extends Control

@export_file("*.tscn") var game_scene_path: String = "res://Scene_Folders/Main_Game/SS_Game.tscn"

@onready var play_button: Button = %PlayButton
@onready var settings_button: Button = %SettingsButton
@onready var settings_window: AcceptDialog = $SettingsWindow
@onready var fullscreen_toggle: CheckButton = %FullscreenToggle

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(game_scene_path)

func _on_settings_pressed() -> void:
	settings_window.popup_centered(Vector2i(460, 300))

func _on_fullscreen_toggled(enabled: bool) -> void:
	if enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_settings_closed() -> void:
	settings_button.grab_focus()

func _on_settings_visibility_changed() -> void:
	if is_node_ready() and not settings_window.visible:
		_on_settings_closed()

func _on_quit_pressed() -> void:
	get_tree().quit()
