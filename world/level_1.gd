extends Node3D

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
	preload("res://item/key.tscn"): 0.001,
	preload("res://item/chest.tscn"): 0.001,
	preload("res://item/torch.tscn"): 0.005,
	preload("res://item/potion.tscn"): 0.001,
}
var monsters = {
	preload("res://character/goblin.tscn"): 0.01,
	preload("res://character/zander.tscn"): 0.01,
}

func _ready():
	noise.seed = randi()
	noise.frequency = 0.1

	generate()
	$NavigationRegion3D.bake_navigation_mesh()

func _input(event):
	if event.is_action_pressed("interact"):
		for body in $Mercenary/Torso/Inventory.get_overlapping_bodies():
			if body is Ladder:
				decent()

func generate():
	var ladder = structures.keys()[0].instantiate()
	ladder.position = Vector3(randi_range(-width, width), 0, randi_range(-depth, depth))
	add_child(ladder)

	var voxel_positions = {}

	for x in range(-width, width):
		for z in range(-depth, depth):
			var n = noise.get_noise_2d(x, z)
			if n > 0.05 and (abs(x) >= 6 or abs(z) >= 6):
				var voxel = structures.keys()[1].instantiate()
				voxel.scale = Vector3(1, n + 1, 1)
				voxel.position = Vector3(x, (n + 1) / 2, z)
				$NavigationRegion3D.add_child(voxel)
				voxel_positions[Vector3(x, 0, z)] = voxel.position.y

	for x in range(-width, width):
		for z in range(-depth, depth):
			if randf() < 0.01:
				for monster in monsters.keys():
					if randf() < monsters[monster]:
						spawn(monster, Vector3(x, 1, z))
			for item_scene in items.keys():
				if randf() < items[item_scene]:
					var item = item_scene.instantiate()
					item.position = Vector3(x, 0.5, z)
					if Vector3(x, 0, z) in voxel_positions:
						item.position.y = voxel_positions[Vector3(x, 0, z)] + 0.5
					$NavigationRegion3D.add_child(item)
			if randf() < structures[structures.keys()[2]]:
				var stalactite = structures.keys()[2].instantiate()
				stalactite.position = Vector3(x, 3, z)
				add_child(stalactite)

func spawn(what, where):
	var instance = what.instantiate()
	add_child(instance)
	instance.position = where

func decent():
	get_tree().reload_current_scene()

func _on_mercenary_dropped(item):
	item.reparent(self)

func _on_timer_timeout():
	spawn(preload("res://character/reaper.tscn"), Vector3.UP)
