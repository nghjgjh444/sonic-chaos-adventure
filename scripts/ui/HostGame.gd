# HostGame.gd
# Host a network game

extends Control

func _on_create_pressed():
	if NetworkManager.host_game():
		get_tree().change_scene("res://scenes/menus/Lobby.tscn")

func _on_back_pressed():
	get_tree().change_scene("res://scenes/menus/MultiplayerMenu.tscn")
