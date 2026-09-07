# Boss.gd
# Base class for boss battles

extends KinematicBody2D

class_name Boss

export var boss_name = "Boss"
export var max_health = 100
export var damage = 15
export var phase_two_health = 50
export var phase_three_health = 20

var health = 100
var velocity = Vector2.ZERO
var gravity = GameConstants.GRAVITY
var current_phase = 1
var attack_cooldown = 0.0
var sprite: AnimatedSprite
var health_bar: ProgressBar

signal phase_changed(new_phase)
signal defeated

func _ready():
	add_to_group("bosses")
	health = max_health
	sprite = $AnimatedSprite if has_node("AnimatedSprite") else null
	health_bar = $HealthBar if has_node("HealthBar") else null

func _physics_process(delta):
	if attack_cooldown > 0:
		attack_cooldown -= delta
	
	# Apply gravity
	if not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, GameConstants.MAX_FALL_SPEED)
	
	# Update phase
	update_phase()
	
	# Boss AI
	execute_attack(delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	update_health_bar()

func update_phase() -> void:
	var new_phase = 1
	
	if health <= phase_three_health:
		new_phase = 3
	elif health <= phase_two_health:
		new_phase = 2
	
	if new_phase != current_phase:
		current_phase = new_phase
		emit_signal("phase_changed", current_phase)
		entered_new_phase()

func entered_new_phase() -> void:
	match current_phase:
		1:
			pass
		2:
			attack_cooldown = 1.0
		3:
			attack_cooldown = 0.5

func execute_attack(delta) -> void:
	pass # Override in subclass

func take_damage(amount: int) -> void:
	health = max(0, health - amount)
	
	if health <= 0:
		die()

func die() -> void:
	AudioManager.play_sfx("res://audio/sfx/boss_defeat.ogg")
	emit_signal("defeated")
	set_physics_process(false)
	
	yield(get_tree().create_timer(2.0), "timeout")
	queue_free()

func update_health_bar() -> void:
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = health
