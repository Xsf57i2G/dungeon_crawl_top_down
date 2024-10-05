class_name Fixture
extends StaticBody3D

@onready var animation_player = $AnimationPlayer

func boot(_body):
	animation_player.play("Boot")

func power_off(_body):
	animation_player.play("Power Off")
