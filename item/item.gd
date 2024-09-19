class_name Item
extends RigidBody3D

var held = false
var hp = 3

func _physics_process(delta):
	if not held:
		rotate_object_local(Vector3.UP, delta)
