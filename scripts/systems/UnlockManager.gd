# UnlockManager.gd
# Manages character unlocks and progression

extends Node

signal character_unlocked(character)
signal emerald_collected(emerald_id)
signal key_found(key_type)

func _ready():
	set_name("UnlockManager")

func unlock_character(character: int) -> void:
	if SaveManager.is_character_unlocked(character):
		return
	
	SaveManager.unlock_character(character)
	emit_signal("character_unlocked", character)

func collect_emerald(emerald_id: int) -> void:
	SaveManager.add_emerald(emerald_id)
	emit_signal("emerald_collected", emerald_id)

func is_all_emeralds_collected() -> bool:
	return SaveManager.get_emeralds_collected() >= GameConstants.TOTAL_EMERALDS

func reset_progress() -> void:
	SaveManager.initialize_save_data()
	SaveManager.save_game()
