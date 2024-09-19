extends Label

var time = 0.0

func _process(delta: float):
	time += delta
	text = str(round(time))
