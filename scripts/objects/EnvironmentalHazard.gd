# EnvironmentalHazard.gd
# Configurable environmental hazard

extends Area2D

export var hazard_type = "generic" # lava, ice, wind, etc
export var damage = 5
export var effect_duration = 1.0

func _ready():
	add_to_group("hazards")
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area):
	if area.name == "CollisionShape2D" and area.get_parent().is_in_group("players"):
		affect_player(area.get_parent())

func affect_player(player) -> void:
	match hazard_type:
		"lava":
			if player.has_method("take_damage"):
				player.take_damage(damage)
		"ice":
			if player.has_method("_ready"):
				player.deceleration *= 0.5
				yield(get_tree().create_timer(effect_duration), "timeout")
				player.deceleration /= 0.5
		"wind":
			if player.has_method("_ready"):
				player.velocity.x *= 1.5
		_:
			if player.has_method("take_damage"):
				player.take_damage(damage)
