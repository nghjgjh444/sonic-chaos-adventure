# SettingsMenu.gd
# Settings menu

extends Control

func _on_back_pressed():
	get_tree().change_scene("res://scenes/menus/MainMenu.tscn")
