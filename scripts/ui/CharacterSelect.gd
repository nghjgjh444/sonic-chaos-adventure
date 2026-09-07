# CharacterSelect.gd
# Character selection screen

extends Control

var selected_character = GameConstants.CHARACTER.SONIC

func _ready():
	updates_buttons()

func updates_buttons() -> void:
	var sonic_btn = $VBoxContainer/HBoxContainer/SonicButton
	var tails_btn = $VBoxContainer/HBoxContainer/TailsButton
	var knuckles_btn = $VBoxContainer/HBoxContainer/KnucklesButton
	var shadow_btn = $VBoxContainer/HBoxContainer/ShadowButton
	var metal_btn = $VBoxContainer/HBoxContainer/MetalSonicButton
	var silver_btn = $VBoxContainer/HBoxContainer/SilverButton
	
	# Check unlocks
	var shadow_unlocked = SaveManager.is_character_unlocked(GameConstants.CHARACTER.SHADOW)
	var metal_unlocked = SaveManager.is_character_unlocked(GameConstants.CHARACTER.METAL_SONIC)
	var silver_unlocked = SaveManager.is_character_unlocked(GameConstants.CHARACTER.SILVER)
	
	shadow_btn.disabled = not shadow_unlocked
	metal_btn.disabled = not metal_unlocked
	silver_btn.disabled = not silver_unlocked
	
	if not shadow_unlocked:
		shadow_btn.text = "LOCKED"
	if not metal_unlocked:
		metal_btn.text = "LOCKED"
	if not silver_unlocked:
		silver_btn.text = "LOCKED"

func select_character(character: int) -> void:
	selected_character = character
	GameManager.current_players = [character]
	GameManager.start_singleplayer(character)

func _on_sonic_selected():
	select_character(GameConstants.CHARACTER.SONIC)

func _on_tails_selected():
	select_character(GameConstants.CHARACTER.TAILS)

func _on_knuckles_selected():
	select_character(GameConstants.CHARACTER.KNUCKLES)

func _on_shadow_selected():
	if SaveManager.is_character_unlocked(GameConstants.CHARACTER.SHADOW):
		select_character(GameConstants.CHARACTER.SHADOW)

func _on_metal_sonic_selected():
	if SaveManager.is_character_unlocked(GameConstants.CHARACTER.METAL_SONIC):
		select_character(GameConstants.CHARACTER.METAL_SONIC)

func _on_silver_selected():
	if SaveManager.is_character_unlocked(GameConstants.CHARACTER.SILVER):
		select_character(GameConstants.CHARACTER.SILVER)

func _on_back_pressed():
	get_tree().change_scene("res://scenes/menus/MainMenu.tscn")
