extends Node3D

var angle = 0.0
var radius = 1.0
var speed = 5.0
var target_babe = null

func _process(delta):
	angle += delta
	var target = null
	if target_babe:
		target = target_babe.global_position
	else:
		for body in $Area3D.get_overlapping_bodies():
			if body is Babe:
				target = body.global_position
				break

	if target:
		var offset = Vector3(cos(angle) * radius, 2, sin(angle) * radius)
		var destination = target + offset
		global_position = global_position.lerp(destination, speed * delta)

func _on_area_3d_body_entered(body):
	if body is Babe:
		target_babe = body
		visible = true
