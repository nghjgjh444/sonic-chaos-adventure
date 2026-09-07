# Projectile.gd
# Enemy projectile

extends KinematicBody2D

export var damage = 5
export var lifetime = 5.0

var velocity = Vector2.ZERO
var gravity = GameConstants.GRAVITY
var time_alive = 0.0

func _ready():
	add_to_group("projectiles")
	
func _physics_process(delta):
	time_alive += delta
	
	if time_alive >= lifetime:
		queue_free()
	
	# Apply gravity
	velocity.y = min(velocity.y + gravity * delta, GameConstants.MAX_FALL_SPEED)
	
	# Move
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		if collision.collider.is_in_group("players"):
			if collision.collider.has_method("take_damage"):
				collision.collider.take_damage(damage)
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("players"):
		if area.get_parent().has_method("take_damage"):
			area.get_parent().take_damage(damage)
		queue_free()
