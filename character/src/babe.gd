class_name Babe
extends Character

var tired = false
var carried = false

func pickup():
	carried = true
	$Babe/AnimationPlayer.play("Carry")

func thrown():
	if tired or not $Timer.is_stopped():
		return

	$Timer.start()
	$Babe/AnimationPlayer.play("Thrown")
	tired = true

func wander():
	if carried:
		return

	$Babe/Armature/AnimationPlayer.play("Walk")

	var dir = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))
	dir = dir.normalized()
	linear_velocity = dir * 2.0

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Thrown":
		$Babe/Armature/Skeleton3D/Hand.hide()
		if carried:
			$Babe/AnimationPlayer.play("Carry")
		else:
			wander()

func _on_timer_timeout() -> void:
	tired = false
	if carried:
		$Babe/AnimationPlayer.play("Carry")
	else:
		wander()
