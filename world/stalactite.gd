extends StaticBody3D

func fall():
	$AnimationPlayer.play("Fall")

func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
		fall()
