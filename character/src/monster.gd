extends Character
class_name Monster

var astar = AStar3D.new()
var points = {}
var step = 1.0

func _ready():
	var size = Vector3(64, 0, 64) / step

	for x in range(size.x):
		for z in range(size.z):
			add_point(global_position + Vector3(x * step, 0, z * step))

	connect_points()

func _physics_process(_delta):
	for body in $Area3D.get_overlapping_bodies():
		if body is Demon:
			var path = find_path(global_position, body.global_position)
			if path.size() > 1:
				global_position = path[1]

	move_and_slide()

func add_point(point):
	point.y = 0
	var id = astar.get_available_point_id()
	astar.add_point(id, point)
	points[vector3_to_id(point)] = id

func connect_points():
	for p in points.keys():
		var point = id_to_vector3(p)
		for x in range(-1, 2):
			for z in range(-1, 2):
				var neighbor_id = vector3_to_id(point + Vector3(x, 0, z))
				if points.has(neighbor_id) and neighbor_id != p:
					astar.connect_points(points[p], points[neighbor_id])

func vector3_to_id(at):
	return int(at.x) + int(at.z) * 128

func id_to_vector3(id):
	return Vector3(id % 128, 0, id / 128)

func find_path(from, to):
	var from_id = vector3_to_id(from)
	var to_id = vector3_to_id(to)
	return astar.get_point_path(points.get(from_id, -1), points.get(to_id, -1)) if points.has(from_id) and points.has(to_id) else []
