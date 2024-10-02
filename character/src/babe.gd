class_name Babe
extends RigidBody3D

func pickup():
	$Babe/AnimationPlayer.play("Carry")
