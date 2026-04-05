extends Control

@onready var healthbar_fast = $HealthBarFast
@onready var healthbar_slow = $HealthBarSlow
var max_health : float
var change_speed : float
var _tween : Tween

func init_bar(max_value : float) -> void:
	healthbar_slow.max_value = max_value
	healthbar_slow.value = max_value

	healthbar_fast.max_value = max_value
	healthbar_fast.value = max_value

	max_health = max_value

func animate_healthbar(end : float) -> void:
	if end > healthbar_fast.value: # healing
		healthbar_slow.value = end
	else:
		if _tween:
			_tween.kill()
		_tween = create_tween()
		_tween.tween_property(healthbar_slow, "value", end, 1.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

	healthbar_fast.value = end
