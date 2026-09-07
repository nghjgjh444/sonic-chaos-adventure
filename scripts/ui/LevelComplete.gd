# LevelComplete.gd
# Level completion screen

extends Control

var zone = GameConstants.ZONE.GREEN_HILL
var rings_collected = 0
var time_elapsed = 0.0
var emeralds_found = 0
var enemies_defeated = 0
var score = 0

func _ready():
	calculate_score()
	display_results()

func calculate_score() -> void:
	score = (rings_collected * 100) + (emeralds_found * 1000) + (enemies_defeated * 50)

func display_results() -> void:
	var label = Label.new()
	label.text = "LEVEL COMPLETE!\n"
	label.text += "\nRINGS: %d" % rings_collected
	label.text += "\nTIME: %.2fs" % time_elapsed
	label.text += "\nEMERALDS: %d" % emeralds_found
	label.text += "\nENEMIES: %d" % enemies_defeated
	label.text += "\nSCORE: %d" % score
	add_child(label)

func _on_continue_pressed():
	get_tree().change_scene("res://scenes/menus/LevelSelect.tscn")
