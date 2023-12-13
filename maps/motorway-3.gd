extends Node2D

func move_to_spawn_point(body: RigidBody2D):
	body.position = Vector2(-28.5 * 64, 9.0 * 64)
	body.rotation_degrees = -90
