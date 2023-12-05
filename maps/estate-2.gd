extends Node2D

func move_to_spawn_point(body: RigidBody2D):
	body.position = Vector2(-20.5 * 64, 6.5 * 64)
	body.rotation_degrees = 90 
