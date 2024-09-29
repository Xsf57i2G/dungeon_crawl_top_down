extends Character
class_name Monster

var astar = AStar3D.new()
var path: Array = []
var index: int = 0

func _ready():
	var size = Vector3(128, 0, 128)

	for x in size.x:
		for z in size.z:
			var at = Vector3(x, 0, z)
			var id = vector3_to_id(at)
			astar.add_point(id, at)

	for i in size.x:
		for k in size.z:
			var at = Vector3(i, 0, k)
			var id = vector3_to_id(at)
			if i > 0:
				astar.connect_points(id, vector3_to_id(at + Vector3.LEFT))
			if i < size.x:
				astar.connect_points(id, vector3_to_id(at + Vector3.RIGHT))
			if k > 0:
				astar.connect_points(id, vector3_to_id(at + Vector3.FORWARD))
			if k < size.z:
				astar.connect_points(id, vector3_to_id(at + Vector3.BACK))

func _process(delta):
	if path.size() > 0:
		velocity = position.direction_to(path[index]) * speed
		position += velocity * delta

		if position.distance_to(path[index]) < speed * delta:
			index += 1
			if index >= path.size():
				path.clear()
	else:
		for body in $Area3D.get_overlapping_bodies():
			if body is Demon:
				find_path(global_position, body.global_position)
				index = 0


func vector3_to_id(at):
	return int(at.x) + int(at.y) + int(at.z)

func find_path(from, to):
	path.clear()
	path = astar.get_point_path(astar.get_closest_point(from), astar.get_closest_point(to))
