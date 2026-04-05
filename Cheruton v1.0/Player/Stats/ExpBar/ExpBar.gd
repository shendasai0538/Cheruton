extends Control

var old_level

@onready var exp_bar = $ExpRect/ExpStats/ExpBar

func _ready():
	var _conn1 = DataResource.connect("update_exp", Callable(self, "update_expbar"))
	var _conn2 = SceneControl.connect("init_statbar", Callable(self, "init_bar"))



func init_bar() -> void:
	var old_exp = DataResource.temp_dict_player.exp_curr
	var old_exp_max = DataResource.temp_dict_player.exp_max
	old_level = DataResource.temp_dict_player.level
	if(old_exp_max != 0):
		exp_bar.value = old_exp/old_exp_max * 100

func update_expbar(new_exp, new_exp_max, new_level) -> void:

	while(old_level < new_level):
		animate_expbar(exp_bar.value, 100)
		await get_tree().create_timer(0.2).timeout
		exp_bar.value = 0
		old_level+= 1

	animate_expbar(exp_bar.value, new_exp/new_exp_max * 100)

func animate_expbar(start, end) -> void:
	var tween = create_tween()
	tween.tween_property(exp_bar, "value", end, 0.2).from(start).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

