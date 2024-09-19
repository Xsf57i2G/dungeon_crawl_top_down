@tool

class_name Thing
extends Node3D

var things := [
	"res://item/torch.tscn",
]

func _ready():
	generate()

func generate():
	var i = randi() & things.size()
	var thing = things[i]
	var t = load(thing).instantiate()

	add_child(t)
