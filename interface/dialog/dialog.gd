extends MarginContainer

var text = ""
var index = 0

var letter_time = 0.05
var space_time = 0.01
var punctuation_time = 0.2

func _ready() -> void:
	$AudioStreamPlayer3D.play()

	scale.y = 0.5
