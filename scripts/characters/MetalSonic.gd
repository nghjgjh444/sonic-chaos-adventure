# MetalSonic.gd
# Metal Sonic implementation

extends CharacterBase

class_name MetalSonic

# Metal Sonic-specific abilities
var overdrive_active = false
var overdrive_energy = 100.0
var max_overdrive_energy = 100.0
var overdrive_drain_rate = 35.0
var overdrive_speed_multiplier = 1.8
var overdrive_damage_bonus = 1.5

func _ready():
	character_type = GameConstants.CHARACTER.METAL_SONIC
	max_speed = 380.0
	acceleration = 2200.0
	deceleration = 1700.0
	jump_force = 490.0
	attack_damage = 13
	defense = 130
	max_health = 130
	health = 130
	
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
		if not sprite.has_animation("overdrive"):
			sprite.add_animation("overdrive")
		if not sprite.has_animation("fall"):
			sprite.add_animation("fall")
		if not sprite.has_animation("hurt"):
			sprite.add_animation("hurt")
		sprite.animation = "idle"

func _physics_process(delta):
	# Handle Overdrive
	if Input.is_action_pressed("ability") and overdrive_energy > 0:
		if not overdrive_active:
			start_overdrive()
		update_overdrive(delta)
	else:
		if overdrive_active:
			stop_overdrive()
	
	# Call parent physics
	._physics_process(delta)

func start_overdrive() -> void:
	if overdrive_energy > 0:
		overdrive_active = true
		change_state(STATE.BOOST)
		AudioManager.play_sfx("res://audio/sfx/overdrive.ogg")

func update_overdrive(delta) -> void:
	if not overdrive_active or overdrive_energy <= 0:
		return
	
	overdrive_energy = max(0, overdrive_energy - overdrive_drain_rate * delta)
	max_speed = 380.0 * overdrive_speed_multiplier


func stop_overdrive() -> void:
	if overdrive_active:
		overdrive_active = false
		max_speed = 380.0

func get_character_name() -> String:
	return "Metal Sonic"
