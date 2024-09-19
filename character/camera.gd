extends Camera3D

func aim():
	var cursor = get_viewport().get_mouse_position()
	var plane = Plane(Vector3.UP)
	var from = project_ray_origin(cursor)
	var intersection = plane.intersects_ray(from, project_ray_normal(cursor))

	if intersection:
		return intersection
