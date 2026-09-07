# BoostPad.gd
# Speed boost platform

extends Area2D

export var boost_direction = Vector2.RIGHT
export var boost_speed = 600.0

func _ready():
	add_to_group("boost_pads")
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area):
	if area.name == "CollisionShape2D" and area.get_parent().is_in_group("players"):
		apply_boost(area.get_parent())

func apply_boost(player) -> void:
	player.velocity = boost_direction.normalized() * boost_speed
	AudioManager.play_sfx("res://audio/sfx/boost_pad.ogg")
