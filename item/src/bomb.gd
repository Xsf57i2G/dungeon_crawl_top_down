class_name Bomb
extends Item

var explosion = preload("res://effects/explosion.tscn")

func use():
	explode()

func explode():
	$AnimationPlayer2.play("Grow")

	await get_tree().create_timer(1.5).timeout

	add_child(explosion.instantiate())

func _on_body_entered(body):
	if body is CharacterBody3D:
		explode()
