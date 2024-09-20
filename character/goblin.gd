class_name Goblin
extends Monster

func _ready():
	if target:
		pass

func _process(_delta):
	if target:
		pass

func _on_navigation_agent_3d_target_reached():
	print("Target reached")
