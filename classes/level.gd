class_name Level

enum GAME_TYPE { CAR }

var name: String
var game_type: GAME_TYPE
## Name of the map. This should not include the tscn extension or directory path.
var map_name: String
## The time duration of the level in milliseconds.
var time_ms: int

static func levels_init() -> Array[Level]:
	var level_1 = Level.new()
	level_1.name = "Estate 1"
	level_1.game_type = GAME_TYPE.CAR
	level_1.map_name = "estate-1"
	level_1.time_ms = 5000

	var level_2 = Level.new()
	level_2.name = "Estate 2"
	level_2.game_type = GAME_TYPE.CAR
	level_2.map_name = "estate-2"
	level_2.time_ms = 5000

	return [level_1, level_2]
