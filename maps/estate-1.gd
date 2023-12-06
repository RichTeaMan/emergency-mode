extends Node2D

func move_to_spawn_point(body: RigidBody2D):
	body.position = Vector2(0.5 * 64, -2.5 * 64)
	body.rotation_degrees = 0
