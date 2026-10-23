extends Node2D

# signal for when it lands on an enemy
signal enemy_selected
# how many points the arc has, less equals more spiky, more equals more smooth (less are easier to load in)
const ARC_POINTS := 15

# nodes for the line and arrow and the outline
@onready var area_2d: Area2D = $CanvasLayer/CardArc/Area2D
@onready var arrow2: Area2D = $CanvasLayer/CardArc2/Area2D
@onready var card_arc: Line2D = $CanvasLayer/CardArc
@onready var card_arc2: Line2D = $CanvasLayer/CardArc2

# variablels for tracking states and what card the arrow is for
var current_card: CARDS
var targeting := false
var screen_size
var mouse_pos
var current_target : Area2D

#sets the information for when it comes in initially.
func _ready() -> void:
	area_2d.visible = false
	arrow2.visible = false
	screen_size = get_viewport_rect().size
	Events.card_aim_started.connect(_on_card_aim_started)
	Events.card_aim_ended.connect(_on_card_aim_ended)

# makes the arrow follow the mouse, and calculates the points and the direction of the arrow
func _process(_delta: float) -> void:
	if not targeting:
		return
	
	mouse_pos = get_viewport().get_mouse_position()
	area_2d.global_position = get_global_mouse_position()
	arrow2.global_position = get_global_mouse_position()
	card_arc.points = _get_points()
	card_arc2.points = _get_points()
	
	if card_arc.points.size() >= 2:
		var end_point = card_arc.points[-1]
		var previous_point = card_arc.points[-2]
		var dir = (end_point - previous_point).normalized()
		
		var arrow = $CanvasLayer/CardArc/Area2D/Arrow
		arrow.position = area_2d.to_local(end_point)
		arrow.rotation = dir.angle()
		
	if card_arc2.points.size() >= 2:
		var end_point = card_arc2.points[-1]
		var previous_point = card_arc2.points[-2]
		var dir = (end_point - previous_point).normalized()
		
		var arrow = $CanvasLayer/CardArc2/Area2D/Arrow
		arrow.position = area_2d.to_local(end_point)
		arrow.rotation = dir.angle()
	

# calculates the points of each part on the line
func _get_points() -> Array:
	var points := []
	
	var start := current_card.get_global_transform_with_canvas().origin
	
	var target = get_viewport().get_mouse_position()
	var distance = target - start
	
	for i in range(ARC_POINTS):
		var t := (1.0 / ARC_POINTS) * i
		var x = start.x + (distance.x / ARC_POINTS) * i
		var y = start.y + ease_out_cubic(t) * distance.y
		
		points.append(Vector2(clamp(x, 0, screen_size.x), clamp(y, 0, screen_size.y)))
	
	points.append(Vector2(clamp(target.x, 0, screen_size.x), clamp(target.y, 0, screen_size.y)))
	
	return points
	

# eases out for the y
func ease_out_cubic(number : float) -> float:
	var final_value = 1.0 - pow(1.0 - number, 3.0)
	return final_value

# makes itself visible and starts the arrow and line
func _on_card_aim_started(card: CARDS) -> void:
	targeting = true
	area_2d.visible = true
	area_2d.monitoring = true
	area_2d.monitorable = true
	arrow2.visible = true
	current_card = card

# gets rid of the arrow and the line
func _on_card_aim_ended(_card: CARDS) -> void:
	if current_card and current_target:
		var target_parent = current_target.get_parent()
		current_card.targets.clear()
		current_card.targets.append(target_parent)
		emit_signal("enemy_selected", current_card)
			
			
	targeting = false
	card_arc.clear_points()
	card_arc2.clear_points()
	area_2d.position = Vector2.ZERO
	area_2d.monitoring = false
	area_2d.visible = false
	area_2d.monitorable = false
	arrow2.position = Vector2.ZERO
	arrow2.visible = false
	current_card = null

# tracks the current target and whats under the arrow
func _on_area_2d_area_entered(area: Area2D) -> void:
	if not current_card or not targeting:
		return
	
	current_target = area

# when area2D is exited from anything it erases the previous target as the current target
func _on_area_2d_area_exited(area: Area2D) -> void:
	if current_target == area:
		current_target = null
