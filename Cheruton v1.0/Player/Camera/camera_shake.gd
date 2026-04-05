extends Camera2D

const SHIFT_TRANS = Tween.TRANS_SINE
const SHIFT_EASE = Tween.EASE_IN_OUT
const SMOOTH_SPEED_FACTOR = .00001
enum CAMERA_STATES { DEFAULT = 0, HOOK = 1}

var LOOK_AHEAD_FACTOR  # percentage of screen to shift for looking ahead when changing directions
var SHIFT_DURATION # seconds

# SHAKE
var _duration := 0.0
var _period_in_ms := 0.0
var _amplitude := 0.0
var _timer := 0.0
var _last_shook_timer := 0.0
var _previous_x := 0.0
var _previous_y := 0.0
var _last_offset := Vector2(0, 0)
var _shakedir := Vector2( 1, 1 )

var shake_offset := Vector2()
var pan_offset := Vector2()
var target_pan_offset := Vector2()
var pan_speed := 3.0

var slowmo_target = Vector2()
var slowmo_offset = Vector2()

var facing = 0
var smoothing_speed_goal := 0.0
var camera_state = 0

@onready var prev_camera_pos = get_screen_center_position()
var _shift_tween : Tween

# processes screenshake / pan
func _process( delta ):
	if _timer != 0:
		_last_shook_timer = _last_shook_timer + delta
		while _last_shook_timer >= _period_in_ms:
			_last_shook_timer = _last_shook_timer - _period_in_ms
			var intensity = _amplitude * (1 - ((_duration - _timer) / _duration))
			# Noise calculation logic from http://jonny.morrill.me/blog/view/14
			var new_x = randf_range(-1.0, 1.0)
			var x_component = intensity * (_previous_x + (delta * (new_x - _previous_x)))
			var new_y = randf_range(-1.0, 1.0)
			var y_component = intensity * (_previous_y + (delta * (new_y - _previous_y)))
			_previous_x = new_x
			_previous_y = new_y
			# Track how much we've moved the offset, as opposed to other effects.
			var new_offset = Vector2(x_component, y_component)
			shake_offset -= _last_offset - new_offset
			_last_offset = new_offset
		# Reset the offset when we're done shaking.
		_timer = _timer - delta
		if _timer <= 0:
			_timer = 0
			shake_offset -= _last_offset
	else:
		shake_offset = shake_offset.lerp( Vector2.ZERO, delta )
	# pan camera
	pan_offset = pan_offset.lerp( target_pan_offset, pan_speed * delta )
	if abs( pan_offset.y ) < 0.5:
		pan_offset.y = 0

	slowmo_offset =  lerp( slowmo_offset, slowmo_target, 10 * delta )

	if _timer != 0:
		if _shakedir == Vector2.ZERO:
			offset = shake_offset + pan_offset
		else:
			offset = shake_offset.length() * _shakedir + pan_offset
	else:
		offset = pan_offset
	offset += slowmo_offset

	position = position.round() # prevents half pixel movements
	# force_update_scroll() removed in Godot 4 - camera updates automatically

# CAMERA EFFECTS
func shake(duration, frequency, amplitude, shakedir = Vector2.ZERO ):
	# Initialize variables.
	_duration = duration
	_timer = duration
	_period_in_ms = 1.0 / frequency
	_amplitude = amplitude
	_previous_x = randf_range(-0.5, 0.5)
	_previous_y = randf_range(-0.5, 0.5)
	_shakedir = shakedir.normalized()
	shake_offset -= _last_offset
	_last_offset = Vector2.ZERO

func pan_camera( pan : Vector2 ) -> void:
	target_pan_offset = pan

# GAME CAMERA
func camera_process(delta):
	_check_facing()
	prev_camera_pos = get_screen_center_position()
	position_smoothing_speed = lerp(position_smoothing_speed, smoothing_speed_goal, delta * SMOOTH_SPEED_FACTOR)

# This function causes the camera to look ahead in the direction player is running
func _check_facing():
	var new_facing = sign(get_screen_center_position().x - prev_camera_pos.x)
	if new_facing != 0 && facing != new_facing:
		facing = new_facing
		var target_offset = get_viewport_rect().size.x * facing * LOOK_AHEAD_FACTOR
		if _shift_tween:
			_shift_tween.kill()
		_shift_tween = create_tween()
		_shift_tween.tween_property(self, "position:x", target_offset, SHIFT_DURATION).set_trans(SHIFT_TRANS).set_ease(SHIFT_EASE)

func _on_player_camera_command(command, arg):
	camera_state = command

	match (camera_state):
		CAMERA_STATES.DEFAULT:
			drag_left_margin = .06
			drag_right_margin = .06
			drag_top_margin = 0.4
			drag_bottom_margin = .2
			drag_vertical_enabled = not  arg
			drag_horizontal_enabled = true
			SHIFT_DURATION = 1
			smoothing_speed_goal = 1
			LOOK_AHEAD_FACTOR = .1
		CAMERA_STATES.HOOK:
			drag_vertical_enabled = true
			drag_horizontal_enabled = true
			SHIFT_DURATION = .5
			smoothing_speed_goal = 10
			LOOK_AHEAD_FACTOR = .25

func _on_player_shake(dur, freq, amp, dir):
	shake(dur, freq, amp, dir)

func _on_Chain_shake(dur, freq, amp, dir):
	shake(dur, freq, amp, dir)
