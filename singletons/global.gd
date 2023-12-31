extends Node2D

signal vehicle_hit(speed: float)

signal game_over(game_over_result: GameOverResult)

signal next_level()

signal restart_level()

signal start_level(level_index: int)

signal destination_hit()

signal show_title_screen()

enum GameOverResult {
	SUCCESS,
	FAIL,
	TIMEOUT
}

func fire_vehicle_hit(speed: float):
	emit_signal("vehicle_hit", speed)

func fire_game_over(game_over_state: GameOverResult):
	emit_signal("game_over", game_over_state)

func fire_next_level():
	emit_signal("next_level")
	
func fire_restart_level():
	emit_signal("restart_level")
	
func fire_start_level(level_index: int):
	emit_signal("start_level", level_index)

func fire_timer():
	pass

func fire_update_timer_text(text: String):
	emit_signal("update_timer_text", text)

func fire_destination_hit():
	emit_signal("destination_hit")

func fire_show_title_screen():
	emit_signal("show_title_screen")
