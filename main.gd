extends Node2D

var SUCCESS_UI_GROUP = "success_ui"
var FAILED_UI_GROUP = "failed_ui"
var TIMEOUT_UI_GROUP = "timeout_ui"

var levels = Level.levels_init()
var level_index = 0

var success_sass = TextLoad.load_success_sass()
var fail_sass = TextLoad.load_fail_sass()

var sucess_sass_bag = []
var fail_sass_bag = []

func hide_ui():
	hide_fail_ui()
	hide_success_ui()
	hide_timeout_ui()
	%container_bottom.hide()

func show_success_ui():
	for node in get_tree().get_nodes_in_group(SUCCESS_UI_GROUP):
		node.show()

func hide_success_ui():
	for node in get_tree().get_nodes_in_group(SUCCESS_UI_GROUP):
		node.hide()

func show_fail_ui():
	for node in get_tree().get_nodes_in_group(FAILED_UI_GROUP):
		node.show()

func hide_fail_ui():
	for node in get_tree().get_nodes_in_group(FAILED_UI_GROUP):
		node.hide()

func show_timeout_ui():
	for node in get_tree().get_nodes_in_group(TIMEOUT_UI_GROUP):
		node.show()

func hide_timeout_ui():
	for node in get_tree().get_nodes_in_group(TIMEOUT_UI_GROUP):
		node.hide()

func next_success_sass():
	var text = sucess_sass_bag.pop_back()
	if text == null:
		sucess_sass_bag = success_sass.duplicate()
		sucess_sass_bag.shuffle()
		text = next_success_sass()
	return text

func next_fail_sass():
	var text = fail_sass_bag.pop_back()
	if text == null:
		fail_sass_bag = fail_sass.duplicate()
		fail_sass_bag.shuffle()
		text = next_fail_sass()
	return text

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_ui()
	
	Global.connect("game_over", Callable(self, "_game_over"))
	Global.connect("next_level", Callable(self, "_next_level"))
	Global.connect("restart_level", Callable(self, "_restart_level"))
	Global.connect("start_level", Callable(self, "_start_level"))
	Global.connect("show_title_screen", Callable(self, "_show_title_screen"))
	
	print("cmd: %s" % OS.get_cmdline_args())
	
	var arguments = {}
	for argument in OS.get_cmdline_args():
		# Parse valid command-line arguments into a dictionary
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]

	if "level" in arguments && arguments.level:
		# possible errors if level is not a valid integer or it's not in bounds.
		# I'm choosing not to worry about it.
		level_index = int(arguments.level) - 1
		print("Setting level to %s because of command line argument." % level_index)
		load_level(levels[level_index], false)
	
	else:
		_show_title_screen()

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		if get_tree().get_nodes_in_group(FAILED_UI_GROUP)[0].visible || get_tree().get_nodes_in_group(TIMEOUT_UI_GROUP)[0].visible:
			_on_button_retry_pressed()
		if get_tree().get_nodes_in_group(SUCCESS_UI_GROUP)[0].visible:
			_on_button_next_pressed()

func _game_over(game_over_state):
	%container_bottom.show()
	%button_next.disabled = true
	if game_over_state == Global.GameOverResult.FAIL:
		%failed_sass_text.text = next_fail_sass()
		show_fail_ui()
	if game_over_state == Global.GameOverResult.TIMEOUT:
		%timeout_sass_text.text = next_fail_sass()
		show_timeout_ui()
	if game_over_state == Global.GameOverResult.SUCCESS:
		%success_sass_text.text = next_success_sass()
		%button_next.disabled = false
		show_success_ui()

func load_level(level: Level, first_time: bool):
	BuildInfo.hide_build_info()
	var game_scene
	if level.game_type == Level.GAME_TYPE.CAR:
		game_scene = load("res://mini-games/car/mini-game-car.tscn")
	else:
		push_error("Unknown game type: %s" % level.game_type)
	
	clear_game_container()
	
	var game = game_scene.instantiate()
	$"%game_container".add_child(game)
	game.load_level(level, first_time)

func clear_game_container():
	for child in $%game_container.get_children():
		child.queue_free()

func _show_title_screen():
	clear_game_container()
	BuildInfo.show_build_info()
	var title_scene = load("res://title.tscn")
	%game_container.add_child(title_scene.instantiate())

func _next_level():
	level_index += 1
	if level_index >= levels.size():
		level_index = 0
		clear_game_container()
		var game_over_scene = load("res://game_over.tscn")
		var game_over = game_over_scene.instantiate()
		%game_container.add_child(game_over)
	else:
		load_level(levels[level_index], true)

func _restart_level():
	load_level(levels[level_index], false)

func _start_level(start_level_index: int):
	level_index = start_level_index
	load_level(levels[level_index], true)

func _on_button_next_pressed():
	hide_ui()
	Global.fire_next_level()

func _on_button_retry_pressed():
	hide_ui()
	Global.fire_restart_level()

func _on_button_menu_quit():
	get_tree().quit()
