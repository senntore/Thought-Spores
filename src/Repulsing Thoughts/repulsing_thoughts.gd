class_name RepulsingThoughts extends CharacterBody2D

@export var speed := 300.0
@export var weight: = 20.0
var direction: Vector2
var distance: float
var _player: Player = null

const REPULSING_THOUGHTS = preload("res://Repulsing Thoughts/repulsing_thoughts.tscn")

func _physics_process(delta: float) -> void:
	global_scale = global_scale.clamp(Vector2(0.4, 0.4), Vector2(3, 3))
	if _player == null:
		$RepulsingSprite.core_position = lerp($RepulsingSprite.core_position, Vector2.ZERO, weight * delta)
		velocity = lerp(velocity, Vector2.ZERO, weight * delta)
	move_and_slide()


func _on_follow_area_body_entered(body: Node2D) -> void:
	if body is Player:
		_player = body
		$StateChart.send_event("body_entered")

func _on_follow_area_body_exited(body: Node2D) -> void:
	if body is Player:
		_player = null
		$StateChart.send_event("body_exited")


func _on_idle_state_entered() -> void:
	$AnimationPlayer.play("idle")


func _on_following_state_entered() -> void:
	pass


func _on_following_state_physics_processing(delta: float) -> void:
	if not _player == null:
		direction = global_position.direction_to(_player.global_position)
		distance = global_position.distance_to(_player.global_position)
		speed = 180.0 if distance > 250.0 else 300.0
		$RepulsingSprite.core_position = lerp($RepulsingSprite.core_position, $RepulsingSprite.shift_core_position, weight * delta)
		rotation = lerp_angle(rotation, direction.orthogonal().angle(), weight * delta)
		velocity = lerp(velocity, -(speed * direction), weight * delta)
	move_and_slide()


func _on_separation_area_body_entered(body: Node2D) -> void:
	await get_tree().create_timer(0.6).timeout
	if is_instance_valid(body) && body is Player:
		for seperation in 2:
			var new_repulsing_thoughts := REPULSING_THOUGHTS.instantiate()
			new_repulsing_thoughts.global_scale = self.global_scale - Vector2(0.4, 0.4)
			new_repulsing_thoughts.global_position = self.global_position + Vector2(10, 10) * direction.sign()
			get_parent().call_deferred("add_child", new_repulsing_thoughts)
			
		#$AnimationPlayer.play("burst")
		%SplitAudio.play()
		self.visible = false
		await get_tree().create_timer(0.3)
		self.queue_free()
