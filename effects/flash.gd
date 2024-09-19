extends MeshInstance3D

func _process(delta):
	rotate_z(randf_range(0, TAU) * delta)

func _on_timer_timeout():
	hide()
