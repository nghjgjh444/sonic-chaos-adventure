# CharacterBase.gd (UPDATED)
# Base class for all playable characters

extends KinematicBody2D

class_name CharacterBase

# Character properties
export var character_type = GameConstants.CHARACTER.SONIC
export var max_speed = 350.0
export var acceleration = 2000.0
export var deceleration = 1500.0
export var jump_force = 500.0
export var attack_damage = 10
export var defense = 100
export var gravity = GameConstants.GRAVITY
export var max_fall_speed = GameConstants.MAX_FALL_SPEED

# Movement variables
var velocity = Vector2.ZERO
var is_grounded = false
var is_jumping = false
var can_jump = true
var input_direction = 0.0

# Health and state
var health = 100
var max_health = 100
var rings = 0
var boost_energy = 100.0
var max_boost_energy = 100.0
var shield_type = null
var is_invincible = false
var invincible_timer = 0.0
var player_index = 0

# State
enum STATE {
	IDLE,
	WALK,
	RUN,
	JUMP,
	FALL,
	HURT,
	DEAD,
	BOOST,
	SPINDASH,
	HOMING_ATTACK,
	ABILITY
}

var current_state = STATE.IDLE
var sprite: AnimatedSprite
var collision_shape: CollisionShape2D
var camera: Camera2D

# Signals
signal health_changed(new_health)
signal rings_changed(new_rings)
signal shield_changed(new_shield)
signal state_changed(new_state)
signal died

func _ready():
	add_to_group("players")
	sprite = $AnimatedSprite
	collision_shape = $CollisionShape2D
	camera = $Camera2D if has_node("Camera2D") else null
	
	if camera:
		camera.set_as_toplevel(true)

func _process(delta):
	if is_invincible:
		invincible_timer -= delta
		if invincible_timer <= 0:
			is_invincible = false

func _physics_process(delta):
	# Gravity
	if not is_grounded:
		velocity.y = min(velocity.y + gravity * delta, max_fall_speed)
	
	# Ground detection
	is_grounded = is_on_floor()
	
	# Movement input
	input_direction = 0.0
	if Input.is_action_pressed("move_left"):
		input_direction -= 1.0
	if Input.is_action_pressed("move_right"):
		input_direction += 1.0
	
	# Apply acceleration/deceleration
	if input_direction != 0:
		velocity.x = move_toward(velocity.x, input_direction * max_speed, acceleration * delta)
		if current_state == STATE.IDLE or current_state == STATE.WALK:
			change_state(STATE.RUN if abs(velocity.x) > max_speed * 0.5 else STATE.WALK)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		if is_grounded and current_state in [STATE.WALK, STATE.RUN]:
			change_state(STATE.IDLE)
	
	# Jump
	if Input.is_action_just_pressed("jump") and is_grounded and can_jump:
		jump()
	
	# Apply velocity
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Update animation
	update_animation()
	
	# Update camera
	if camera:
		camera.global_position = global_position

func jump() -> void:
	if not can_jump or not is_grounded:
		return
	
	velocity.y = -jump_force
	is_jumping = true
	is_grounded = false
	change_state(STATE.JUMP)
	AudioManager.play_sfx("res://audio/sfx/jump.ogg")

func take_damage(amount: int) -> void:
	if is_invincible:
		return
	
	if shield_type != null:
		shield_type = null
		emit_signal("shield_changed", null)
		AudioManager.play_sfx("res://audio/sfx/shield_break.ogg")
		return
	
	health = max(0, health - amount)
	emit_signal("health_changed", health)
	AudioManager.play_sfx("res://audio/sfx/hurt.ogg")
	
	if health <= 0:
		die()
	else:
		change_state(STATE.HURT)
		is_invincible = true
		invincible_timer = 2.0

func add_rings(amount: int) -> void:
	rings = min(rings + amount, 999)
	emit_signal("rings_changed", rings)
	boost_energy = min(boost_energy + amount * 0.5, max_boost_energy)

func set_shield(shield: String) -> void:
	shield_type = shield
	emit_signal("shield_changed", shield)

func die() -> void:
	change_state(STATE.DEAD)
	emit_signal("died")
	AudioManager.play_sfx("res://audio/sfx/death.ogg")
	set_physics_process(false)

func respawn() -> void:
	health = max_health
	velocity = Vector2.ZERO
	change_state(STATE.IDLE)
	set_physics_process(true)
	emit_signal("health_changed", health)

func change_state(new_state: int) -> void:
	if current_state != new_state:
		current_state = new_state
		emit_signal("state_changed", new_state)

func update_animation() -> void:
	if not sprite:
		return
	
	match current_state:
		STATE.IDLE:
			sprite.animation = "idle"
		STATE.WALK:
			sprite.animation = "walk"
		STATE.RUN:
			sprite.animation = "run"
		STATE.JUMP:
			sprite.animation = "jump"
		STATE.FALL:
			if velocity.y > 0:
				sprite.animation = "fall"
		STATE.HURT:
			sprite.animation = "hurt"
		STATE.BOOST:
			sprite.animation = "boost"

func get_state_name() -> String:
	match current_state:
		STATE.IDLE:
			return "Idle"
		STATE.WALK:
			return "Walk"
		STATE.RUN:
			return "Run"
		STATE.JUMP:
			return "Jump"
		STATE.FALL:
			return "Fall"
		STATE.HURT:
			return "Hurt"
		STATE.DEAD:
			return "Dead"
		STATE.BOOST:
			return "Boost"
		STATE.SPINDASH:
			return "Spindash"
		STATE.HOMING_ATTACK:
			return "Homing Attack"
		STATE.ABILITY:
			return "Ability"
		_:
			return "Unknown"
