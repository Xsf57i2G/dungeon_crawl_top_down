class_name Bomb
extends Item

var explosion = preload("res://effects/explosion.tscn")

func use():
	$Fire.show()
	$AnimationPlayer.play("Grow")
	$Timer.start()

func explode():
	add_child(explosion.instantiate())

func _on_timer_timeout():
	explode()

func _on_body_entered(body):
	if body is Character:
		use()
