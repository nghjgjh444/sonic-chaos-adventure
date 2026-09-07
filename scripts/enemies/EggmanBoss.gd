# EggmanBoss.gd
# Eggman (Dr. Robotnik) boss battle

extends Boss

class_name EggmanBoss

var projectile_scene = preload("res://scenes/objects/Projectile.tscn")
var dash_speed = 300.0
var dash_distance = 200.0
var target_player = null

func _ready():
	boss_name = "Dr. Eggman"
	max_health = 120
	damage = 10
	health = max_health
	
	call_deferred("_setup")

func _setup() -> void:
	if has_node("AnimatedSprite"):
		$AnimatedSprite.add_animation("idle")
		$AnimatedSprite.add_animation("attack")
		$AnimatedSprite.animation = "idle"
	
	target_player = get_tree().get_first_node_in_group("players")

func execute_attack(delta) -> void:
	if attack_cooldown > 0 or not target_player or not is_instance_valid(target_player):
		return
	
	match current_phase:
		1:
			if randf() > 0.6:
				shoot_attack()
			else:
				dash_attack()
		2:
			if randf() > 0.4:
				shoot_attack()
			else:
				dash_attack()
		3:
			shoot_attack()
			dash_attack()

func shoot_attack() -> void:
	for i in range(3):
		var proj = projectile_scene.instance()
		get_parent().add_child(proj)
		proj.global_position = global_position + Vector2(0, -20)
		proj.damage = damage
		
		var angle = (i - 1) * 0.3
		var direction = Vector2(cos(angle), sin(angle))
		proj.velocity = direction * 200.0
	
	attack_cooldown = 2.0

func dash_attack() -> void:
	if target_player:
		var direction = sign(target_player.global_position.x - global_position.x)
		velocity.x = direction * dash_speed
		
		if has_node("AnimatedSprite"):
			$AnimatedSprite.animation = "attack"
		
		yield(get_tree().create_timer(0.8), "timeout")
		velocity.x = 0
		if has_node("AnimatedSprite"):
			$AnimatedSprite.animation = "idle"
		
		attack_cooldown = 1.5
