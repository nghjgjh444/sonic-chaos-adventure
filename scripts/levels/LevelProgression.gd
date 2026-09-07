# LevelProgression.gd
# Manages level progression and unlocks

extends Node

var current_level_index = 0
var zones_completed = {}
var level_times = {}
var level_best_times = {}

func _ready():
	for zone in GameConstants.ZONE.values():
		zones_completed[zone] = false
		level_times[zone] = 0.0
		level_best_times[zone] = 999999.0

func complete_level(zone: int, time: float, score: int) -> void:
	zones_completed[zone] = true
	level_times[zone] = time
	
	if time < level_best_times[zone]:
		level_best_times[zone] = time
	
	# Unlock next level
	if zone < GameConstants.ZONE.values().size() - 1:
		zones_completed[zone + 1] = true

func get_completion_percentage() -> float:
	var completed = 0
	for zone in zones_completed:
		if zones_completed[zone]:
			completed += 1
	
	return float(completed) / float(zones_completed.size()) * 100.0

func is_zone_unlocked(zone: int) -> bool:
	if zone == GameConstants.ZONE.GREEN_HILL:
		return true # First zone always unlocked
	return zones_completed.get(zone - 1, false)
