extends Node

# Préchargez vos différentes scènes de salles
const ROOMS = [
	preload("res://Scenes/Rooms/room_1.tscn"), 
	preload("res://Scenes/Rooms/room_2.tscn"),
	preload("res://Scenes/Rooms/room_3.tscn"),
	preload("res://Scenes/Rooms/room_4.tscn"),
	preload("res://Scenes/Rooms/room_5.tscn"),
]

# Préchargez vos différentes scènes d'ennemis
const ENEMIES = [
	preload("res://Character/Enemys/enemy_1.tscn"),
]

@export var min_number_rooms = 6
@export var max_number_of_rooms = 10
@export var generation_chance = 20
@export var room_size = Vector2(400, 400)
@export var min_enemies_per_room: int = 1
@export var max_enemies_per_room: int = 3

func _ready():
	var room_seed = randi() % 9999999999
	var dungeon = generate(room_seed)
	setup_dungeon(dungeon)
	check_and_adjust_walls(dungeon)

# Génère le donjon avec une salle centrale fixe
func generate(room_seed):
	seed(room_seed)
	var dungeon = {}
	var size = floor(randi_range(min_number_rooms, max_number_of_rooms))
	
	dungeon[Vector2(0, 0)] = generate_fixed_room(0) 
	size -= 1
	
	while size > 0:
		var current_positions = dungeon.keys()

		# Parcourt les positions actuelles pour générer des salles autour
		for position in current_positions:
			if size <= 0:
				break
			
			if randi_range(0, 100) < generation_chance:
				var new_room_position = position + get_random_direction()
				
				# Vérifie si la position est déjà utilisée
				if !dungeon.has(new_room_position):
					dungeon[new_room_position] = generate_random_room()
					size -= 1
	return dungeon

# Ajoute une fonction pour obtenir une direction aléatoire
func get_random_direction() -> Vector2:
	var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	return directions[randi() % directions.size()]

# Fonction pour générer une salle aléatoire
func generate_random_room():
	var room_index = randi() % (ROOMS.size() - 1) + 1  
	return ROOMS[room_index].instantiate()

# Fonction pour générer une salle fixe (comme room_1)
func generate_fixed_room(index):
	return ROOMS[index].instantiate()

func setup_dungeon(dungeon):
	for position in dungeon.keys():
		if has_node_at_position(position):
			continue  

		var room_instance = dungeon[position]
		add_child(room_instance)
		if room_instance is Node2D:
			room_instance.position = position * room_size
		elif room_instance is CanvasLayer:
			room_instance.offset = position * room_size

		# Spawner les ennemis dans la salle
		spawn_enemies_in_room(room_instance)
		
func has_node_at_position(position: Vector2) -> bool:
	for child in get_children():
		if child is CanvasLayer:
			return false
		elif child.position == position * room_size:
			return true
	return false

func check_and_adjust_walls(dungeon):
	for position in dungeon.keys():
		var room = dungeon[position]
		var tilemap = room.get_node("TileMap")
		
		for direction in [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]:
			var adjacent_position = position + direction
			if dungeon.has(adjacent_position):
				adjust_wall_visibility(room, direction)
			else:
				keep_wall_active(room, direction)

func adjust_wall_visibility(room, direction):
	match direction:
		Vector2(1, 0):  # Droite
			var layer = room.get_node_or_null("Door_right")
			if layer:
				layer.enabled = false
		Vector2(-1, 0):  # Gauche
			var layer = room.get_node_or_null("Door_left")
			if layer:
				layer.enabled = false
		Vector2(0, 1):  # Haut
			var layer = room.get_node_or_null("Door_Top")
			if layer:
				layer.enabled = false
		Vector2(0, -1):  # Bas
			var layer = room.get_node_or_null("Door_Bottom")
			if layer:
				layer.enabled = false

func keep_wall_active(room, direction):
	match direction:
		Vector2(1, 0):  # Droite
			var layer = room.get_node_or_null("Door_right")
			if layer:
				layer.enabled = true
		Vector2(-1, 0):  # Gauche
			var layer = room.get_node_or_null("Door_left")
			if layer:
				layer.enabled = true
		Vector2(0, 1):  # Haut
			var layer = room.get_node_or_null("Door_Top")
			if layer:
				layer.enabled = true
		Vector2(0, -1):  # Bas
			var layer = room.get_node_or_null("Door_Bottom")
			if layer:
				layer.enabled = true

# Fonction pour spawn les ennemis dans une salle
func spawn_enemies_in_room(room: Node):
	var num_enemies = randi_range(min_enemies_per_room, max_enemies_per_room)
	for i in range(num_enemies):
		var enemy_scene = ENEMIES[randi() % ENEMIES.size()]
		var enemy_instance = enemy_scene.instantiate()
		
		# Générer une position aléatoire dans la salle
		var random_position = Vector2(
			randi_range(50, room_size.x - 50),
			randi_range(50, room_size.y - 50)
		)
		
		if enemy_instance is Node2D:
			enemy_instance.position = room.position + random_position
		
		# Ajouter l'ennemi comme enfant de la salle
		room.add_child(enemy_instance)
