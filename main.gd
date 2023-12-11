extends Node2D

var levels = Level.levels_init()
var level_index = 0

func hide_ui():
	hide_fail_ui()
	hide_success_ui()
	%container_bottom.hide()

func show_success_ui():
	for node in get_tree().get_nodes_in_group("success_ui"):
		node.show()

func hide_success_ui():
	for node in get_tree().get_nodes_in_group("success_ui"):
		node.hide()

func show_fail_ui():
	for node in get_tree().get_nodes_in_group("failed_ui"):
		node.show()

func hide_fail_ui():
	for node in get_tree().get_nodes_in_group("failed_ui"):
		node.hide()

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_ui()
	
	Global.connect("game_over", Callable(self, "_game_over"))
	Global.connect("next_level", Callable(self, "_next_level"))
	Global.connect("restart_level", Callable(self, "_restart_level"))
	
	print("cmd: %s" % OS.get_cmdline_args())
	
	var arguments = {}
	for argument in OS.get_cmdline_args():
		# Parse valid command-line arguments into a dictionary
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]

	if arguments.level:
		# possible errors if level is not a valid integer or it's not in bounds.
		# I'm choosing not to worry about it.
		level_index = int(arguments.level) - 1
		print("Setting level to %s because of command line argument." % level_index)
	load_level(levels[level_index])

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		if get_tree().get_nodes_in_group("failed_ui")[0].visible:
			_on_button_retry_pressed()
		if get_tree().get_nodes_in_group("success_ui")[0].visible:
			_on_button_next_pressed()

func _game_over(game_over_state):
	%container_bottom.show()
	%button_next.disabled = false
	if game_over_state == Global.GameOverResult.FAIL:
		show_fail_ui()
		%button_next.disabled = true
	if game_over_state == Global.GameOverResult.SUCCESS:
		show_success_ui()

func load_level(level: Level):
	var game_scene
	if level.game_type == Level.GAME_TYPE.CAR:
		game_scene = load("res://mini-games/car/mini-game-car.tscn")
	else:
		push_error("Unknown game type: %s" % level.game_type)
	
	var game = game_scene.instantiate()
	game.load_level(level)
	
	for child in $%game_container.get_children():
		child.free()
	$"%game_container".add_child(game)

func _next_level():
	level_index += 1
	level_index %= levels.size()
	load_level(levels[level_index])
	
func _restart_level():
	load_level(levels[level_index])

func _on_button_next_pressed():
	hide_ui()
	Global.fire_next_level()

func _on_button_retry_pressed():
	hide_ui()
	Global.fire_restart_level()

func _on_button_menu_pressed():
	pass # Replace with function body.
