extends TextureRect

# for hovered over and off
signal hovered_over
signal hovered_off

# labels and collision shapes
@onready var fruit_name : Label = $FruitName
@onready var amount : Label = $Amount
@onready var collider : CollisionShape2D = $Area2D/CollisionShape2D

# data on the fruit for the deck
var fruit_data : Resource

# sets up the name label and the amount of the fruit, how much the player may or may not have
func set_up_name_and_amount(name_of_fruit, amount_value):
	self.texture = name_of_fruit.fruit_art
	fruit_name.text = name_of_fruit.id
	amount.text = str(amount_value)

# emits the hovered on signal when hovered on
func _on_mouse_entered() -> void:
	emit_signal("hovered_over", self)

# emits hovered off when hovered off
func _on_mouse_exited() -> void:
	emit_signal("hovered_off", self)
