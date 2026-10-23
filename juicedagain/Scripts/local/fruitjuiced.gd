extends Control

# tween speed
const DEFAULT_SPEED = 0.1
# the cards in the fruit
const DECK_CARDS = preload("res://Prefabs/deck_card.tscn")

# nodes in the scene
@onready var card_rewards_available_container = $ScrollContainer/GridContainer
@onready var cards_display = $CardsDisplay

# shows the information to the player for the cards gained
func _ready() -> void:
	for card_item in GlobalData.card_reward_information:
		var card_instance = DECK_CARDS.instantiate()
		card_instance.card_data = card_item
		card_rewards_available_container.add_child(card_instance)
		card_instance.mouse_entered.connect(_on_card_mouse_entered.bind(card_instance))

# shows the cards information when hovering over a card
func _on_card_mouse_entered(hovered_card):
	cards_display.get_child(0).setup_labels(hovered_card.card_data)
	cards_display.get_child(0).setup_dice(hovered_card.card_data)
	cards_display.get_child(0).setup_dice_information(hovered_card.card_data)
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(cards_display, "position", Vector2(cards_display.position.x, cards_display.get_child(0).starting_position.y + 100), DEFAULT_SPEED)

# goes on to the main menu
func _on_continue_pressed() -> void:
	GlobalData.card_reward_information.clear()
	SceneTransition.change_scene("res://Scenes/main_menu.tscn", "fade")
