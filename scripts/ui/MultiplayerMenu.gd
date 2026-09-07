# MultiplayerMenu.gd
# Multiplayer mode selection

extends Control

func _on_local_pressed():
	get_tree().change_scene("res://scenes/menus/Lobby.tscn")

func _on_host_pressed():
	get_tree().change_scene("res://scenes/menus/HostGame.tscn")

func _on_join_pressed():
	get_tree().change_scene("res://scenes/menus/JoinGame.tscn")

func _on_back_pressed():
	get_tree().change_scene("res://scenes/menus/MainMenu.tscn")
