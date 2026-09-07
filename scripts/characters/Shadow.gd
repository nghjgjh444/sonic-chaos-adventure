# Shadow.gd
# Shadow the Ultimate Lifeform implementation

extends CharacterBase

class_name Shadow

# Shadow-specific abilities
var chaos_energy = 100.0
var max_chaos_energy = 100.0
var chaos_active = false
var chaos_control_duration = 2.0
var chaos_control_elapsed = 0.0
var chaos_drain_rate = 40.0

func _ready():
	character_type = GameConstants.CHARACTER.SHADOW
	max_speed = 360.0
	acceleration = 2100.0
	deceleration = 1600.0
	jump_force = 510.0
	attack_damage = 11
	defense = 110
	max_health = 110
	health = 110
	
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
		if not sprite.has_animation("chaos"):
			sprite.add_animation("chaos")
		if not sprite.has_animation("fall"):
			sprite.add_animation("fall")
		if not sprite.has_animation("hurt"):
			sprite.add_animation("hurt")
		sprite.animation = "idle"

func _physics_process(delta):
	# Handle Chaos Control
	if Input.is_action_pressed("ability") and chaos_energy > 0 and not chaos_active:
		start_chaos_control()
	
	if chaos_active:
		update_chaos_control(delta)
	
	# Call parent physics
	._physics_process(delta)

func start_chaos_control() -> void:
	chaos_active = true
	chaos_control_elapsed = 0.0
	change_state(STATE.ABILITY)
	AudioManager.play_sfx("res://audio/sfx/chaos_control.ogg")

func update_chaos_control(delta) -> void:
	chaos_control_elapsed += delta
	chaos_energy = max(0, chaos_energy - chaos_drain_rate * delta)
	
	# Time slow effect (server-side simulation continues normally for this character)
	if chaos_control_elapsed >= chaos_control_duration or chaos_energy <= 0:
		chaos_active = false

func get_character_name() -> String:
	return "Shadow"
