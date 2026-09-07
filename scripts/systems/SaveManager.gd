# SaveManager.gd
# Handles game save/load functionality

extends Node

var save_data = {}

func _ready():
	set_name("SaveManager")
	load_game()

func initialize_save_data() -> void:
	save_data = {
		"levels": {},
		"emeralds": {
			"collected": 0,
			"locations": []
		},
		"keys": {
			"shadow": false,
			"metal_sonic": false,
			"silver": false
		},
		"characters": {
			"unlocked": [GameConstants.CHARACTER.SONIC, GameConstants.CHARACTER.TAILS, GameConstants.CHARACTER.KNUCKLES]
		},
		"stats": {
			"total_rings": 0,
			"total_score": 0,
			"lives": GameConstants.STARTING_LIVES,
			"best_time": 0
		},
		"settings": {
			"master_volume": 1.0,
			"music_volume": 1.0,
			"sfx_volume": 1.0
		}
	}

func save_game() -> bool:
	var file = File.new()
	var err = file.open(GameConstants.SAVE_FILE, File.WRITE)
	if err != OK:
		print("Error saving game: ", err)
		return false
	
	var json_string = to_json(save_data)
	file.store_string(json_string)
	file.close()
	print("Game saved successfully")
	return true

func load_game() -> bool:
	var file = File.new()
	if not file.file_exists(GameConstants.SAVE_FILE):
		initialize_save_data()
		save_game()
		return true
	
	var err = file.open(GameConstants.SAVE_FILE, File.READ)
	if err != OK:
		print("Error loading game: ", err)
		initialize_save_data()
		return false
	
	var content = file.get_as_text()
	file.close()
	
	var json = JSON.parse(content)
	if json.error:
		print("JSON Parse error: ", json.error_string)
		initialize_save_data()
		return false
	
	save_data = json.result
	print("Game loaded successfully")
	return true

func get_emeralds_collected() -> int:
	return save_data["emeralds"]["collected"]

func add_emerald(emerald_id: int) -> void:
	if emerald_id not in save_data["emeralds"]["locations"]:
		save_data["emeralds"]["locations"].append(emerald_id)
		save_data["emeralds"]["collected"] += 1
		save_game()

func unlock_character(character: int) -> void:
	if character not in save_data["characters"]["unlocked"]:
		save_data["characters"]["unlocked"].append(character)
		save_game()

func is_character_unlocked(character: int) -> bool:
	return character in save_data["characters"]["unlocked"]

func set_lives(lives: int) -> void:
	save_data["stats"]["lives"] = lives
	save_game()

func get_lives() -> int:
	return save_data["stats"]["lives"]
