extends Area3D

func _on_body_entered(body):
	if body.has_method("hit"):
		body.hit(10)

func _on_animation_player_animation_finished(_anim_name):
	get_parent().queue_free()
