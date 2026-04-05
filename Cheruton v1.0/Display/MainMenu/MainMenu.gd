extends Node2D

const SCN1 = "res://Levels/Grasslands0/Grasslands0.tscn"
const EXPBAR = "HudLayer/Hud/StatBars/ExpBar"
const HEALTHBAR = "HudLayer/Hud/StatBars/HealthBar"

@onready var main_menu = self
@onready var options = $Bg/Options
@onready var slider = $Bg/Options/Slider
@onready var canvas_modulate = $CanvasModulate
@onready var general_player = $Bg/Cheruton/Player
@onready var bg_player = $Bg/BgPlayer
@onready var options_delay = $OptionsDelay
@onready var cheruton_delay = $CherutonDelay
@onready var cheruton = $Bg/Cheruton

@onready var container = $Bg/Options/VBoxContainer

@onready var play_position = $Bg/Options/VBoxContainer/Play.position
@onready var settings_position = $Bg/Options/VBoxContainer/Settings.position
@onready var quit_position = $Bg/Options/VBoxContainer/Quit.position

var modulate_dec = "white"
var sliderisActive := false
var slider_enabled := false


func _ready():
	cheruton.modulate.a = 0
	options.modulate.a = 0

	get_tree().get_root().call_deferred("move_child",main_menu, 1)
	bg_player.play("water")
	SceneControl.settings_layer.get_node("Settings").connect("closed_settings", Callable(self, "back_to_mmenu"))
	SceneControl.get_node("popUpGui").enabled = false
	tween_white_screen()
	slider_enabled = true


# Gives a fadein effect
func tween_white_screen():
	var tween = create_tween()
	tween.tween_property(canvas_modulate, "color", Color(1,1,1,1), .65).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(_on_canvas_tween_completed)

# When the tween of the relevant object is completed — now triggered via signal in each tween call
func _on_canvas_tween_completed():
	cheruton_delay.start()

func _on_cheruton_tween_completed():
	options_delay.start()

func _on_options_tween_completed():
	enable_options()


func _on_CherutonDelay_timeout():
	var tween = create_tween()
	tween.tween_property(cheruton, "modulate", Color(1,1,1,1), 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(_on_cheruton_tween_completed)


func _on_OptionsDelay_timeout():
	var tween = create_tween()
	tween.tween_property(options, "modulate", Color(1,1,1,1), 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(_on_options_tween_completed)

#Enables the Buttons for use
func enable_options():
	for i in container.get_child_count():
		container.get_child(i).disabled = false


func _on_Play_pressed():
	SceneControl.button_click.play()
	general_player.play("button_pressed")

func _on_Settings_pressed():
	SceneControl.button_click.play()
	general_player.play("button_pressed")

func _on_Quit_pressed():
	SceneControl.button_click.play()
	general_player.play("button_pressed")


func _on_Player_animation_finished(anim_name):
	if(anim_name == "to_settings"):
		SceneControl.settings_layer.show()
	elif(anim_name == "to_mmenu"):
		container.show()
	elif(anim_name == "button_pressed"):
		perform_button_action()



func perform_button_action():
	var btn_pos = slider.position - container.position
	match btn_pos:
		play_position:
			slider_enabled = false
			SceneControl.change_scene_to_file(self, SCN1)

		settings_position:
			hide_options()
			general_player.play("to_settings")
		quit_position:
			get_tree().quit()


func hide_options():
	sliderisActive = false
	slider.hide()
	container.hide()

func back_to_mmenu():
	general_player.play("to_mmenu")



func _on_Play_mouse_entered():
	var new_position = Vector2(slider.position.x, play_position.y)
	slide_to_position(new_position)

func _on_Settings_mouse_entered():
	var new_position = Vector2(slider.position.x, settings_position.y)
	slide_to_position(new_position)

func _on_Quit_mouse_entered():
	var new_position = Vector2(slider.position.x, quit_position.y)
	slide_to_position(new_position)

# Slides the slider to the intended position, or shows it there if not visible
func slide_to_position(new_position):
	# Offset of position
	if(slider_enabled):
		new_position.y += container.position.y
		var old_position = slider.position
		if(sliderisActive):
			var tween = create_tween()
			tween.tween_property(slider, "position", new_position, 0.075).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		else:
			slider.position.y = new_position.y
			slider.show()
			sliderisActive = true

