extends Node

var car_active = true

var time = 0.0
var time_target = 60.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("vehicle_hit", Callable(self, "_vehicle_hit"))
	Global.connect("destination_hit", Callable(self, "_destination_hit"))

func _process(delta):
	%car.reset_inputs()
	if !car_active:
		%timer_label.hide()
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

func load_level(level: Level):
	var map_path = "res://maps/%s.tscn" % level.map_name;
	
	print("Loading map from %s" % map_path)
	
	var map_scene = load(map_path)
	var map = map_scene.instantiate()
	
	if map.has_method("move_to_spawn_point"):
		map.move_to_spawn_point(%car)
	
	%map_container.add_child(map)
	
	time_target = level.time

func _vehicle_hit(speed: float):
	if !car_active:
		return
	car_active = false
	%timer.stop()
	Global.fire_game_over(Global.GameOverResult.FAIL)

func _destination_hit():
	if !car_active:
		return
	Global.fire_game_over(Global.GameOverResult.SUCCESS)
	car_active = false
	%timer.stop()

func _on_timer_timeout():
	if !car_active:
		return
	time += %timer.wait_time
	if time >= time_target || is_equal_approx(time, time_target):
		Global.fire_game_over(Global.GameOverResult.TIMEOUT)
		car_active = false
		%timer.stop()
	%timer_label.text = "%04.1f seconds" % (time_target - time)
