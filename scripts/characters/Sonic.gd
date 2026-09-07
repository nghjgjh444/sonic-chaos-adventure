# Sonic.gd
# Sonic the Hedgehog implementation

extends CharacterBase

class_name Sonic

# Sonic-specific abilities
var spindash_charged = false
var spindash_charge = 0.0
var spindash_max_charge = 100.0
var spindash_charge_speed = 200.0
var spindash_min_speed = 150.0
var spindash_max_speed = 400.0

var boost_active = false
var boost_drain_rate = 20.0
var boost_speed_multiplier = 1.5

var homing_attack_active = false
var homing_attack_cooldown = 0.0
var homing_attack_range = 200.0
var homing_attack_speed = 600.0
var homing_target = null

func _ready():
	character_type = GameConstants.CHARACTER.SONIC
	max_speed = 350.0
	acceleration = 2000.0
	deceleration = 1500.0
	jump_force = 500.0
	attack_damage = 10
	defense = 100
	max_health = 100
	health = 100
	
	call_deferred("_setup_character")

func _setup_character() -> void:
	sprite = $AnimatedSprite
	collision_shape = $CollisionShape2D
	camera = $Camera2D if has_node("Camera2D") else null
	
	if not sprite.has_animation("idle"):
		create_placeholder_animations()

func create_placeholder_animations() -> void:
	# Create placeholder animations (temporary)
	var anim_player = AnimationPlayer.new()
	add_child(anim_player)
	
	# For now, use simple frame-based animation with AnimatedSprite
	if sprite:
		if not sprite.has_animation("idle"):
			sprite.add_animation("idle")
		if not sprite.has_animation("walk"):
			sprite.add_animation("walk")
		if not sprite.has_animation("run"):
			sprite.add_animation("run")
		if not sprite.has_animation("jump"):
			sprite.add_animation("jump")
		if not sprite.has_animation("fall"):
			sprite.add_animation("fall")
		if not sprite.has_animation("hurt"):
			sprite.add_animation("hurt")
		if not sprite.has_animation("boost"):
			sprite.add_animation("boost")
		if not sprite.has_animation("spindash"):
			sprite.add_animation("spindash")
		sprite.animation = "idle"

func _physics_process(delta):
	# Update cooldowns
	if homing_attack_cooldown > 0:
		homing_attack_cooldown -= delta
	
	# Handle Spindash
	if Input.is_action_pressed("spindash"):
		if not spindash_charged:
			spindash_charged = true
			spindash_charge = 0.0
			change_state(STATE.SPINDASH)
		else:
			spindash_charge = min(spindash_charge + spindash_charge_speed * delta, spindash_max_charge)
	else:
		if spindash_charged:
			_release_spindash()
			spindash_charged = false
	
	# Handle Homing Attack
	if Input.is_action_just_pressed("homing_attack") and not homing_attack_active:
		_perform_homing_attack()
	
	# Handle Boost
	if Input.is_action_pressed("boost") and boost_energy > 0:
		_boost(delta)
	else:
		boost_active = false
	
	# Call parent physics
	._physics_process(delta)

func _release_spindash() -> void:
	if spindash_charge > 0:
		var launch_speed = lerp(spindash_min_speed, spindash_max_speed, spindash_charge / spindash_max_charge)
		velocity.x = launch_speed * sign(velocity.x if velocity.x != 0 else 1)
		AudioManager.play_sfx("res://audio/sfx/spindash.ogg")
		change_state(STATE.SPINDASH)

func _perform_homing_attack() -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest = null
	var closest_distance = homing_attack_range
	
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest = enemy
			closest_distance = distance
	
	if closest:
		homing_target = closest
		homing_attack_active = true
		homing_attack_cooldown = 0.5
		change_state(STATE.HOMING_ATTACK)
		AudioManager.play_sfx("res://audio/sfx/homing_attack.ogg")

func _boost(delta) -> void:
	if not boost_active:
		boost_active = true
		change_state(STATE.BOOST)
	
	boost_energy = max(0, boost_energy - boost_drain_rate * delta)
	
	var boost_direction = 1.0 if input_direction != 0 else (1.0 if velocity.x > 0 else -1.0)
	velocity.x = boost_direction * max_speed * boost_speed_multiplier

func get_character_name() -> String:
	return "Sonic"
