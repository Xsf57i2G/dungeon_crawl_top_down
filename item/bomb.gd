class_name Bomb
extends Item

var explosion = preload("res://effects/explosion.tscn")

func use():
	$AnimationPlayer.play("Grow")
	$Timer.start()

func explode():
	top_level = true
	add_child(explosion.instantiate())

func _on_timer_timeout():
	explode()

func _on_body_entered(body):
	if body is Character:
		$AnimationPlayer.play("Grow")
		$Timer.start()
