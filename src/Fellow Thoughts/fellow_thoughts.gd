class_name FellowThoughts extends CharacterBody2D

@export var speed := 300.0
@export var weight: = 20.0
var direction: Vector2
var distance: float
var _player: Player = null
var following: bool = false

func _physics_process(delta: float) -> void:
	global_scale = global_scale.clamp(Vector2(0.4, 0.4), Vector2(3, 3))
	if _player == null:
		$FellowSprite.core_position = lerp($FellowSprite.core_position, Vector2.ZERO, weight * delta)
		velocity = lerp(velocity, Vector2.ZERO, weight * delta)
	move_and_slide()


func _on_follow_area_body_entered(body: Node2D) -> void:
	if body is Player:
		_player = body
		$StateChart.send_event("body_entered")
	if $MergeArea.get_overlapping_bodies().size() >= 5:
		$StateChart.send_event("merge")

func _on_follow_area_body_exited(body: Node2D) -> void:
	if body is Player:
		_player = null
		$StateChart.send_event("body_exited")


func _on_idle_state_entered() -> void:
	$AnimationPlayer.play("idle")


func _on_following_state_entered() -> void:
	following = true


func _on_following_state_physics_processing(delta: float) -> void:
	if not _player == null:
		direction = global_position.direction_to(_player.global_position)
		distance = global_position.distance_to(_player.global_position)
		speed = 300.0 if distance > 250.0 else 150.0
		$FellowSprite.core_position = lerp($FellowSprite.core_position, $FellowSprite.shift_core_position, weight * delta)
		rotation = lerp_angle(rotation, direction.orthogonal().angle(), weight * delta)
		velocity = lerp(velocity, speed * direction, weight * delta)
	move_and_slide()


func _on_merging_state_entered() -> void:
	
	await get_tree().create_timer(1).timeout
	for bodies in $MergeArea.get_overlapping_bodies():
		var BodiesArray: Array = $MergeArea.get_overlapping_bodies()
		if bodies == BodiesArray.pick_random():
			bodies.scale += Vector2(0.4, 0.4)
			bodies.self_modulate += Color(0.2, 0.2, 0.2)
			%MergeAuio.play()
		elif bodies is FellowThoughts:
			#$AnimationPlayer.play("burst")
			bodies.queue_free()
	$StateChart.send_event("to_idle")


func _on_following_state_exited() -> void:
	following = false
