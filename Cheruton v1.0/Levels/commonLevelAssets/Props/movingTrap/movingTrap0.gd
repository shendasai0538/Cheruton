extends Node2D

const iDLE_DURATION = 1.0

@export var cicular_path = true
@export var move_to = Vector2() # center of circle if circular path_true
@export var radius = 100.0
@export var speed = 30.0

var goal_pos = Vector2()
var switch = false
var duration

@onready var trap = $hitArea

func _ready():
	duration = move_to.length() / speed
	_on_tween_finished()

func _physics_process(delta):
	if not cicular_path:
		trap.position = trap.position.lerp(goal_pos, 0.06) # This ease in
	else:
		rotate (deg_to_rad(speed)*.1)

func _on_tween_finished():
	if not cicular_path:
		var from = move_to if switch else Vector2()
		var to = Vector2() if switch else move_to
		var tween = create_tween()
		tween.tween_property(self, "goal_pos", to, duration).from(from).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT).set_delay(iDLE_DURATION)
		tween.finished.connect(_on_tween_finished)
		switch = not switch
	else:
		trap.position = Vector2(0, -radius) # starts pointing up

