extends Fixture

func _on_animation_player_animation_finished(_anim_name):
	for body in $Area3D.get_overlapping_bodies():
		if body.has_method("hit"):
			body.hit(1)
