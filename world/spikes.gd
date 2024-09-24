extends Fixture

func _process(_delta):
	for body in $Area3D.get_overlapping_bodies():
		if body.has_method("hit"):
			body.hit(10)
