extends Area3D

func _on_body_entered(body):
	if body.has_method("hit"):
		body.hit(1)

	await get_tree().create_timer(0.5).timeout

	get_parent().queue_free()
