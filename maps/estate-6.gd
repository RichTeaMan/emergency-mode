extends Node2D

func move_to_spawn_point(body: RigidBody2D):
	body.position = Vector2(1.5 * 64, -9.5 * 64)
	body.rotation_degrees = 90
