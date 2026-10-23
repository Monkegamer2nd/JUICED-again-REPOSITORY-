class_name SPEED_DICE_UI
extends Control

# signals for hover on or off
signal dice_hovered_on
signal dice_hovered_off

# sprites for dice
const DESTROYED_DICE = preload("res://Sprites/Dice/Torn.png")
const NORMAL_DICE = preload("res://Sprites/Dice/Blank.png")

# nodes on scene
@onready var speed_value_label : Label = $Label
@onready var hover_area : Area2D = $Hover_area
@onready var select_highlight : ColorRect = $ColorRect
@onready var sprite : TextureRect = $TextureRect

# tracking variables for other scripts primarily
var dice_owner
var card_for_dice : Array = []
var target_speed_dice : Array = []
var viable_clashing_speed_dice : Array = []
var current_speed_dice_has_card_chosen = false
var chosen_card : Resource
var target_character : Node
var current_target_index : int
var starting_target_index : int
var player_card_data: Dictionary = {}
var enemy_card_data: Dictionary = {}
var speed_dice_value : int

# makes sure select highlight is nonvisible until useful
func _ready() -> void:
	select_highlight.visible = false

# sets speed value
func set_value(value: int) -> void:
	speed_dice_value = value
	speed_value_label.text = str(speed_dice_value)

# when hovered over emit
func _on_hover_area_mouse_entered() -> void:
	dice_hovered_on.emit(self)

# when hovered off emit
func _on_hover_area_mouse_exited() -> void:
	dice_hovered_off.emit(self)

# what action is on this speed dice (primarily for enemy)
func assign_action(card : Resource, target : Node2D, slot_index: int) -> void:
	chosen_card = card
	target_character = target
	starting_target_index = slot_index
	current_target_index = slot_index

# changes the sprite and disable player dice when stagger is true 
func set_stagger_state(is_staggered : bool):
	if dice_owner is MAIN_PLAYER:
		speed_value_label.visible = !is_staggered
		sprite.texture = DESTROYED_DICE if is_staggered else NORMAL_DICE
		hover_area.get_child(0).disabled = is_staggered
		
		if is_staggered:
			card_for_dice.clear()
			viable_clashing_speed_dice.clear()
	else:
		speed_value_label.visible = !is_staggered
		sprite.texture = DESTROYED_DICE if is_staggered else NORMAL_DICE
		
		if is_staggered:
			chosen_card = null
			viable_clashing_speed_dice.clear()
