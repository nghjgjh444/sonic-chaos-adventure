# Tails.gd
# Tails the Fox implementation

extends CharacterBase

class_name Tails

# Tails-specific abilities
var is_flying = false
var fly_energy = 100.0
var max_fly_energy = 100.0
var fly_drain_rate = 30.0
var fly_speed = 250.0
var fly_recovery_rate = 20.0

var tail_attack_cooldown = 0.0
var tail_attack_range = 60.0
var tail_attack_damage = 8

func _ready():
	character_type = GameConstants.CHARACTER.TAILS
	max_speed = 300.0
	acceleration = 1800.0
	deceleration = 1300.0
	jump_force = 480.0
	attack_damage = 8
	defense = 90
	max_health = 90
	health = 90
	
	call_deferred("_setup_character")

func _setup_character() -> void:
	sprite = $AnimatedSprite
	collision_shape = $CollisionShape2D
	camera = $Camera2D if has_node("Camera2D") else null
	
	if sprite and not sprite.has_animation("idle"):
		create_placeholder_animations()

func create_placeholder_animations() -> void:
	if sprite:
		if not sprite.has_animation("idle"):
			sprite.add_animation("idle")
		if not sprite.has_animation("walk"):
			sprite.add_animation("walk")
		if not sprite.has_animation("run"):
			sprite.add_animation("run")
		if not sprite.has_animation("jump"):
			sprite.add_animation("jump")
		if not sprite.has_animation("fly"):
			sprite.add_animation("fly")
		if not sprite.has_animation("fall"):
			sprite.add_animation("fall")
		if not sprite.has_animation("hurt"):
			sprite.add_animation("hurt")
		sprite.animation = "idle"

func _physics_process(delta):
	# Update cooldowns
	if tail_attack_cooldown > 0:
		tail_attack_cooldown -= delta
	
	# Handle Flight
	if Input.is_action_pressed("ability") and not is_grounded:
		start_flight()
	elif is_flying and Input.is_action_just_released("ability"):
		stop_flight()
	
	if is_flying:
		update_flight(delta)
	else:
		# Recovery when not flying
		fly_energy = min(fly_energy + fly_recovery_rate * delta, max_fly_energy)
	
	# Call parent physics
	._physics_process(delta)

func start_flight() -> void:
	if fly_energy > 0 and not is_grounded:
		is_flying = true
		change_state(STATE.ABILITY)

func stop_flight() -> void:
	is_flying = false

func update_flight(delta) -> void:
	if fly_energy <= 0:
		is_flying = false
		return
	
	fly_energy = max(0, fly_energy - fly_drain_rate * delta)
	
	# Flight movement
	var fly_direction = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		fly_direction.x -= 1.0
	if Input.is_action_pressed("move_right"):
		fly_direction.x += 1.0
	if Input.is_action_pressed("move_up"):
		fly_direction.y -= 1.0
	if Input.is_action_pressed("move_down"):
		fly_direction.y += 1.0
	
	if fly_direction != Vector2.ZERO:
		fly_direction = fly_direction.normalized()
	
	velocity = fly_direction * fly_speed
	
	change_state(STATE.ABILITY)

func get_character_name() -> String:
	return "Tails"
