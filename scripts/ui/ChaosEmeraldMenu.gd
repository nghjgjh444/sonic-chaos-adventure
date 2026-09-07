# ChaosEmeraldMenu.gd
# Chaos Emeralds collection screen

extends Control

func _ready():
	display_emeralds()

func display_emeralds() -> void:
	var emeralds_collected = SaveManager.get_emeralds_collected()
	var grid = $GridContainer
	
	for i in range(GameConstants.TOTAL_EMERALDS):
		var label = Label.new()
		if i < emeralds_collected:
			label.text = "[E %d]" % (i + 1)
		else:
			label.text = "[ ? ]"
		grid.add_child(label)

func _on_back_pressed():
	get_tree().change_scene("res://scenes/menus/MainMenu.tscn")
