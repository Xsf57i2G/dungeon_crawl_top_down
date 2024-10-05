class_name Voxel
extends StaticBody3D

var health = 1
var items = {
}

func hit(n):
	$AnimationPlayer.play("Hit")

	health -= n
	if health <= 0:
		queue_free()

func _on_animation_player_animation_finished(_anim_name):
	queue_free()
