extends Sprite2D


# Only when sprite is loaded currently
func _ready():
	material.set_shader_parameter("sprite_scale", scale)
