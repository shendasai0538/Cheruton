extends Node2D

@onready var laser_beam = $laser_sprite_center
@onready var laser_particles = $hitParticles

@export var rotating : bool = false
@export var angular_vel_deg : float = 1.0
@export var max_dist : float = 1000.0
@export var starting_rot_deg: float = 0.0

var hit_pos : Vector2

func _ready():
	rotation_degrees = starting_rot_deg

func _physics_process(delta):
	if rotating: rotate(deg_to_rad(angular_vel_deg))

	hit_pos = global_position + transform.x * max_dist # assume it hits at max distance
	var space = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, hit_pos, 1, [get_rid()])
	query.collide_with_areas = true
	query.collide_with_bodies = true
	var col = space.intersect_ray(query) # transform.x contains the rotation reperesented by a unit vector

	if col:
		hit_pos = col.position
		var laser_length = laser_beam.global_position.distance_to(hit_pos)
		laser_beam.region_rect.size.x = laser_length

		laser_particles.show()
		laser_particles.global_position = hit_pos
	else:
		laser_particles.hide()
		laser_beam.region_rect.size.x = max_dist

	$CollisionShape2D.shape.b = Vector2(hit_pos.distance_to(global_position), 0) # uses regions to repeat the texture

