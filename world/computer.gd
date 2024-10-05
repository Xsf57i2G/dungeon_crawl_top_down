class_name PC
extends Fixture

@onready var animation_player = $AnimationPlayer
@onready var camera = $Camera3D

var in_range = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if Input.is_action_just_pressed("Interact") and in_range:
		camera.current = not camera.current
		get_tree().paused = not get_tree().paused

func boot(_body):
	in_range = true
	animation_player.play("Boot")

func shutdown(_body):
	in_range = false
	animation_player.play("Shutdown")
