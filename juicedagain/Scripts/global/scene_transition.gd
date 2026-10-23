extends CanvasLayer

#Just a sound effect
const CLOUD_WOOSH = preload("res://Sounds/SoundEffects/another whoosh.wav")

#onreaedy variables from the scene to call
@onready var cloud: TextureRect = $CloudTransition
@onready var fade: ColorRect = $FadeTransition
@onready var shield: ColorRect = $InputShield
# level id to track
var current_level_id : String = "Tutorial Level"
# current floor level for tracking/progress
var current_floor_level : int = 0
# the reward amount, changes for each level
var reward_amount : int = 5
# previous scene to track (Make it so the start menu can use the same options as the main menu)
var previous_scene = "res://Scenes/main_menu.tscn"
# just for cutscenes
var next_cutscene_data: CutsceneData = null
#allows for skipping
var next_scene_after_cutscene: String = ""

# make sure that they don't affect game when instantiated
func _ready() -> void:
	cloud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shield.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade.modulate.a = 0.0

# the visuals on the screen changing and also changing the scene
func change_scene(target_scene_path: String, style: String = "fade") -> void:
	var screen_size = get_viewport().get_visible_rect().size
	
	#cloud fade away
	if style == "cloud":
		shield.mouse_filter = Control.MOUSE_FILTER_STOP
		cloud.size = screen_size
		cloud.position.y = -screen_size.y
		var player = AudioStreamPlayer.new()
		player.stream = CLOUD_WOOSH
		player.bus = "SFX" 
		player.pitch_scale = 1.0
		player.volume_db = 0.0
		get_tree().root.add_child(player)
		player.play(0.5)
		player.finished.connect(player.queue_free)
		
		var tween_out = create_tween()
		tween_out.tween_property(cloud, "position:y", 0.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		await tween_out.finished
		
	# normal fade away
	elif style == "fade":
		fade.mouse_filter = Control.MOUSE_FILTER_STOP
		
		var tween = create_tween()
		tween.tween_property(fade, "modulate:a", 1.0, 0.4)
		await tween.finished
	
	#changing the scene
	get_tree().change_scene_to_file(target_scene_path)
	await get_tree().process_frame
	
	# cloud goes off the screen
	if style == "cloud":
		var tween = create_tween()
		tween.tween_property(cloud, "position:y", screen_size.y, 0.5).set_trans(Tween.TRANS_CUBIC)
		await tween.finished
		shield.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	#black fade goes away
	elif style == "fade":
		var tween = create_tween()
		tween.tween_property(fade, "modulate:a", 0.0, 0.4)
		await tween.finished
		fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
