# ProjectileBadnik.gd
# Enemy that shoots projectiles

extends Enemy

class_name ProjectileBadnik

var shoot_cooldown = 0.0
var shoot_interval = 2.0
var projectile_scene = preload("res://scenes/objects/Projectile.tscn")
var projectile_speed = 200.0

func _ready():
	enemy_type = "projectile"
	max_health = 18
	damage = 6
	speed = 40.0
	detection_range = 300.0
	health = max_health
	
	call_deferred("_setup")

func _setup() -> void:
	if has_node("AnimatedSprite"):
		$AnimatedSprite.add_animation("stand")
		$AnimatedSprite.add_animation("shoot")
		$AnimatedSprite.animation = "stand"

func _physics_process(delta):
	if shoot_cooldown > 0:
		shoot_cooldown -= delta
	else:
		if target and is_instance_valid(target):
			shoot_projectile()
			shoot_cooldown = shoot_interval
	
	._physics_process(delta)

func shoot_projectile() -> void:
	if not projectile_scene:
		return
	
	var proj = projectile_scene.instance()
	get_parent().add_child(proj)
	proj.global_position = global_position
	proj.damage = damage
	
	var direction = sign(target.global_position.x - global_position.x)
	proj.velocity.x = direction * projectile_speed
	
	if has_node("AnimatedSprite"):
		$AnimatedSprite.animation = "shoot"
		yield(get_tree().create_timer(0.5), "timeout")
		$AnimatedSprite.animation = "stand"
	
	AudioManager.play_sfx("res://audio/sfx/shoot.ogg")
