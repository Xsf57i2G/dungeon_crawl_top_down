extends Node3D

var astar = AStar3D.new()
var noise = FastNoiseLite.new()
var width = 32
var depth = 32
var structures = {
	preload("res://world/brittle_voxel.tscn"): 1.0,
	preload("res://world/voxel.tscn"): 1.0,
	preload("res://world/spikes.tscn"): 1.0,
	preload("res://world/ladder.tscn"): 1.0,
	preload("res://world/stalactite.tscn"): 1.0,
}
var items = {
	preload("res://item/bomb.tscn"): 0.001,
	preload("res://item/key.tscn"): 0.0001,
	preload("res://item/chest.tscn"): 0.0001,
	preload("res://item/torch.tscn"): 0.005,
	preload("res://item/potion.tscn"): 0.001,
	preload("res://item/skull.tscn"): 0.001,
}
var monsters = {
}
var allies = {
	preload("res://character/babe.tscn"): 1.0,
}

var babe_spawned = false

func _ready():
	noise.seed = randi()
	noise.frequency = 0.1

	generate()

func generate():
	for x in range(-width, width):
		for z in range(-depth, depth):
			var n = noise.get_noise_2d(x, z)
			if n > 0.01 and (abs(x) >= 4 or abs(z) >= 4):
				var voxel = structures.keys()[0].instantiate()
				voxel.scale = Vector3(1, n + 1, 1)
				voxel.position = Vector3(x, (n + 1) / 2, z)
				add_child(voxel)
	for x in range(-width, width):
		for z in range(-depth, depth):
			if not babe_spawned and randf() < 0.01:
				var babe = allies.keys()[0].instantiate()
				babe.position = Vector3(x, 0, z)
				add_child(babe)
				babe_spawned = true
	for x in range(-width, width):
		for z in range(-depth, depth):
			if randf() < 0.01:
				var spike = structures.keys()[2].instantiate()
				spike.position = Vector3(x, -1, z)
				add_child(spike)
	for x in range(-width, width):
		for z in range(-depth, depth):
			if randf() < 0.01:
				var stalactite = structures.keys()[4].instantiate()
				stalactite.position = Vector3(x, 0.5, z)
				add_child(stalactite)
	for x in range(-width, width):
		for z in range(-depth, depth):
			if randf() < 0.01:
				var item = items.keys()[randi() % items.size()].instantiate()
				item.position = Vector3(x, 0.5, z)
				add_child(item)

func _on_mercenary_dropped(item):
	item.reparent(self)
