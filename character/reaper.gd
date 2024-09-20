extends Monster

func _ready():
	if target:
		follow()

func _process(_delta):
	if target:
		follow()
