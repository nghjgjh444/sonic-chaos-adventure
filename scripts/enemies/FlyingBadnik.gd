# FlyingBadnik.gd
# Flying enemy type

extends Enemy

class_name FlyingBadnik

var patrol_height = 0.0
var flight_speed = 120.0
var bob_speed = 2.0
var bob_height = 30.0
var time = 0.0

func _ready():
	enemy_type = "flying"
	max_health = 15
	damage = 8
	speed = flight_speed
	detection_range = 200.0
	health = max_health
	patrol_height = global_position.y
	
	call_deferred("_setup")

func _setup() -> void:
	if has_node("AnimatedSprite"):
		$AnimatedSprite.add_animation("fly")
		$AnimatedSprite.animation = "fly"

func _physics_process(delta):
	time += delta
	
	# Bob up and down while moving
	var bob_offset = sin(time * bob_speed) * bob_height
	global_position.y = patrol_height + bob_offset
	
	# Call parent physics (handles movement)
	._physics_process(delta)

func patrol(delta) -> void:
	velocity.x = speed * 0.6

func chase_target(delta) -> void:
	if target and is_instance_valid(target):
		var direction = sign(target.global_position.x - global_position.x)
		velocity.x = direction * speed
