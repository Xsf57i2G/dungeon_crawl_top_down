extends Monster

func _process(delta):
	follow()

func follow():
	var direction = target.position - position

	move(direction)
	
	move_and_slide()
