# Monitor.gd
# Power-up monitor (breakable item box)

extends Area2D

export var monitor_type = "shield" # shield, rings, life, invincible, speed_shoes
export var monitor_value = 1

var is_broken = false
var sprite: Sprite

func _ready():
	add_to_group("monitors")
	connect("area_entered", self, "_on_area_entered")
	sprite = $Sprite if has_node("Sprite") else null

func _on_area_entered(area):
	if not is_broken and (area.name == "AttackArea" or area.name == "CollisionShape2D"):
		if area.get_parent().is_in_group("players") or area.get_parent().enemy_type:
			break_monitor(area.get_parent())

func break_monitor(breaker) -> void:
	if is_broken:
		return
	
	is_broken = true
	AudioManager.play_sfx("res://audio/sfx/monitor_break.ogg")
	
	if sprite:
		sprite.modulate = Color.gray
	
	apply_effect(breaker)
	
	yield(get_tree(), "idle_frame")
	queue_free()

func apply_effect(player) -> void:
	match monitor_type:
		"shield":
			if player.has_method("set_shield"):
				player.set_shield("basic")
		"rings":
			if player.has_method("add_rings"):
				player.add_rings(monitor_value * 10)
		"life":
			if player.has_method("_ready"):
				pass # TODO: Add life
		"invincible":
			if player.has_method("_ready"):
				player.is_invincible = true
				player.invincible_timer = 10.0
		"speed_shoes":
			if player.has_method("_ready"):
				player.max_speed *= 1.5
				yield(get_tree().create_timer(10.0), "timeout")
				player.max_speed /= 1.5
