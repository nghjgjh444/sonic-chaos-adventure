# JoinGame.gd
# Join a network game

extends Control

func _on_join_pressed():
	var ip = $VBoxContainer/IPInput.text
	if ip.empty():
		ip = "127.0.0.1"
	
	if NetworkManager.join_game(ip):
		get_tree().change_scene("res://scenes/menus/Lobby.tscn")

func _on_back_pressed():
	get_tree().change_scene("res://scenes/menus/MultiplayerMenu.tscn")
