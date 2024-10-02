extends Node3D

var astar = AStar3D.new()
var noise = FastNoiseLite.new()
var width = 64
var depth = 64
var structures = {
	preload("res://world/brittle_voxel.tscn"): 1.0,
}
var items = {
	preload("res://item/bomb.tscn"): 0.001,
	preload("res://item/key.tscn"): 0.0001,
	preload("res://item/chest.tscn"): 0.0001,
	preload("res://item/torch.tscn"): 0.005,
	preload("res://item/potion.tscn"): 0.001,
	preload("res://item/skull.tscn"): 0.001,
	preload("res://world/spikes.tscn"): 1.0,
	preload("res://world/ladder.tscn"): 1.0,
	preload("res://world/stalactite.tscn"): 1.0,
}
var monsters = {
}
var allies = {
}

func _ready():
	noise.seed = randi()
	noise.frequency = 0.1

	generate()

func generate():
	var center_x = width / 2.0
	var center_z = depth / 2.0
	var radius = 4

	for x in range(0, width):
		for z in range(0, depth):
			if abs(x - center_x) < radius and abs(z - center_z) < radius:
				continue
			var n = noise.get_noise_2d(x, z)
			if n > 0.01:
				var voxel = structures.keys()[0].instantiate()
				voxel.scale = Vector3(1, n + 1, 1)
				voxel.position = Vector3(x, (n + 1) / 2, z)
				add_child(voxel)

			if randf() < 0.01:
				var item = items.keys()[randi() % items.size()].instantiate()
				var item_position = Vector3(x, 0.5, z)
				if n > 0.01:
					item_position.y = (n + 1) / 2 + 0.5
				item.position = item_position
				add_child(item)

func _on_mercenary_dropped(item):
	item.reparent(self)
