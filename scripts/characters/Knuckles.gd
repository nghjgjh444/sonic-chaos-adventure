# Knuckles.gd
# Knuckles the Echidna implementation

extends CharacterBase

class_name Knuckles

# Knuckles-specific abilities
var is_gliding = false
var glide_speed = 200.0
var glide_fall_speed = 150.0

var is_climbing = false
var climb_speed = 150.0
var climbable_areas = []

var can_break_walls = true
var punch_damage = 12
var punch_cooldown = 0.0

func _ready():
	character_type = GameConstants.CHARACTER.KNUCKLES
	max_speed = 280.0
	acceleration = 1700.0
	deceleration = 1200.0
	jump_force = 520.0
	attack_damage = 12
	defense = 120
	max_health = 120
	health = 120
	
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
		if not sprite.has_animation("glide"):
			sprite.add_animation("glide")
		if not sprite.has_animation("climb"):
			sprite.add_animation("climb")
		if not sprite.has_animation("punch"):
			sprite.add_animation("punch")
		if not sprite.has_animation("fall"):
			sprite.add_animation("fall")
		if not sprite.has_animation("hurt"):
			sprite.add_animation("hurt")
		sprite.animation = "idle"

func _physics_process(delta):
	# Update cooldowns
	if punch_cooldown > 0:
		punch_cooldown -= delta
	
	# Handle Glide
	if Input.is_action_pressed("ability") and not is_grounded and velocity.y > 0:
		start_glide()
	elif is_gliding and not Input.is_action_pressed("ability"):
		stop_glide()
	
	if is_gliding:
		update_glide(delta)
	
	# Handle Punch/Break
	if Input.is_action_just_pressed("homing_attack") and punch_cooldown <= 0:
		_perform_punch()
	
	# Call parent physics
	._physics_process(delta)

func start_glide() -> void:
	if not is_grounded and velocity.y > 0:
		is_gliding = true
		change_state(STATE.ABILITY)

func stop_glide() -> void:
	is_gliding = false

func update_glide(delta) -> void:
	velocity.y = glide_fall_speed
	if Input.is_action_pressed("move_left"):
		velocity.x = -glide_speed
	elif Input.is_action_pressed("move_right"):
		velocity.x = glide_speed
	
	change_state(STATE.ABILITY)

func _perform_punch() -> void:
	change_state(STATE.BOOST)
	punch_cooldown = 1.0
	AudioManager.play_sfx("res://audio/sfx/punch.ogg")
	# Check for breakable objects
	var breakables = get_tree().get_nodes_in_group("breakable")
	for breakable in breakables:
		if global_position.distance_to(breakable.global_position) < punch_damage * 2:
			if breakable.has_method("break_object"):
				breakable.break_object()

func get_character_name() -> String:
	return "Knuckles"
