class_name Level

enum GAME_TYPE { CAR }

var name: String
var game_type: GAME_TYPE
## Name of the map. This should not include the tscn extension or directory path.
var map_name: String
## The time duration of the level in seconds. Fractions of seconds are valid.
var time: float

static func levels_init() -> Array[Level]:
	var level_1 = Level.new()
	level_1.name = "Estate 1"
	level_1.game_type = GAME_TYPE.CAR
	level_1.map_name = "estate-1"
	level_1.time = 5

	var level_2 = Level.new()
	level_2.name = "Estate 2"
	level_2.game_type = GAME_TYPE.CAR
	level_2.map_name = "estate-2"
	level_2.time = 5
	
	var level_3 = Level.new()
	level_3.name = "Motorway 1"
	level_3.game_type = GAME_TYPE.CAR
	level_3.map_name = "motorway-1"
	level_3.time = 10

	return [level_1, level_2, level_3]
