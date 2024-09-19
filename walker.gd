class_name Walker
extends Node3D

var path = []
var visited = {}
var directions = [
	Vector3.BACK,
	Vector3.LEFT,
	Vector3.RIGHT,
	Vector3.FORWARD,
]

func walk(steps) -> Array:
	visited[Vector3.ZERO] = true
	path.push_back(Vector3.ZERO)

	for i in range(steps):
		var next = path[path.size() - 1] + directions[randi() % directions.size()]
		if visited.has(next):
			continue
		visited[next] = true
		path.push_back(next)

	return path