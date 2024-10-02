extends Node3D

var noise = FastNoiseLite.new()
var width = 8
var depth = 8

var cobweb = preload("res://world/cobweb.tscn")

func _ready():
	noise.seed = randi()
	noise.frequency = 0.5

	generate()

func generate():
	for x in range(-width, width):
		for z in range(-depth, depth):
			noise.seed = randi()
			var at = Vector3(x, 0, z)
			var n = noise.get_noise_2d(x, z)
			if n > 0.01:
				var c = cobweb.instantiate()
				c.position = at
				add_child(c)
