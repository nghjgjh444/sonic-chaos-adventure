# CharacterManager.gd
# Manages character data and properties

extends Node

var character_data = {}

func _ready():
	set_name("CharacterManager")
	initialize_characters()

func initialize_characters() -> void:
	character_data = {
		GameConstants.CHARACTER.SONIC: {
			"name": "Sonic",
			"max_speed": 350.0,
			"acceleration": 2000.0,
			"deceleration": 1500.0,
			"jump_force": 500.0,
			"attack_damage": 10,
			"defense": 100,
			"ability": "Spindash"
		},
		GameConstants.CHARACTER.TAILS: {
			"name": "Tails",
			"max_speed": 300.0,
			"acceleration": 1800.0,
			"deceleration": 1300.0,
			"jump_force": 480.0,
			"attack_damage": 8,
			"defense": 90,
			"ability": "Flight"
		},
		GameConstants.CHARACTER.KNUCKLES: {
			"name": "Knuckles",
			"max_speed": 280.0,
			"acceleration": 1700.0,
			"deceleration": 1200.0,
			"jump_force": 520.0,
			"attack_damage": 12,
			"defense": 120,
			"ability": "Climb/Glide"
		},
		GameConstants.CHARACTER.SHADOW: {
			"name": "Shadow",
			"max_speed": 360.0,
			"acceleration": 2100.0,
			"deceleration": 1600.0,
			"jump_force": 510.0,
			"attack_damage": 11,
			"defense": 110,
			"ability": "Chaos Control"
		},
		GameConstants.CHARACTER.METAL_SONIC: {
			"name": "Metal Sonic",
			"max_speed": 380.0,
			"acceleration": 2200.0,
			"deceleration": 1700.0,
			"jump_force": 490.0,
			"attack_damage": 13,
			"defense": 130,
			"ability": "Overdrive"
		},
		GameConstants.CHARACTER.SILVER: {
			"name": "Silver",
			"max_speed": 320.0,
			"acceleration": 1900.0,
			"deceleration": 1400.0,
			"jump_force": 500.0,
			"attack_damage": 9,
			"defense": 100,
			"ability": "Psychokinesis"
		}
	}

func get_character_data(character: int) -> Dictionary:
	return character_data.get(character, {})

func get_character_stat(character: int, stat: String):
	var data = get_character_data(character)
	return data.get(stat, null)
