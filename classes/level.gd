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
	level_2.time = 10
	
	var level_3 = Level.new()
	level_3.name = "Motorway 1"
	level_3.game_type = GAME_TYPE.CAR
	level_3.map_name = "motorway-1"
	level_3.time = 10
	
	var level_4 = Level.new()
	level_4.name = "Estate 3"
	level_4.game_type = GAME_TYPE.CAR
	level_4.map_name = "estate-3"
	level_4.time = 5
	
	var level_5 = Level.new()
	level_5.name = "Motorway 2"
	level_5.game_type = GAME_TYPE.CAR
	level_5.map_name = "motorway-2"
	level_5.time = 10
	
	var level_6 = Level.new()
	level_6.name = "Estate 4"
	level_6.game_type = GAME_TYPE.CAR
	level_6.map_name = "estate-4"
	level_6.time = 10
	
	var level_7 = Level.new()
	level_7.name = "Estate 5"
	level_7.game_type = GAME_TYPE.CAR
	level_7.map_name = "estate-5"
	level_7.time = 10
	
	var level_8 = Level.new()
	level_8.name = "Motorway 3"
	level_8.game_type = GAME_TYPE.CAR
	level_8.map_name = "motorway-3"
	level_8.time = 30
	
	var level_9 = Level.new()
	level_9.name = "Estate 6"
	level_9.game_type = GAME_TYPE.CAR
	level_9.map_name = "estate-6"
	level_9.time = 20
	
	var level_10 = Level.new()
	level_10.name = "Motorway 4"
	level_10.game_type = GAME_TYPE.CAR
	level_10.map_name = "motorway-4"
	level_10.time = 20
	
	return [level_1, level_2, level_3, level_4, level_5, level_6, level_7, level_8, level_9, level_10]
