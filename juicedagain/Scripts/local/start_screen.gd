extends Node2D

# plays start screen music
func _ready() -> void:
	SoundEffectManager.play_music("start_screen_theme", 0.5, true, -15)

# assigns values for tutorial level
func _on_button_pressed() -> void:
	SceneTransition.current_floor_level = -1
	SceneTransition.current_level_id = "Tutorial Level"
	SceneTransition.reward_amount = 4
	SceneTransition.next_cutscene_data = load("res://Cutscenes/prologue.tres")
	SceneTransition.next_scene_after_cutscene = "res://Scenes/tutorial.tscn"
	
	SceneTransition.change_scene("res://Scenes/main_cutscene.tscn", "fade")

# quits game
func _on_quit_button_pressed() -> void:
	get_tree().quit()

# goes to option scene
func _on_options_pressed() -> void:
	SceneTransition.previous_scene = "res://Scenes/start_screen.tscn"
	SceneTransition.change_scene("res://Scenes/options.tscn", "cloud")
