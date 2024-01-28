extends Node

var car_active = true
var cutscene_playing = false

var time = 0.0
var time_target = 60.0

var destination_node: Node2D = null

var first_frame = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# something about the scene load causes the car and arrow to appear in the
	# wrong place at the first frame. this is a cheap hack to make things less
	# jarring
	%arrow.modulate.a = 0.0
	%car.visible = false
	
	Global.connect("vehicle_hit", Callable(self, "_vehicle_hit"))
	Global.connect("destination_hit", Callable(self, "_destination_hit"))

func _physics_process(_delta):
	if !first_frame && destination_node != null:
		%arrow.look_at(destination_node.global_position)
		var car_distance = %car.global_position.distance_to(destination_node.global_position)
		var car_fade_distance = 1500
		var arrow_distance = %car.global_position.distance_to(destination_node.global_position)
		var arrow_fade_distance = 300
		var car_fade = clamp(car_distance / car_fade_distance, 0.0, 1.0)
		var arrow_fade = clamp(arrow_distance / arrow_fade_distance, 0.0, 1.0)
		%arrow.modulate.a = min(car_fade, arrow_fade)
	first_frame = false

func _process(_delta):
	
	%car.visible = true
	%car.reset_inputs()
	if cutscene_playing:
		if Input.is_action_just_pressed("ui_accept"):
			cutscene_playing = false
			%cutscene_animation/MarginContainer.hide()
		return
	if !car_active:
		%timer_label.hide()
		%arrow.hide()
		return
	
	%car.press_forward()

	if Input.is_action_pressed("left") && !Input.is_action_pressed("right"):
		%car.press_left()
	elif !Input.is_action_pressed("left") && Input.is_action_pressed("right"):
		%car.press_right()

func load_level(level: Level, first_time: bool):
	var map_path = "res://maps/%s.tscn" % level.map_name;
	
	print("Loading map from %s" % map_path)
	
	var map_scene = load(map_path)
	var map = map_scene.instantiate()
	
	if map.has_method("move_to_spawn_point"):
		map.move_to_spawn_point(%car)
	
	%map_container.add_child(map)
	
	time_target = level.time
	
	# find destination node
	var destination_nodes_freed: Array[Node] = map.get_tree().get_nodes_in_group('destination')#.filter(func(node: Node): node.is_queued_for_deletion() == false)
	var destination_nodes = []
	for n in destination_nodes_freed:
		if !n.is_queued_for_deletion():
			destination_nodes.append(n)
	if destination_nodes.size() > 0:
		destination_node = destination_nodes[destination_nodes.size() - 1]
	if destination_nodes.size() != 1:
		print("Irregular number of destinations found, found %s." % destination_nodes.size())
	
	if first_time && level.name == "Estate 1":
		cutscene_playing = true
		for node in %cutscene_animation.get_children(true):
			node.show()
		%cutscene_animation.play("intro")
	else:
		%cutscene_animation/MarginContainer.hide()

func _on_cutscene_animation_animation_finished(anim_name):
	pass
	#if anim_name == "intro":
#		cutscene_awaiting_input = true

func _vehicle_hit(_speed: float):
	if first_frame || !car_active:
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
	%timer_label.text = "%04.1f seconds" % (time_target - time)
	if cutscene_playing || !car_active:
		return
	time += %timer.wait_time
	if time >= time_target || is_equal_approx(time, time_target):
		Global.fire_game_over(Global.GameOverResult.TIMEOUT)
		car_active = false
		%timer.stop()
	
