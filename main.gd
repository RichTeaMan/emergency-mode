extends Node2D

var levels = Level.levels_init()
var level_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	%failed_ui.hide()
	
	Global.connect("game_over", Callable(self, "_game_over"))
	Global.connect("next_level", Callable(self, "_next_level"))
	Global.connect("restart_level", Callable(self, "_restart_level"))

	load_level(levels[level_index])

func _game_over(game_over_state):
	if game_over_state == Global.GameOverResult.FAIL:
		%failed_ui.show()

func load_level(level: Level):
	var game_scene
	if level.game_type == Level.GAME_TYPE.CAR:
		game_scene = load("res://mini-games/car/mini-game-car.tscn")
	else:
		push_error("Unknown game type: %s" % level.game_type)
	
	var game = game_scene.instantiate()
	game.load_map(level.map_name)
	
	for child in $%game_container.get_children():
		child.free()
	$"%game_container".add_child(game)

func _next_level():
	level_index += 1
	level_index %= levels.size()
	load_level(levels[level_index])
	
func _restart_level():
	load_level(levels[level_index])

func _on_next_level_pressed():
	%failed_ui.hide()
	Global.fire_next_level()


func _on_restart_pressed():
	%failed_ui.hide()
	Global.fire_restart_level()
