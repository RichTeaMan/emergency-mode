extends Node2D

signal vehicle_hit(speed: float)

signal game_over(game_over_result: GameOverResult)

signal next_level()

signal restart_level()

enum GameOverResult {
	SUCCESS,
	FAIL
}

func fire_vehicle_hit(speed: float):
	emit_signal("vehicle_hit", speed)

func fire_game_over(game_over_state: GameOverResult):
	emit_signal("game_over", game_over_state)

func fire_next_level():
	emit_signal("next_level")
	
func fire_restart_level():
	emit_signal("restart_level")
