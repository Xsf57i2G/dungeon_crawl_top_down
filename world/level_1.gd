extends Node3D

var noise = FastNoiseLite.new()
var width = 64
var depth = 64
var structures = {
	preload("res://world/ladder.tscn"): 1.0, # Always spawn
	preload("res://world/voxel.tscn"): 1.0, # Always spawn
	preload("res://world/stalactite.tscn"): 0.001 # Rarely spawn
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

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		for body in $Mercenary/Torso/Inventory.get_overlapping_bodies():
			if body is Ladder:
				decent()

func generate():
	var l = structures.keys()[0].instantiate()
	var w = randi_range(-width, width)
	var d = randi_range(-depth, depth)
	add_child(l)
	l.position = Vector3(w, 0, d)

	var voxel_positions = {}

	for x in range(-width, width):
		for z in range(-depth, depth):
			var n = noise.get_noise_2d(x, z)
			if n > 0.05:
				if abs(x) < 6 and abs(z) < 6:
					continue
				var v = structures.keys()[1].instantiate()
				v.scale = Vector3(1, n + 1, 1)
				v.position = Vector3(x, (n + 1) / 2, z)
				$NavigationRegion3D.add_child(v)
				voxel_positions[Vector3(x, 0, z)] = v.position.y

	for x in range(-width, width):
		for z in range(-depth, depth):
			if randf() < 0.01:
				for m in monsters.keys():
					if randf() < monsters[m]:
						spawn(m, Vector3(x, 1, z))
			for item_scene in items.keys():
				if randf() < items[item_scene]:
					var i = item_scene.instantiate()
					var item_position = Vector3(x, 0.5, z)
					if Vector3(x, 0, z) in voxel_positions:
						item_position.y = voxel_positions[Vector3(x, 0, z)] + 0.5
					i.position = item_position
					$NavigationRegion3D.add_child(i)
			if randf() < structures[structures.keys()[2]]:
				var s = structures.keys()[2].instantiate()
				var stalactite_position = Vector3(x, 3, z)
				s.position = stalactite_position
				add_child(s)

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
