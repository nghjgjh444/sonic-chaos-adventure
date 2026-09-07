# Lobby.gd
# Local multiplayer lobby

extends Control

var num_players = 2
var selected_characters = []

func _ready():
	set_player_count(2)

func set_player_count(count: int) -> void:
	num_players = clamp(count, 2, 4)
	selected_characters = []
	for i in range(num_players):
		selected_characters.append(GameConstants.CHARACTER.SONIC)

func _on_2_players_pressed():
	set_player_count(2)

func _on_3_players_pressed():
	set_player_count(3)

func _on_4_players_pressed():
	set_player_count(4)

func _on_next_pressed():
	MultiplayerManager.setup_local_multiplayer(selected_characters)
	GameManager.start_local_multiplayer(selected_characters)

func _on_back_pressed():
	get_tree().change_scene("res://scenes/menus/MultiplayerMenu.tscn")
