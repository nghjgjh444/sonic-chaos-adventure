# Ring.gd
# Collectible ring

extends Area2D

export var ring_value = 1
export var float_height = 20.0
export var float_speed = 2.0

var initial_y = 0.0
var time = 0.0

func _ready():
	add_to_group("rings")
	initial_y = global_position.y
	connect("area_entered", self, "_on_area_entered")

func _process(delta):
	# Gentle floating animation
	time += delta
	global_position.y = initial_y + sin(time * float_speed) * float_height

func _on_area_entered(area):
	if area.is_in_group("players") or area.name == "RingCollectionArea":
		collect()

func collect() -> void:
	if get_parent().has_method("add_rings"):
		get_parent().add_rings(ring_value)
	
	AudioManager.play_sfx("res://audio/sfx/ring.ogg")
	queue_free()
