extends Node

const ROOM_1 = preload("res://Scenes/room_1.tscn")

var min_number_rooms = 6
var max_number_of_rooms = 10

var generation_chance = 20

func generate(room_seed):
	seed(room_seed)
	var dungeon = {}
	var size = floor(randf_range(min_number_rooms, max_number_of_rooms))
	
	dungeon[Vector2(0,0)] = ROOM_1.instatance()
	size -= 1
	
	while(size > 0):
		for i in dungeon.keys():
			if(randf_range(0,100) < generation_chance):
				var direction = randf_range(0.,4)
				if(direction < 1):
					pass
				elif(direction < 2):
					pass
				elif(direction < 3):
					pass
				elif(direction < 4):
					pass
				
