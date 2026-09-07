# Spikes.gd
# Hazard: Spike platform

extends Area2D

export var damage = 10

func _ready():
	add_to_group("hazards")
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area):
	if area.name == "CollisionShape2D" and area.get_parent().is_in_group("players"):
		hurt_player(area.get_parent())

func hurt_player(player) -> void:
	if player.has_method("take_damage"):
		player.take_damage(damage)
		player.velocity.y = -200.0 # Knockback
