# UIManager.gd
# Manages UI state and transitions

extends Node

signal ui_changed(new_ui)

func _ready():
	set_name("UIManager")

func show_main_menu() -> void:
	emit_signal("ui_changed", "main_menu")

func show_level_select() -> void:
	emit_signal("ui_changed", "level_select")

func show_character_select() -> void:
	emit_signal("ui_changed", "character_select")

func show_hud() -> void:
	emit_signal("ui_changed", "hud")

func show_pause_menu() -> void:
	emit_signal("ui_changed", "pause_menu")
