class_name AttackingThoughts extends CharacterBody2D

@export var speed := 200.0
@export var weight: = 20.0
var direction: Vector2
var distance: float
var _player: Player = null

func _physics_process(delta: float) -> void:
	global_scale = global_scale.clamp(Vector2(0.4, 0.4), Vector2(3,3))
	if _player == null:
		$AttackingSprite.core_position = lerp($AttackingSprite.core_position, Vector2.ZERO, weight * delta)
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
	$AnimationPlayer.stop()
	$AnimationPlayer.play("attack")


func _on_following_state_physics_processing(delta: float) -> void:
	if not _player == null:
		direction = global_position.direction_to(_player.global_position)
		distance = global_position.distance_to(_player.global_position)
		speed = 100.0 if distance > 350.0 else 200.0
		$AttackingSprite.core_position = lerp($AttackingSprite.core_position, $AttackingSprite.shift_core_position, weight * delta)
		rotation = lerp_angle(rotation, direction.orthogonal().angle(), weight * delta)
		velocity = lerp(velocity, speed * direction, weight * delta)
	move_and_slide()
