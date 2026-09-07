# MultiplayerHUD.gd
# HUD for multiplayer games

extends CanvasLayer

var player_stats = []

func _ready():
	display_player_stats()

func display_player_stats() -> void:
	for i in range(MultiplayerManager.player_count):
		var stat_label = Label.new()
		stat_label.text = "P%d" % (i + 1)
		$Control.add_child(stat_label)

func update_player_stat(player_index: int, stat_name: String, value) -> void:
	if player_index < player_stats.size():
		player_stats[player_index][stat_name] = value
