extends Monster

func _process(_delta):
	follow()

func follow():
	var direction = target.position - position

	move(direction)

	move_and_slide()
