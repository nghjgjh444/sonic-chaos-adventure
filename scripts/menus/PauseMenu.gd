# PauseMenu.gd
# Pause menu handler

extends Control

func _on_resume_pressed():
	GameManager.resume_game()
	get_tree().paused = false
	get_tree().change_scene(get_tree().current_scene.filename)

func _on_restart_pressed():
	get_tree().paused = false
	GameManager.resume_game()
	get_tree().reload_current_scene()

func _on_settings_pressed():
	pass # TODO: Implement settings

func _on_menu_pressed():
	get_tree().paused = false
	GameManager.return_to_menu()
