# CharacterKey.gd
# Key to unlock secret characters

extends Area2D

export var key_type = "shadow" # shadow, metal_sonic, silver
export var character_to_unlock = GameConstants.CHARACTER.SHADOW

var sprite: Sprite

func _ready():
	add_to_group("keys")
	connect("area_entered", self, "_on_area_entered")
	sprite = $Sprite if has_node("Sprite") else null

func _on_area_entered(area):
	if area.is_in_group("players") or area.name == "RingCollectionArea":
		collect()

func collect() -> void:
	UnlockManager.unlock_character(character_to_unlock)
	AudioManager.play_sfx("res://audio/sfx/key.ogg")
	
	print("%s UNLOCKED!" % GameConstants.CHARACTER_NAMES[character_to_unlock])
	
	queue_free()
