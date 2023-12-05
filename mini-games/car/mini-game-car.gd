extends Node

var crashed = false

var time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("vehicle_hit", Callable(self, "_vehicle_hit"))

func _process(delta):
	%car.reset_inputs()
	if crashed:
		return
	
	%car.press_forward()
	
	#if Input.is_action_pressed("forward"):
	#	%car.press_forward()
	#elif Input.is_action_pressed("back"):
	#	%car.press_backward()

	if Input.is_action_pressed("left") && !Input.is_action_pressed("right"):
		%car.press_left()
	elif !Input.is_action_pressed("left") && Input.is_action_pressed("right"):
		%car.press_right()

func load_map(map_name: String):
	var map_path = "res://maps/%s.tscn" % map_name;
	
	print("Loading map from %s" % map_path)
	
	var map_scene = load(map_path)
	var map = map_scene.instantiate()
	
	if map.has_method("move_to_spawn_point"):
		map.move_to_spawn_point(%car)
	
	%map_container.add_child(map)

func _vehicle_hit(speed: float):
	crashed = true
	Global.fire_game_over(Global.GameOverResult.FAIL)

func _on_timer_timeout():
	time += 0.1
