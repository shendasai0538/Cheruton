extends CharacterBody2D

func handle_collision(collider_info, collider):
	owner.handle_collision(collider_info, collider)
