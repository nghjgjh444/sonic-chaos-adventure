# Checkpoint.gd
# Checkpoint star

extends Area2D

export var checkpoint_id = 0

var is_active = false
var sprite: Sprite

func _ready():
	add_to_group("checkpoints")
	connect("area_entered", self, "_on_area_entered")
	sprite = $Sprite if has_node("Sprite") else null

func _on_area_entered(area):
	if area.is_in_group("players") and not is_active:
		activate()

func activate() -> void:
	is_active = true
	AudioManager.play_sfx("res://audio/sfx/checkpoint.ogg")
	
	if sprite:
		sprite.modulate = Color.yellow

func get_position_vector() -> Vector2:
	return global_position
