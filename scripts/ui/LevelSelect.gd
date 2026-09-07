# LevelSelect.gd
# Level/Zone selection

extends Control

func _ready():
	pass

func _on_green_hill_pressed():
	GameManager.load_level(GameConstants.ZONE.GREEN_HILL)

func _on_chemical_pressed():
	GameManager.load_level(GameConstants.ZONE.CHEMICAL)

func _on_sandopolis_pressed():
	GameManager.load_level(GameConstants.ZONE.SANDOPOLIS)

func _on_emerald_coast_pressed():
	GameManager.load_level(GameConstants.ZONE.EMERALD_COAST)

func _on_city_escape_pressed():
	GameManager.load_level(GameConstants.ZONE.CITY_ESCAPE)

func _on_back_pressed():
	get_tree().change_scene("res://scenes/menus/MainMenu.tscn")
