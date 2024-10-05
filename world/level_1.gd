@tool
extends Node3D

var noise = FastNoiseLite.new()
var width = 64
var depth = 64
var structures = {
	preload("res://world/dirt.tscn"): 0.9,
	preload("res://world/ladder.tscn"): 0.1,
	preload("res://world/spikes.tscn"): 0.01,
	preload("res://world/stalactite.tscn"): 0.01,
	preload("res://world/stone.tscn"): 0.9,
}
var items = {
	preload("res://item/bomb.tscn"): 0.1,
	preload("res://item/chest.tscn"): 0.1,
	preload("res://item/key.tscn"): 0.1,
	preload("res://item/potion.tscn"): 0.1,
	preload("res://item/torch.tscn"): 0.1,
	preload("res://item/gem.tscn"): 0.1,
	preload("res://item/diamond.tscn"): 0.1,
}

func _ready():
	noise.seed = randi()
	noise.frequency = 0.1

	generate()

func generate():
	var center_x = width / 2.0
	var center_z = depth / 2.0
	var spawn_radius = 4

	for x in width:
		for z in depth:
			var n = noise.get_noise_2d(x, z)

			var stone = preload("res://world/stone.tscn").instantiate()
			stone.position = Vector3(x, -0.5, z)
			add_child(stone)

			if abs(x - center_x) < spawn_radius and abs(z - center_z) < spawn_radius:
				continue

			if n > 0.01:
				for structure in structures.keys():
					var spawn_rate = structures[structure]
					if randf() < spawn_rate:
						var voxel = structure.instantiate()
						voxel.scale = Vector3(1, n + 1, 1)
						voxel.position = Vector3(x, (n + 1) / 2, z)
						add_child(voxel)
						break

			if randf() < 0.01:
				for item in items.keys():
					var spawn_rate = items[item]
					if randf() < spawn_rate:
						var item_instance = item.instantiate()
						item_instance.position = Vector3(x, n + 1, z)
						add_child(item_instance)
						break

func _on_mercenary_dropped(item):
	item.reparent(self)
