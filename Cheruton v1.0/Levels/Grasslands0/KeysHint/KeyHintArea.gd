extends Area2D

var perm_hide = false: set = set_perm_hide

var _tween : Tween

func _ready():
	modulate.a = 0

func set_perm_hide(val):
	perm_hide = val

	if val == true:
		_on_Scene0_0_body_exited(null)
		disconnect("body_entered", Callable(self, "_on_Scene0_0_body_entered"))
		disconnect("body_exited", Callable(self, "_on_Scene0_0_body_exited"))

func _on_Scene0_0_body_entered(body):
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

func _on_Scene0_0_body_exited(body):
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
