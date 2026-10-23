extends HBoxContainer

var starting_position : Vector2
# tweening information
func _ready() -> void:
	starting_position = self.position
