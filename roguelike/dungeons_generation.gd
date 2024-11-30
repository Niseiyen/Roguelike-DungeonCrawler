extends Node 

const ROOM_1 = preload("res://Scenes/room_1.tscn")

@export var min_number_rooms = 6
@export var max_number_of_rooms = 10
@export var generation_chance = 20
@export var room_size = Vector2(200, 200) 

func _ready():
	#var room_seed = randi() % 9999999999
	var dungeon = generate(111)
	setup_dungeon(dungeon)
	check_and_adjust_walls(dungeon)  # Vérifie les murs après génération

func generate(room_seed):
	seed(room_seed)
	var dungeon = {}
	var size = floor(randi_range(min_number_rooms, max_number_of_rooms))
	
	dungeon[Vector2(0, 0)] = ROOM_1.instantiate()
	#print("Salle initiale générée à la position : ", Vector2(0, 0))
	size -= 1
	
	while size > 0:
		for i in dungeon.keys():
			if randi_range(0, 100) < generation_chance and size > 0:
				var new_room_position = i
				if randi_range(0, 4) < 1:
					new_room_position += Vector2(1, 0)  # Droite
				elif randi_range(0, 4) < 2:
					new_room_position += Vector2(-1, 0)  # Gauche
				elif randi_range(0, 4) < 3:
					new_room_position += Vector2(0, 1)  # Bas
				else:
					new_room_position += Vector2(0, -1)  # Haut

				# Vérifiez si une salle existe déjà à cette position
				if !dungeon.has(new_room_position):
					dungeon[new_room_position] = ROOM_1.instantiate()
					#print("Salle ajoutée à la position : ", new_room_position)
					size -= 1
				else:
					print("Position déjà occupée : ", new_room_position)
	return dungeon


func setup_dungeon(dungeon):
	for position in dungeon.keys():
		var room_instance = dungeon[position]
		add_child(room_instance)
		room_instance.position = position * room_size

func check_and_adjust_walls(dungeon):
	for position in dungeon.keys():
		#print("Salle en cours de vérification à la position : ", position)
		var room = dungeon[position]
		var tilemap = room.get_node("TileMap")  # Récupère le TileMap de la salle
		
		# Vérifie chaque direction
		for direction in [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]:
			var adjacent_position = position + direction
			if dungeon.has(adjacent_position):  # Si une salle existe dans cette direction
				#print("Salle adjacente trouvée à la position : ", adjacent_position, " (direction : ", direction, ")")
				adjust_wall_visibility(room, direction)  # Désactive le mur dans la salle actuelle
			else:
				#print("Aucune salle adjacente à la position : ", adjacent_position, " (direction : ", direction, ")")
				keep_wall_active(room, direction)  # Garde le mur actif si aucune salle n'est présente

func adjust_wall_visibility(room, direction):
	#print("Désactivation du mur dans la direction : ", direction)
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

func keep_wall_active(room, direction):
	#print("Activation du mur dans la direction : ", direction)
	var tilemap = room.get_node("TileMap")  # Récupère le TileMap de la salle

	match direction:
		Vector2(1, 0):  
			tilemap.set_layer_enabled(4, true)
		Vector2(-1, 0):  
			tilemap.set_layer_enabled(3, true)
		Vector2(0, 1):  
			tilemap.set_layer_enabled(6, true)
		Vector2(0, -1):  
			tilemap.set_layer_enabled(5, true)
