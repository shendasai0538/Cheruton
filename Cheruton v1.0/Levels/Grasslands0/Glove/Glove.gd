extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var dust = preload("res://Effects/Dust/JumpDust/jumpDust.tscn")

var interact_enabled = true

var level

func _ready():
	add_to_group("needs_level_ref", true)

func _physics_process(delta):
	velocity.x *= .978
	velocity.y += 2400 * delta

	velocity.y = clamp (velocity.y, -INF, 2400)
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()

	if is_on_floor():
		velocity.x *= .86
		var col = get_slide_collision(0)
		if col and velocity.x > 50:
			var instance = dust.instantiate()
			instance.emitting = true

			instance.global_position = col.position
			get_parent().add_child(instance)



func pend_interact():
	sprite.material.set_shader_parameter("width", .5)

func unpend_interact():
	sprite.material.set_shader_parameter("width", 0)

func interact(body):
	if not interact_enabled: return
	interact_enabled = false

	level.next_cutscene()
	DataResource.temp_dict_player.dialog_complete = true
	level.wait_dialog_complete = false

	queue_free()
