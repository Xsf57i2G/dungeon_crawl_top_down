class_name Character
extends RigidBody3D

var health = 3

func hit(n):
	$Babe/AnimationPlayer.play("Fall")

	health -= n
	if health <= 0:
		queue_free()

func _on_animation_player_animation_finished(_anim_name):
	$Babe/AnimationPlayer.play("Idle")
