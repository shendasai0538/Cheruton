extends Area2D
var damage = 10
var obj = self

func _on_AnimationPlayer_animation_finished(anim_name):
	var time = randf_range(3.0, 10.0)
	$Timer.start(time)

func _on_Timer_timeout():
	$AnimationPlayer.play("idle")
