@tool
extends Sprite2D
@export var outer_radius :=  30.0
@export var core_radius :=  10.0
@export var width := 0.6
@export var outer_color := Color.RED
@export var core_color := Color.LIGHT_PINK
@export var overlay_color := Color.RED
@export var core_position: Vector2 = Vector2(-4.0, 4.0)
@export var shift_core_position: Vector2

@export var has_core: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	shift_core_position = Vector2(0.0, outer_radius / 2.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	
	draw_circle(Vector2.ZERO, outer_radius, Color(overlay_color, 0.3), true, -1, true)
	draw_circle(Vector2.ZERO, outer_radius, outer_color, false, width, true)
	
	draw_circle(core_position, core_radius, core_color, true, -1, true)
	draw_circle(Vector2(8.0, -4.0), 5.0, Color.WHITE, true, -1, true)
