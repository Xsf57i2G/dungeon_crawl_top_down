class_name Character
extends CharacterBody3D

signal dropped(item)
signal died

@export var speed = 5.0
@export var damage = 1
@export var health = 3

var unconscious = false
var dead = false
var items = []

func _process(_delta):
	if dead:
		return

func hit(n):
	$Hit.play()

	health -= n
	if health <= 0:
		die()

func die():
	if dead:
		return

	dead = true

	$Death.play()

	died.emit()

func move(direction):
	if dead:
		return

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

func heal(n):
	health += n
