extends CanvasLayer

@export var viewport_size: Vector2
var ui_text_size: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%PlayButton.grab_focus()
	$AnimationPlayer.play("idle_title")
	DisplayServer.window_set_min_size(Vector2(400.0, 700.0), 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#if Input.is_anything_pressed():
		#visible = false
		#get_tree().paused = false
	viewport_adapt_ui()
	if DisplayServer.window_get_mode() == 3 or DisplayServer.window_get_mode() == 4:
		%FullscreenButton.text = "Fullscreen [ON]"
	else:
		%FullscreenButton.text = "Fullscreen [OFF]"


func viewport_adapt_ui() -> void:
	viewport_size = get_viewport().get_visible_rect().size
	ui_text_size = viewport_size.y / 60.0
	$MarginContainer.size = viewport_size 

	# Font Size
	if viewport_size.y >= viewport_size.x * 1.6:
		%Shade.add_theme_font_size_override("font_size", ui_text_size * 6)
		%Title.add_theme_font_size_override("font_size", ui_text_size * 6)
	else:
		%Shade.add_theme_font_size_override("font_size", ui_text_size * 8)
		%Title.add_theme_font_size_override("font_size", ui_text_size * 8)
	
	%PlayButton.add_theme_font_size_override("font_size", ui_text_size * 2)
	%RestartButton.add_theme_font_size_override("font_size", ui_text_size * 2)
	%QuitButton.add_theme_font_size_override("font_size", ui_text_size * 2)
	%FullscreenButton.add_theme_font_size_override("font_size", ui_text_size * 2)
	%CreditsLabel.add_theme_font_size_override("font_size", ui_text_size)
	
	# Custom Minimum Size
	%Shade.custom_minimum_size = viewport_size / 3
	%Title.custom_minimum_size = viewport_size / 3
