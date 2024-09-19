extends Node3D

@export var noise = FastNoiseLite.new()

var width = 64
var depth = 64
var ladder = preload("res://world/ladder.tscn")
var voxel = preload("res://world/voxel.tscn")
var items = {
	preload("res://item/bomb.tscn"): 0.001,
	preload("res://item/key.tscn"): 0.0005,
	preload("res://item/chest.tscn"): 0.0001,
	preload("res://item/torch.tscn"): 0.005,
	preload("res://item/potion.tscn"): 0.001,
}
var monsters = {
	preload("res://character/goblin.tscn"): 0.1,
	preload("res://character/zander.tscn"): 0.01,
}

func _ready():
	noise.seed = randi()
	generate()

func _process(_delta: float):
	if Input.is_action_just_pressed("interact"):
		for body in $Mercenary/Torso/Inventory.get_overlapping_bodies():
			if body is Ladder:
				decent()

func generate():
	var l = ladder.instantiate()
	var w = randi_range(-width, width)
	var d = randi_range(-depth, depth)
	add_child(l)
	l.position = Vector3(w, 0, d)

	var voxel_positions = {}

	for x in range(-width, width):
		for z in range(-depth, depth):
			var n = noise.get_noise_2d(x, z)
			if n > 0.05:
				if abs(x) < 2 and abs(z) < 2:
					continue
				var v = voxel.instantiate()
				v.scale = Vector3(1, n + 1, 1)
				v.position = Vector3(x, (n + 1) / 2, z)
				add_child(v)
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
					add_child(i)

func spawn(what: PackedScene, where: Vector3):
	var instance = what.instantiate()
	instance.position = where
	add_child(instance)

func decent():
	get_tree().reload_current_scene()

func _on_mercenary_dropped(item: Node):
	item.reparent(self)

func _on_timer_timeout():
	spawn(preload("res://character/reaper.tscn"), Vector3(0, 1, 0))
