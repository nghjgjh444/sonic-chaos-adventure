# LevelTutorial.gd
# Tutorial overlay for level introduction

extends Control

var tutorial_steps = []
var current_step = 0
var is_active = false

func _ready():
	visible = false

func show_tutorial(steps: Array) -> void:
	tutorial_steps = steps
	current_step = 0
	is_active = true
	visible = true
	show_step()

func show_step() -> void:
	if current_step >= tutorial_steps.size():
		hide_tutorial()
		return
	
	var step = tutorial_steps[current_step]
	var label = Label.new()
	label.text = step["text"]
	add_child(label)

func next_step() -> void:
	current_step += 1
	clear_children()
	show_step()

func hide_tutorial() -> void:
	is_active = false
	visible = false
	clear_children()

func clear_children() -> void:
	for child in get_children():
		if child is Label:
			child.queue_free()
