extends CanvasLayer

var spawns = [
	{ "x": -5, "y": 2, "rot": -90},
	{ "x": -5, "y": 3, "rot": -90},
	{ "x": -5, "y": 4, "rot": -90},
	
	{ "x": 23, "y": 9, "rot": 90},
	{ "x": 23, "y": 10, "rot": 90},
	{ "x": 23, "y": 11, "rot": 90},
]

var ai_car_scene = preload("res://mini-games/car/ai-car.tscn")

func _on_button_start_game_pressed():
	Global.fire_start_level(0)


func _on_timer_timeout():
	var spawn = spawns[randi() % spawns.size()]
	var ai_car = ai_car_scene.instantiate()
	ai_car.position = Vector2(spawn.x * 64, spawn.y * 64)
	ai_car.rotation_degrees = spawn.rot
	ai_car.z_index = -1
	%car_container.add_child(ai_car)
	
	var bound = 100 * 64
	for node in %car_container.get_children():
		if node.position.x > bound || node.position.y < -bound:
			node.queue_free()

