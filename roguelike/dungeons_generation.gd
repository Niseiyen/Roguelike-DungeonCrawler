extends Node

const ROOM_1 = preload("res://Scenes/room_1.tscn")

@export var min_number_rooms = 6
@export var max_number_of_rooms = 10
@export var generation_chance = 20
@export var room_size = Vector2(200, 200) 

func _ready():
	var room_seed = randi() % 9999999999
	var dungeon = generate(room_seed)
	setup_dungeon(dungeon)

func generate(room_seed):
	seed(room_seed)
	var dungeon = {}
	var size = floor(randi_range(min_number_rooms, max_number_of_rooms))
	
	dungeon[Vector2(0, 0)] = ROOM_1.instantiate()
	size -= 1
	
	while size > 0:
		for i in dungeon.keys():
			if randi_range(0, 100) < generation_chance and size > 0:
				var new_room_position = i
				if randi_range(0, 4) < 1:
					new_room_position += Vector2(1, 0) # Droite
				elif randi_range(0, 4) < 2:
					new_room_position += Vector2(-1, 0) # Gauche
				elif randi_range(0, 4) < 3:
					new_room_position += Vector2(0, 1) # Bas
				else:
					new_room_position += Vector2(0, -1) # Haut

				# Vérifiez si une salle existe déjà à cette position
				if !dungeon.has(new_room_position):
					dungeon[new_room_position] = ROOM_1.instantiate()
					size -= 1
					connect_rooms(dungeon[i], dungeon[new_room_position], new_room_position - i)
	return dungeon

func connect_rooms(room1, room2, direction):
	room1.connected_rooms[direction] = room2
	room2.connected_rooms[-direction] = room1
	room1.number_of_connections += 1
	room2.number_of_connections += 1

	# Désactive les murs selon la direction
	adjust_wall_visibility(room1, direction)
	adjust_wall_visibility(room2, -direction)

# Ajuste la visibilité des murs en fonction de la direction
func adjust_wall_visibility(room, direction):
	var tilemap = room.get_node("TileMap")  # Récupère le TileMap de la salle

	match direction:
		Vector2(1, 0):  # Droite
			tilemap.set_layer_enabled(4, false)
		Vector2(-1, 0):  # Gauche
			tilemap.set_layer_enabled(3, false)
		Vector2(0, 1):  # Bas
			tilemap.set_layer_enabled(6, false)
		Vector2(0, -1):  # Haut
			tilemap.set_layer_enabled(5, false)

	# Si aucune salle adjacente n'existe dans une direction, garde le mur visible
	if !room.connected_rooms.has(direction):
		tilemap.set_layer_visible(get_wall_layer_for_direction(direction), true)

# Fonction qui retourne le nom du layer du mur en fonction de la direction
func get_wall_layer_for_direction(direction):
	match direction:
		Vector2(1, 0): return "Door_right"
		Vector2(-1, 0): return "Door_left"
		Vector2(0, 1): return "Door_Bottom"
		Vector2(0, -1): return "Door_top"

func setup_dungeon(dungeon):
	for position in dungeon.keys():
		var room_instance = dungeon[position]
		add_child(room_instance)
		room_instance.position = position * room_size
