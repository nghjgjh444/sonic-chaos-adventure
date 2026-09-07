# Level.gd
# Base level/zone manager

extends Node2D

export var level_name = "Level"
export var level_zone = GameConstants.ZONE.GREEN_HILL

var current_rings = 0
var current_lives = 3
var current_emeralds = 0
var player = null
var hud = null

func _ready():
	GameManager.change_state(GameConstants.GAME_STATE.PLAYING)
	GameManager.current_level = level_zone
	
	player = $Player if has_node("Player") else null
	hud = $HUD if has_node("HUD") else null
	
	if player:
		player.connect("rings_changed", self, "_on_player_rings_changed")
		player.connect("health_changed", self, "_on_player_health_changed")
		player.connect("died", self, "_on_player_died")
	
	current_lives = SaveManager.get_lives()
	current_emeralds = SaveManager.get_emeralds_collected()
	
	update_hud()

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		GameManager.pause_game()
		get_tree().change_scene("res://scenes/menus/PauseMenu.tscn")

func _on_player_rings_changed(new_rings: int) -> void:
	current_rings = new_rings
	update_hud()

func _on_player_health_changed(new_health: int) -> void:
	update_hud()

func _on_player_died() -> void:
	current_lives -= 1
	SaveManager.set_lives(current_lives)
	
	if current_lives <= 0:
		GameManager.return_to_menu()
	else:
		# Respawn at last checkpoint
		yield(get_tree(), "idle_frame")
		if player:
			player.global_position = Vector2(100, 200) # TODO: Load from checkpoint
			player.respawn()
		update_hud()

func update_hud() -> void:
	if not hud:
		return
	
	var rings_label = hud.get_node("Control/RingsLabel")
	var lives_label = hud.get_node("Control/LivesLabel")
	var health_bar = hud.get_node("Control/HealthBar")
	var boost_bar = hud.get_node("Control/BoostBar")
	var emeralds_label = hud.get_node("Control/EmeraldsLabel")
	
	if rings_label:
		rings_label.text = "RINGS: %03d" % current_rings
	
	if lives_label:
		lives_label.text = "LIVES: %02d" % current_lives
	
	if health_bar and player:
		health_bar.max_value = player.max_health
		health_bar.value = player.health
	
	if boost_bar and player:
		boost_bar.max_value = player.max_boost_energy
		boost_bar.value = player.boost_energy
	
	if emeralds_label:
		emerаlds_label.text = "CHAOS EMERALDS: %d/7" % current_emeralds
