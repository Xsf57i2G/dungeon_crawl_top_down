class_name Item
extends RigidBody3D

var hp = 3

func _physics_process(delta):
	rotate_object_local(Vector3.UP, delta)
