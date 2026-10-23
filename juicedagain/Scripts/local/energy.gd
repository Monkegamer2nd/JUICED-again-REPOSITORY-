extends Control

const FULL_ENERGY = preload("res://Sprites/Misc/Energy.png")
const EMPTY_ENERGY = preload("res://Sprites/Misc/Empty_Energy.png")
# both sprites for the energy
@onready var energy_sprite = $EnergySprite

# determines which sprite needs to be filled or not
func set_filled(is_filled: bool):
	if is_filled:
		energy_sprite.texture = FULL_ENERGY
	else:
		energy_sprite.texture = EMPTY_ENERGY
