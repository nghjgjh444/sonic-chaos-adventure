# MultiplayerManager.gd
# Manages multiplayer game state

extends Node

var is_local_multiplayer = false
var player_count = 1
var player_characters = []
var player_ready = []

func _ready():
	set_name("MultiplayerManager")

func setup_local_multiplayer(player_chars: Array) -> void:
	is_local_multiplayer = true
	player_count = player_chars.size()
	player_characters = player_chars.duplicate()
	player_ready = []
	for i in range(player_count):
		player_ready.append(false)

func set_player_ready(player_index: int, ready: bool) -> void:
	if player_index < player_ready.size():
		player_ready[player_index] = ready

func are_all_players_ready() -> bool:
	for ready in player_ready:
		if not ready:
			return false
	return true

func get_player_character(player_index: int) -> int:
	if player_index < player_characters.size():
		return player_characters[player_index]
	return GameConstants.CHARACTER.SONIC

func reset():
	is_local_multiplayer = false
	player_count = 1
	player_characters = []
	player_ready = []
