class_name Voxel
extends StaticBody3D

var health := 3
var items := {
	preload("res://item/gem.tscn"): 0.01,
}

func _ready():
	for item in items:
		if randf() < items[item]:
			var i = item.instantiate()
			add_child(i)

func hit(n: int):
	$AnimationPlayer.play("Hit")

	health -= n
	if health <= 0:
		destroy()

func destroy():
	for item in items:
		if randf() < items[item]:
			var i = item.instantiate()
			drop(i)

func drop(item: Item):
	get_parent().add_child(item)
	item.translate(position)

func _on_animation_player_animation_finished(_anim_name: StringName):
	queue_free()
