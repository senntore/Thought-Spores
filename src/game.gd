extends Node2D

var current_state: String = "start"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
		var viewport_size := get_viewport().get_visible_rect().size
		if viewport_size.y >= viewport_size.x * 1.6:
			%Camera2D.zoom = Vector2(2, 2)
	

#func _unhandled_input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("ui_menu"):
		#get_tree().paused = not get_tree().paused
		#%CanvasLayer.visible = not %CanvasLayer.visible


func _on_root_state_entered() -> void:
	%Background.play()


func _on_play_button_pressed() -> void:
	get_tree().paused = false
	$StateChart.send_event("play")


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_start_state_entered() -> void:
	
	current_state = "start"
	%StartScreen.visible = true
	get_tree().paused = true
	%PlayButton.grab_focus()
	
	$Particles/GPUParticles2D2.process_mode = Node.PROCESS_MODE_ALWAYS
	await get_tree().create_timer(0.6).timeout
	
	$Particles/GPUParticles2D2.process_mode = Node.PROCESS_MODE_INHERIT
	
	pass # Replace with function body.






func _on_play_state_entered() -> void:
	%StartScreen.visible = false
	get_tree().paused = false
	current_state = "play"
	pass


func _on_root_state_unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu"):
		if current_state == "start":
			%StateChart.send_event("play")
		elif current_state == "play":
			%StateChart.send_event("start")
