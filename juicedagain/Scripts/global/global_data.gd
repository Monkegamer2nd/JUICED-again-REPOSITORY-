extends Node

# this signal is called when user changes settings to make it the same across each scene with settinsg
signal setting_changed(setting_name: String, value: float)

#This constant is for the future. To track what a floor requires to be unlocked
const FLOOR_UNLOCK_REQUIREMENTS = {}

# What floor the player is on
var highest_unlocked_floor: int = 0
# What levels the player has beaten (so that the level complete variable is raised from beating the same level)
var completed_levels: Array[String] = []
# Level complete, tracks the levels that the player has completed to instantiate the next level button.
var level_complete: int = 0
# What is IN the player's inventory (rewards)
var player_inventory: Dictionary = {}
# What is IN the player's inventory (cards)
var unlocked_combat_cards: Array[Resource] = [
	preload("res://Cards/basic_attack.tres"),
	preload("res://Cards/basic_block.tres"),
	preload("res://Cards/heavy_attack.tres"),
	preload("res://Cards/cower_away.tres")
]
# What is ON the player rewards. Used on the JUICING screen
var card_reward_information : Array = []
# What is the player rewards. Used on the Win and Lose screen.
var reward_information: Dictionary = {}
# The current player data saved, set to a default of default player
var saved_character_data : Resource = preload("res://Characters/defaultplayer.tres")
# volume settings for other scripts
var master_volume: float = 0.5
var sfx_volume: float = 0.5
# fullscreen for the fullscreen switch
var is_fullscreen: bool = false

# press the fullscreen button and it will set the screen to fullscreen
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		set_fullscreen(!is_fullscreen)

# sets the screen to fullscreen and updates is_fullscreen for fullscreen switch
func set_fullscreen(value: bool) -> void:
	is_fullscreen = value
	
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

# set setting to the correct value, to make it constant between scenes
func set_setting(setting_name: String, value: float) -> void:
	if setting_name in self:
		self[setting_name] = value
		setting_changed.emit(setting_name, value)

# simple clear level, adds to the level complete if its the first time clearing
func clear_level(level_id: String, floor_number: int) -> void:
	if not completed_levels.has(level_id):
		completed_levels.append(level_id)
		level_complete += 1
	
	# unlocks the next floor, for the future (STILL WIP but not needed for now)
	if FLOOR_UNLOCK_REQUIREMENTS.has(floor_number):
		var required_continuation_id = FLOOR_UNLOCK_REQUIREMENTS[floor_number]
		if level_id == required_continuation_id and highest_unlocked_floor == floor_number:
			highest_unlocked_floor += 1
