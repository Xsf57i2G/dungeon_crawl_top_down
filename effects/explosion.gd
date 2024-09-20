extends Area3D

func _on_body_entered(body: Node3D):
	if body.has_method("hit"):
		body.hit(10)

	if body is Bomb:
		body.explode()

func _on_animation_player_animation_finished(_anim_name: StringName):
	get_parent().queue_free()
