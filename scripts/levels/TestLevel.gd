# TestLevel.gd
# Enhanced test/demo level with all game objects

extends Level

func _ready():
	level_name = "Test Level"
	level_zone = GameConstants.ZONE.GREEN_HILL
	
	._ready()
	
	# Tutorial
	show_tutorial()

func show_tutorial() -> void:
	var tutorial_label = Label.new()
	tutorial_label.text = "WELCOME TO SONIC: CHAOS ADVENTURE!\n\nUse WASD to move, SPACE to jump\nCollect rings and complete the zone!"
	tutorial_label.align = Label.ALIGN_CENTER
	tutorial_label.add_color_override("font_color", Color.white)
	
	var hud = $HUD if has_node("HUD") else null
	if hud:
		hud.add_child(tutorial_label)
		
		yield(get_tree().create_timer(5.0), "timeout")
		tutorial_label.queue_free()
