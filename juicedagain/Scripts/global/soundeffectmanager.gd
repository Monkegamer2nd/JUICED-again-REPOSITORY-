extends Node

# sound effects and their name
const SOUND_EFFECT_LIBRARY : Dictionary = {
"running": [preload("res://Sounds/SoundEffects/runningsound.mp3")], 
"throwing_attack": [preload("res://Sounds/SoundEffects/Punch whoosh.wav"),  preload("res://Sounds/SoundEffects/Fight Whoosh 4.wav"), preload("res://Sounds/SoundEffects/Fight Whoosh 5.wav")], 
"hit": [preload("res://Sounds/SoundEffects/Impact whoosh.wav")], 
"stagger_hit": [preload("res://Sounds/SoundEffects/Impact 2.wav")],
"block_hit": [preload("res://Sounds/SoundEffects/cloth 1.wav")],
"back_off": [preload("res://Sounds/SoundEffects/another whoosh.wav")],
"clash_tie": [preload("res://Sounds/SoundEffects/Fight Hit 13.wav")],
"card_rustle": [preload("res://Sounds/SoundEffects/cardrustle.mp3")], 
"dice_select": [preload("res://Sounds/SoundEffects/click.mp3")], 
"metal_crush": [preload("res://Sounds/SoundEffects/metal SLAM.mp3")],
"glass_explosion": [preload("res://Sounds/SoundEffects/Explosion glass break.mp3")], 
"win_effect": [preload("res://Sounds/SoundEffects/win_sound_effects.mp3")], 
"lose_jingle": [preload("res://Sounds/SoundEffects/fail_sound.mp3")],
}
# music and their name
const MUSIC_LIBRARY : Dictionary = {
"main_menu_theme": preload("res://Sounds/Music/ThinkMenu.mp3"),
"start_screen_theme": preload("res://Sounds/Music/StartMenu.mp3"),
"lose_screen_theme": preload("res://Sounds/Music/Deep ambient.wav"),
"win_screen_theme": preload("res://Sounds/Music/Winwin.mp3"),
"fight_theme": preload("res://Sounds/Music/FightThink.mp3"),
"cutscene_theme": preload("res://Sounds/Music/ThinkThink.mp3"),
}

#audio players (two playeres to fade from one song to another)
var player_1: AudioStreamPlayer
var player_2: AudioStreamPlayer
var current_player: AudioStreamPlayer

#current name of the music
var current_track_name: String = ""

# adding the audio players
func _ready():
	player_1 = AudioStreamPlayer.new()
	player_2 = AudioStreamPlayer.new()
	player_1.bus = "Music"
	player_2.bus = "Music"
	add_child(player_1)
	add_child(player_2)
	current_player = player_1

# playing the music, and fading it away as well.
func play_music(track_name: String, fade_time: float = 1.5, loop: bool = true,  target_volume: float = 0.0):
	if not MUSIC_LIBRARY.has(track_name):
		push_error("Music manager: Track '" + track_name + "' not found!")
		return
		
	if current_track_name == track_name and current_player.playing:
		return
		
	current_track_name = track_name
	var next_stream: AudioStream = MUSIC_LIBRARY[track_name]
	var next_player: AudioStreamPlayer = player_2 if current_player == player_1 else player_1
	
	next_player.stream = next_stream
	if "loop" in next_player.stream:
		next_player.stream.loop = loop
	elif loop:
		if next_player.finished.is_connected(next_player.play):
			next_player.finished.disconnect(next_player.play)
		next_player.finished.connect(next_player.play)
	
	# fading the new audio player on
	var tween = create_tween().set_parallel(true)
	
	if current_player.playing:
		tween.tween_property(current_player, "volume_db", -80.0, fade_time)
		tween.chain().tween_callback(current_player.stop)
	
	next_player.volume_db = -80.0
	next_player.play()
	tween.tween_property(next_player, "volume_db", target_volume, fade_time)
	
	current_player = next_player

# playing the sound effect and changing it depending on the variables put in.
func play_sfx(sound_name: String, bus_name: String = "SFX", volume_modifier: float = 0.0, pitch_scale: float = 1.0, from_position: float = 0.0, max_duration: float = 0.0):
	if not SOUND_EFFECT_LIBRARY.has(sound_name):
		return
	
	var selected_stream: AudioStream = SOUND_EFFECT_LIBRARY[sound_name].pick_random()
	# modifying the player based on what is put into the function and making the player
	var player = AudioStreamPlayer.new()
	player.stream = selected_stream
	player.bus = bus_name 
	player.pitch_scale = pitch_scale
	player.volume_db = volume_modifier
	get_tree().root.add_child(player)
	player.play(from_position)
	#getting rid of the player when finished
	player.finished.connect(player.queue_free)
	
	if max_duration > 0.0:
		var tween = create_tween()
		tween.bind_node(player)
		tween.tween_interval(max_duration)
		tween.tween_callback(func():
			if is_instance_valid(player):
				if player.finished.is_connected(player.queue_free):
					player.finished.disconnect(player.queue_free)
				player.stop()
				player.queue_free()
		)

# fades the music away and stops it
func stop_music(fade_time: float = 1.0):
	if current_player.playing:
		var tween = create_tween()
		tween.tween_property(current_player, "volume_db", -80.0, fade_time)
		tween.tween_callback(current_player.stop)
		current_track_name = ""
