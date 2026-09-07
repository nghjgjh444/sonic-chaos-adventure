# MetalSonicBoss.gd
# Metal Sonic boss (optional secret boss)

extends Boss

class_name MetalSonicBoss

var dash_speed = 400.0
var clone_count = 0
var can_create_clones = true

func _ready():
	boss_name = "Metal Sonic"
	max_health = 150
	damage = 12
	health = max_health
	
	call_deferred("_setup")

func _setup() -> void:
	if has_node("AnimatedSprite"):
		$AnimatedSprite.add_animation("idle")
		$AnimatedSprite.add_animation("dash")
		$AnimatedSprite.animation = "idle"

func execute_attack(delta) -> void:
	if attack_cooldown > 0:
		return
	
	match current_phase:
		1:
			if randf() > 0.5:
				fast_dash()
		2:
			if can_create_clones:
				create_clone()
			else:
				fast_dash()
		3:
			create_clone()
			fast_dash()

func fast_dash() -> void:
	var players = get_tree().get_nodes_in_group("players")
	if players.empty():
		return
	
	var player = players[0]
	var direction = sign(player.global_position.x - global_position.x)
	velocity.x = direction * dash_speed
	
	if has_node("AnimatedSprite"):
		$AnimatedSprite.animation = "dash"
	
	yield(get_tree().create_timer(1.0), "timeout")
	velocity.x = 0
	if has_node("AnimatedSprite"):
		$AnimatedSprite.animation = "idle"
	
	attack_cooldown = 1.2

func create_clone() -> void:
	if clone_count >= 2 or not can_create_clones:
		return
	
	var clone = duplicate()
	clone.boss_name = "Metal Sonic Clone"
	clone.max_health = 50
	clone.health = 50
	get_parent().add_child(clone)
	clone.global_position = global_position + Vector2(randf_range(-100, 100), 0)
	
	clone_count += 1
	attack_cooldown = 2.0

func die() -> void:
	._die()
