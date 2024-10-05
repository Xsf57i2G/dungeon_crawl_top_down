extends StaticBody3D

var directions = [
	Vector3.FORWARD,
	Vector3.BACK,
	Vector3.LEFT,
	Vector3.RIGHT,
]
var direction = Vector3.ZERO

func _ready():
	direction = directions.pick_random()

func _physics_process(delta):
	position.y = 2.5
	position += direction * delta * 2

func crush(body):
	if body.has_method("hit"):
		body.hit(10)
