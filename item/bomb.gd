class_name Bomb
extends Item

var explosion = preload("res://effects/explosion.tscn")

func use():
	$AnimationPlayer.play("Grow")
	$Timer.start()

func explode():
	add_child(explosion.instantiate())
	top_level = true

func _on_timer_timeout():
	explode()

func _on_body_entered(body):
	if body is Character:
		use()
