# GameManager.gd
# Central game state and level management

extends Node

var current_state = GameConstants.GAME_STATE.MAIN_MENU
var current_level = GameConstants.ZONE.GREEN_HILL
var current_players = []
var is_multiplayer = false
var num_players = 1

# Signals
signal state_changed(new_state)
signal level_loaded(zone)
signal player_added(player_index, character)
signal player_removed(player_index)

func _ready():
	set_name("GameManager")
	# Ensure save directory exists
	var dir = Directory.new()
	if not dir.dir_exists(GameConstants.SAVE_PATH):
		dir.make_absolute(GameConstants.SAVE_PATH)

func _process(delta):
	pass

func change_state(new_state: int) -> void:
	if current_state != new_state:
		current_state = new_state
		emit_signal("state_changed", new_state)

func load_level(zone: int) -> void:
	current_level = zone
	var scene_path = GameConstants.ZONE_SCENES.get(zone)
	if scene_path:
		get_tree().change_scene(scene_path)
		emit_signal("level_loaded", zone)

func start_singleplayer(character: int) -> void:
	is_multiplayer = false
	num_players = 1
	change_state(GameConstants.GAME_STATE.PLAYING)
	load_level(current_level)

func start_local_multiplayer(characters: Array) -> void:
	is_multiplayer = true
	num_players = characters.size()
	current_players = characters
	change_state(GameConstants.GAME_STATE.PLAYING)
	load_level(current_level)

func add_player(character: int, player_index: int) -> void:
	if player_index < current_players.size():
		current_players[player_index] = character
		emit_signal("player_added", player_index, character)

func get_player_character(player_index: int) -> int:
	if player_index < current_players.size():
		return current_players[player_index]
	return GameConstants.CHARACTER.SONIC

func pause_game() -> void:
	get_tree().paused = true
	change_state(GameConstants.GAME_STATE.PAUSED)

func resume_game() -> void:
	get_tree().paused = false
	change_state(GameConstants.GAME_STATE.PLAYING)

func return_to_menu() -> void:
	get_tree().paused = false
	change_state(GameConstants.GAME_STATE.MAIN_MENU)
	get_tree().change_scene("res://scenes/menus/MainMenu.tscn")
