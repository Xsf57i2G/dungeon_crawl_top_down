class_name Chest
extends Item

var items = {
	preload("res://item/bomb.tscn"): 0.1,
	preload("res://item/boots.tscn"): 0.1,
	preload("res://item/potion.tscn"): 0.1,
	preload("res://item/coin.tscn"): 0.1,
	preload("res://item/gem.tscn"): 0.1,
	preload("res://item/diamond.tscn"): 0.1,
}

func open():
	$AnimationPlayer.play("Open")

	var item = items.keys()[randi() % items.size()].instantiate()

	get_parent().add_child(item)
	item.position = position + Vector3.UP

	if item is Bomb:
		item.explode()

	queue_free()

func unlock():
	open()
