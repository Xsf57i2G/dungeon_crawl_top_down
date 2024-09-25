extends StaticBody3D

var damage = 10
var fell = false

func fall():
	if not fell:
		$AnimationPlayer.play("Fall")
		fell = true

func _on_area_3d_body_entered(_body):
	fall()

func _on_animation_player_animation_finished(_anim_name):
	if fell:
		for b in $Area3D.get_overlapping_bodies():
			if b.has_method("hit"):
				b.hit(damage)
