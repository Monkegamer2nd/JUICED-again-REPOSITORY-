extends Control
# to know where to go back to
const OPTIONS = "res://Scenes/options.tscn"

# connects the back button signal
func _ready() -> void:
	$Back.pressed.connect(back_button_pressed)

# goes back to options when clicking the back button
func back_button_pressed():
	SceneTransition.change_scene(OPTIONS, "cloud")
