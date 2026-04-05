extends Node2D

@onready var value = $Value
var amount = 0
var text_velocity = Vector2()

func _ready():
	value.set_text(str(abs(amount)))

	var angle = randf_range(-40, 40)
	text_velocity = Vector2(angle, -100)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.30, 0.30), 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2(0.1, 0.1), 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT).set_delay(0.3)
	tween.finished.connect(queue_free)

func _physics_process(delta):
	global_position += text_velocity * delta
