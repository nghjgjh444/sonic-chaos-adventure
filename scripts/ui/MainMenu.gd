# MainMenu.gd
# Main menu navigation

extends Control

func _ready():
	GameManager.change_state(GameConstants.GAME_STATE.MAIN_MENU)
	AudioManager.play_music("res://audio/music/menu.ogg")

func _on_start_pressed():
	get_tree().change_scene("res://scenes/menus/CharacterSelect.tscn")

func _on_multiplayer_pressed():
	get_tree().change_scene("res://scenes/menus/MultiplayerMenu.tscn")

func _on_level_select_pressed():
	get_tree().change_scene("res://scenes/menus/LevelSelect.tscn")

func _on_character_select_pressed():
	get_tree().change_scene("res://scenes/menus/CharacterSelect.tscn")

func _on_emeralds_pressed():
	get_tree().change_scene("res://scenes/menus/ChaosEmeraldMenu.tscn")

func _on_settings_pressed():
	get_tree().change_scene("res://scenes/menus/SettingsMenu.tscn")

func _on_quit_pressed():
	get_tree().quit()
