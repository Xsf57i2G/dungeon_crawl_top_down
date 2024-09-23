class_name Ladder
extends StaticBody3D

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		for body in $Area3D.get_overlapping_bodies():
			if body is Demon:
				decent()

func decent():
		get_tree().reload_current_scene()
