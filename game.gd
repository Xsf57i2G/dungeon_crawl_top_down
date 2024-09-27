extends Node

var score = 0
var game_over = preload("res://game_over.tscn")
var level_1 = preload("res://world/level_1.tscn")

func over():
	await get_tree().create_timer(1).timeout

	var s = game_over
	get_tree().change_scene_to_packed(s)

func _on_demon_collected(amount):
	score += amount
