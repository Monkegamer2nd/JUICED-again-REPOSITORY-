extends Node

#Card-related events
@warning_ignore("unused_signal")
# When the card is clicked and dragged this signal is called
signal card_aim_started(card : CARDS)
@warning_ignore("unused_signal")
# When the card is let go after the card is aimed
signal card_aim_ended(card: CARDS)

# Note: Because the signals aren't called in this script I've added @warning_ignore to make it so that the signals warnings are gone
