extends Node3D

var astar = AStar3D.new()
var noise = FastNoiseLite.new()
var width = 64
var depth = 64
var structures = {
	preload("res://world/ladder.tscn"): 1.0,
	preload("res://world/voxel.tscn"): 1.0,
	preload("res://world/stalactite.tscn"): 0.001,
}
var items = {
	preload("res://item/bomb.tscn"): 0.001,
	preload("res://item/key.tscn"): 0.0001,
	preload("res://item/chest.tscn"): 0.001,
	preload("res://item/torch.tscn"): 0.005,
	preload("res://item/potion.tscn"): 0.001,
	preload("res://item/skull.tscn"): 0.001,
}
var monsters = {
}

func _ready():
	noise.seed = randi()
	noise.frequency = 0.1

	generate()

func generate():
	var voxel_positions = {}
	var id = 0
	var neighbors = [
		Vector3(0, 0, 1),
		Vector3(0, 0, -1),
		Vector3(1, 0, 0),
		Vector3(-1, 0, 0),
	]

	for x in range(-width, width):
		for z in range(-depth, depth):
			var n = noise.get_noise_2d(x, z)
			if n > 0.01 and (abs(x) >= 6 or abs(z) >= 6):
				var voxel = structures.keys()[1].instantiate()
				voxel.scale = Vector3(1, n + 1, 1)
				voxel.position = Vector3(x, (n + 1) / 2, z)
				add_child(voxel)
				voxel_positions[Vector3(x, 0, z)] = voxel.position.y

				astar.add_point(id, voxel.position)
				id += 1

	for point_id in astar.get_point_ids():
		var point_position = astar.get_point_position(point_id)
		for neighbor in neighbors:
			var neighbor_position = point_position + neighbor
			if voxel_positions.has(Vector3(neighbor_position.x, 0, neighbor_position.z)):
				astar.connect_points(point_id, astar.get_closest_point(neighbor_position))

	for x in range(-width, width):
		for z in range(-depth, depth):
			if randf() < 0.01:
				for monster in monsters.keys():
					if randf() < monsters[monster]:
						spawn(monster, Vector3(x, 1, z))
			for i in items.keys():
				if randf() < items[i]:
					var item = i.instantiate()
					item.position = Vector3(x, 1, z)
					add_child(item)

	var ladder = preload("res://world/ladder.tscn").instantiate()
	add_child(ladder)

func spawn(what, where):
	var w = what.instantiate()
	w.position = where
	add_child(w)

func _on_mercenary_dropped(item):
	item.reparent(self)