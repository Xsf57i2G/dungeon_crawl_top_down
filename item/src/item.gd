class_name Item
extends RigidBody3D

@export var spin = false

var hp = 3

func _physics_process(delta):
	if get_parent().name == "Hand" or get_parent().name == "Back":
		global_transform = get_parent().global_transform
	else:
		if spin:
			rotate_object_local(Vector3.UP, delta)
