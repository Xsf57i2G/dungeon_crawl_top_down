extends Fixture

func _process(_delta):
	for body in $Area3D.get_overlapping_bodies():
		if body.has_method("hit"):
			body.hit(10)

func _on_area_3d_body_entered(_body):
	print("Ouch!")
