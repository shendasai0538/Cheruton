extends Node2D

const iDLE_DURATION = 1.0

@export var move_to = Vector2()
@export var speed = 3.0

var goal_pos = Vector2()
var switch = true
var duration : float

@onready var platform = $platformBody

func _ready():
	duration = move_to.length() / speed
	_start_tween(Vector2(), move_to)

func _physics_process(delta):
	platform.position = platform.position.lerp(goal_pos, 0.06) # This ease in

func _start_tween(from: Vector2, to: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "goal_pos", to, duration).from(from).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT).set_delay(iDLE_DURATION)
	tween.finished.connect(_on_tween_finished)

func _on_tween_finished():
	if switch:
		_start_tween(move_to, Vector2())
	else:
		_start_tween(Vector2(), move_to)
	switch = not switch
