# RollingBadnik.gd
# Rolling/charging enemy

extends Enemy

class_name RollingBadnik

var charge_cooldown = 0.0
var charge_speed = 250.0
var charge_distance = 150.0
var is_charging = false
var charge_direction = 1.0

func _ready():
	enemy_type = "rolling"
	max_health = 12
	damage = 10
	speed = 60.0
	detection_range = 250.0
	health = max_health
	
	call_deferred("_setup")

func _setup() -> void:
	if has_node("AnimatedSprite"):
		$AnimatedSprite.add_animation("roll")
		$AnimatedSprite.add_animation("charge")
		$AnimatedSprite.animation = "roll"

func _physics_process(delta):
	if charge_cooldown > 0:
		charge_cooldown -= delta
	
	._physics_process(delta)

func chase_target(delta) -> void:
	if not target or not is_instance_valid(target):
		return
	
	if not is_charging and charge_cooldown <= 0:
		start_charge()
	
	if is_charging:
		velocity.x = charge_direction * charge_speed

func start_charge() -> void:
	if target and is_instance_valid(target):
		charge_direction = sign(target.global_position.x - global_position.x)
		is_charging = true
		if has_node("AnimatedSprite"):
			$AnimatedSprite.animation = "charge"
		
		yield(get_tree().create_timer(1.5), "timeout")
		is_charging = false
		charge_cooldown = 3.0
		if has_node("AnimatedSprite"):
			$AnimatedSprite.animation = "roll"
