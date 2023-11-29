extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	%failed_text.hide()
	
	Global.connect("game_over", Callable(self, "_game_over"))
	
	var car_game_scene = load("res://mini-games/car/mini-game-car.tscn")
	var car_game = car_game_scene.instantiate()
	car_game.load_map("estate-1")
	
	$"%game_container".add_child(car_game)

func _game_over(game_over_state):
	emit_signal("game_over", game_over_state)
	if game_over_state == Global.GameOverResult.FAIL:
		%failed_text.show()
