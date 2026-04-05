extends Area2D

func pend_interact():
	$Sprite2D.material.set_shader_parameter("width", .5)

func unpend_interact():
	$Sprite2D.material.set_shader_parameter("width", 0)

func interact():
	SceneControl.change_and_start_dialog(name)

