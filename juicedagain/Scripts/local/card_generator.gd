extends Node2D

const CARD_SCENE = preload("res://Prefabs/card.tscn")

# creates the card. That's all this script is used for
func create_card(card_data: CARD_DATA) -> CARDS:
	var card = CARD_SCENE.instantiate() as CARDS
	
	card.card_data = card_data.duplicate(true)
	
	return card
