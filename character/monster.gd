class_name Monster
extends Character

@onready var target = closest("Mercenary")

var astar = AStar3D.new()
var path = []
var current = 0

func _process(_delta):
	if path.size() > 0:
		var next = path[current]
		if position.distance_to(next) < 1.0:
			current += 1
			if current >= path.size():
				path = []
				current = 0
		else:
			move(next)

func closest(group):
	var characters = get_tree().get_nodes_in_group(group)
	var closest_character = null
	var closest_distance = INF

	for c in characters:
		var distance = global_position.distance_to(c.global_position)
		if distance < closest_distance:
			closest_character = c
			closest_distance = distance

	if closest_character and closest_character is Character:
		return closest_character

func traverse():
	pass

func follow():
	if target:
		var start = astar.get_closest_point(position)
		var end = astar.get_closest_point(target.position)
		path = astar.get_point_path(start, end)
		current = 0
