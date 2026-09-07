# Enemy.gd
# Base class for all enemies

extends KinematicBody2D

class_name Enemy

export var enemy_type = "basic"
export var max_health = 10
export var damage = 5
export var speed = 100.0
export var patrol_range = 200.0
export var detection_range = 150.0

var health = 10
var velocity = Vector2.ZERO
var gravity = GameConstants.GRAVITY
var is_patrolling = true
var is_chasing = false
var target = null
var sprite: AnimatedSprite
var collision_shape: CollisionShape2D

func _ready():
	add_to_group("enemies")
	health = max_health
	sprite = $AnimatedSprite if has_node("AnimatedSprite") else null
	collision_shape = $CollisionShape2D if has_node("CollisionShape2D") else null

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, GameConstants.MAX_FALL_SPEED)
	else:
		velocity.y = 0
	
	# AI behavior
	updates_target()
	
	if is_chasing and target:
		chase_target(delta)
	else:
		patrol(delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func updates_target() -> void:
	var players = get_tree().get_nodes_in_group("players")
	if players.empty():
		is_chasing = false
		target = null
		return
	
	var closest = null
	var closest_distance = detection_range
	
	for player in players:
		var distance = global_position.distance_to(player.global_position)
		if distance < closest_distance:
			closest = player
			closest_distance = distance
	
	if closest:
		is_chasing = true
		target = closest
	else:
		is_chasing = false
		target = null

func patrol(delta) -> void:
	velocity.x = speed * 0.5

func chase_target(delta) -> void:
	if target and is_instance_valid(target):
		var direction = sign(target.global_position.x - global_position.x)
		velocity.x = direction * speed

func take_damage(amount: int) -> void:
	health = max(0, health - amount)
	
	if health <= 0:
		die()

func die() -> void:
	# Release animal
	release_animal()
	
	# Create death effect
	AudioManager.play_sfx("res://audio/sfx/enemy_death.ogg")
	
	queue_free()

func release_animal() -> void:
	# TODO: Spawn animal that runs away
	pass
