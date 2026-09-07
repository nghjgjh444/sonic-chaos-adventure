# AudioManager.gd
# Central audio management system

extends Node

var music_player: AudioStreamPlayer
var sfx_players = []
var master_volume = 1.0
var music_volume = 1.0
var sfx_volume = 1.0

func _ready():
	set_name("AudioManager")
	# Create music player
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = "Music"
	
	# Create SFX players pool
	for i in range(8):
		var sfx_player = AudioStreamPlayer.new()
		add_child(sfx_player)
		sfx_player.bus = "SFX"
		sfx_players.append(sfx_player)

func play_music(music_path: String, fade_in: float = 0.0) -> void:
	if music_path.empty():
		return
	
	var audio = load(music_path)
	if audio:
		music_player.stream = audio
		music_player.play()

func play_sfx(sfx_path: String, volume: float = 0.0) -> void:
	if sfx_path.empty():
		return
	
	var audio = load(sfx_path)
	if audio:
		for player in sfx_players:
			if not player.playing:
				player.stream = audio
				player.volume_db = volume
				player.play()
				return

func stop_music() -> void:
	music_player.stop()

func set_master_volume(volume: float) -> void:
	master_volume = clamp(volume, 0.0, 1.0)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), volume == 0.0)

func set_music_volume(volume: float) -> void:
	music_volume = clamp(volume, 0.0, 1.0)
	var db = linear2db(music_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db)

func set_sfx_volume(volume: float) -> void:
	sfx_volume = clamp(volume, 0.0, 1.0)
	var db = linear2db(sfx_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db)
