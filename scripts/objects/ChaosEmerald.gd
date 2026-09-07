# ChaosEmerald.gd
# Collectible Chaos Emerald

extends Area2D

export var emerald_id = 0
export var emerald_color = Color.green
export var spin_speed = 180.0

var sprite: Sprite

func _ready():
	add_to_group("emeralds")
	connect("area_entered", self, "_on_area_entered")
	sprite = $Sprite if has_node("Sprite") else null
	
	if sprite:
		sprite.modulate = emerald_color

func _process(delta):
	# Spin animation
	if sprite:
		sprite.rotation += deg2rad(spin_speed) * delta

func _on_area_entered(area):
	if area.is_in_group("players") or area.name == "RingCollectionArea":
		collect()

func collect() -> void:
	UnlockManager.collect_emerald(emerald_id)
	AudioManager.play_sfx("res://audio/sfx/emerald.ogg")
	
	if UnlockManager.is_all_emeralds_collected():
		print("All Chaos Emeralds collected! Super Sonic unlocked!")
	
	queue_free()
