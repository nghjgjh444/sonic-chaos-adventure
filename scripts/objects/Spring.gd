# Spring.gd
# Spring platform

extends Area2D

export var spring_force = 400.0
export var spring_direction = Vector2.UP

var sprite: AnimatedSprite

func _ready():
	add_to_group("springs")
	connect("area_entered", self, "_on_area_entered")
	sprite = $AnimatedSprite if has_node("AnimatedSprite") else null

func _on_area_entered(area):
	if area.name == "CollisionShape2D" and area.get_parent().is_in_group("players"):
		spring(area.get_parent())

func spring(player) -> void:
	if player.has_method("jump"):
		player.velocity = spring_direction.normalized() * spring_force
		AudioManager.play_sfx("res://audio/sfx/spring.ogg")
		
		if sprite:
			sprite.play()
