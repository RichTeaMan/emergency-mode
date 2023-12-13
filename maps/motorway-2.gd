extends Node2D

func move_to_spawn_point(body: RigidBody2D):
	body.position = Vector2(-13.5 * 64, 14 * 64)
	body.rotation_degrees = 180
