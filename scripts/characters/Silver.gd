# Silver.gd
# Silver the Hedgehog implementation

extends CharacterBase

class_name Silver

# Silver-specific abilities
var psychokinesis_active = false
var psychokinesis_energy = 100.0
var max_psychokinesis_energy = 100.0
var psychokinesis_drain_rate = 30.0
var psychokinesis_range = 150.0
var telekinesis_target = null

func _ready():
	character_type = GameConstants.CHARACTER.SILVER
	max_speed = 320.0
	acceleration = 1900.0
	deceleration = 1400.0
	jump_force = 500.0
	attack_damage = 9
	defense = 100
	max_health = 100
	health = 100
	
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
		if not sprite.has_animation("psycho"):
			sprite.add_animation("psycho")
		if not sprite.has_animation("fall"):
			sprite.add_animation("fall")
		if not sprite.has_animation("hurt"):
			sprite.add_animation("hurt")
		sprite.animation = "idle"

func _physics_process(delta):
	# Handle Psychokinesis
	if Input.is_action_pressed("ability") and psychokinesis_energy > 0:
		if not psychokinesis_active:
			start_psychokinesis()
		update_psychokinesis(delta)
	else:
		if psychokinesis_active:
			stop_psychokinesis()
	
	# Call parent physics
	._physics_process(delta)

func start_psychokinesis() -> void:
	if psychokinesis_energy > 0:
		psychokinesis_active = true
		change_state(STATE.ABILITY)
		AudioManager.play_sfx("res://audio/sfx/psychokinesis.ogg")
		
		# Find target object
		var lift_objects = get_tree().get_nodes_in_group("liftable")
		var closest = null
		var closest_distance = psychokinesis_range
		
		for obj in lift_objects:
			var distance = global_position.distance_to(obj.global_position)
			if distance < closest_distance:
				closest = obj
				closest_distance = distance
		
		if closest:
			telekinesis_target = closest

func update_psychokinesis(delta) -> void:
	if not psychokinesis_active or psychokinesis_energy <= 0:
		return
	
	psychokinesis_energy = max(0, psychokinesis_energy - psychokinesis_drain_rate * delta)
	
	if telekinesis_target and is_instance_valid(telekinesis_target):
		# Move target towards Silver or in input direction
		var direction = Vector2.ZERO
		if Input.is_action_pressed("move_left"):
			direction.x -= 1.0
		if Input.is_action_pressed("move_right"):
			direction.x += 1.0
		if Input.is_action_pressed("move_up"):
			direction.y -= 1.0
		if Input.is_action_pressed("move_down"):
			direction.y += 1.0
		
		if direction != Vector2.ZERO:
			direction = direction.normalized()
			if telekinesis_target.has_method("set_velocity"):
				telekinesis_target.set_velocity(direction * 200.0)

func stop_psychokinesis() -> void:
	if psychokinesis_active:
		psychokinesis_active = false
		if telekinesis_target and is_instance_valid(telekinesis_target):
			if telekinesis_target.has_method("set_velocity"):
				telekinesis_target.set_velocity(Vector2.ZERO)
		telekinesis_target = null

func get_character_name() -> String:
	return "Silver"
