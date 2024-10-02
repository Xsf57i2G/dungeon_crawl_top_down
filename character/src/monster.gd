extends Character
class_name Monster

var astar = AStar3D.new()
var points = {}

func _ready():
	var size = Vector3(64, 0, 64)

	for x in range(-size.x, size.x):
		for z in range(-size.z, size.z):
			add_point(global_position + Vector3(x, 0, z))

	connect_points()

func _physics_process(_delta):
	for body in $Area3D.get_overlapping_bodies():
		if body is Demon:
			var path = find_path(global_position, body.global_position)
			if path.size() > 0:
				var next = path[path.size() - 1]
				global_position = next

func add_point(point):
	var id = astar.get_available_point_id()
	astar.add_point(id, point)
	points[vector3_to_id(point)] = id

func connect_points():
	for p in points.keys():
		var point = id_to_vector3(p)
		for offset in [-1, 0, 1]:
			var neighbor_id = vector3_to_id(point + Vector3(offset, 0, -1))
			if points.has(neighbor_id) and neighbor_id != p:
				astar.connect_points(points[p], points[neighbor_id])
			neighbor_id = vector3_to_id(point + Vector3(offset, 0, 1))
			if points.has(neighbor_id) and neighbor_id != p:
				astar.connect_points(points[p], points[neighbor_id])

func vector3_to_id(at):
	return int(at.x + 128) + int(at.z + 128) * 256

func id_to_vector3(id):
	return Vector3(id % 256 - 128, 0, id / 256 - 128)

func find_path(from, to):
	var from_id = vector3_to_id(from)
	var to_id = vector3_to_id(to)
	return astar.get_point_path(points.get(from_id, -1), points.get(to_id, -1)) if points.has(from_id) and points.has(to_id) else []
