# BasicBadnik.gd
# Basic enemy type

extends Enemy

class_name BasicBadnik

func _ready():
	enemy_type = "basic"
	max_health = 10
	damage = 5
	speed = 80.0
	patrol_range = 200.0
	detection_range = 150.0
	health = max_health
	
	call_deferred("_setup")

func _setup() -> void:
	if has_node("AnimatedSprite") and not $AnimatedSprite.has_animation("patrol"):
		$AnimatedSprite.add_animation("patrol")
		$AnimatedSprite.add_animation("chase")
		$AnimatedSprite.animation = "patrol"
