extends CharacterBody2D

@export var speed: float = 200.0
var weapons: Array = []  
var current_weapon: Weapon = null  
var secondary_weapon: Weapon = null

@onready var weapon_holder: Node2D = $WeaponHolder
@onready var dust_walk: GPUParticles2D = $DustWalk
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	# Si le joueur a des armes, les ajouter dans l'inventaire
	for weapon in weapon_holder.get_children():
		if weapons.size() < 2:
			weapons.append(weapon)

	# Assure-toi qu'il y a une arme équipée
	if weapons.size() > 0:
		current_weapon = weapons[0]
		update_weapon_display()  

	# Cache la deuxième arme si elle existe
	if weapons.size() > 1:
		secondary_weapon = weapons[1]
		secondary_weapon.hide()  

# Fonction d'input de déplacement
func _get_input() -> Vector2:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_bottom") - Input.get_action_strength("move_top")
	return input_vector.normalized()

func _physics_process(delta: float) -> void:
	velocity = _get_input() * speed
	move_and_slide()

	# Vérifier si le joueur se déplace et dans quelle direction
	if velocity.length() > 0:
		# Si le joueur marche dans la direction opposée de l'arme, jouer l'animation "walkBackward"
		var angle_to_velocity = velocity.angle()
		var angle_to_weapon = current_weapon.rotation

		if abs(angle_to_velocity - angle_to_weapon) > PI / 2:
			animated_sprite_2d.play("walkBackward")
		else:
			animated_sprite_2d.play("walk")
		
		dust_walk.emitting = true
	else:
		animated_sprite_2d.play("idle")
		dust_walk.emitting = false

	# Rotation de l'arme
	if current_weapon:
		var mouse_position = get_global_mouse_position()
		var angle_to_mouse = (mouse_position - global_position).angle()
		current_weapon.rotation = angle_to_mouse

		if angle_to_mouse > PI / 2 or angle_to_mouse < -PI / 2:
			current_weapon.scale.y = -1
			animated_sprite_2d.flip_h = true
		else:
			current_weapon.scale.y = 1
			animated_sprite_2d.flip_h = false

	# Tirer avec l'arme actuelle
	if Input.is_action_pressed("shoot") and current_weapon:
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - global_position).normalized()
		current_weapon.shoot(global_position, direction)


# Fonction pour ajouter une arme à l'inventaire du joueur
func add_weapon(weapon_scene: PackedScene):
	if weapons.size() < 2:
		var new_weapon = weapon_scene.instantiate()
		weapons.append(new_weapon)
		weapon_holder.add_child(new_weapon)
		new_weapon.position = Vector2.ZERO
		
		# Si aucune arme n'est équipée, cette arme devient l'arme actuelle
		if current_weapon == null:
			current_weapon = new_weapon
			update_weapon_display()
		elif current_weapon != null:
			# Si une arme est déjà équipée, on cache l'ancienne arme et on équipe la nouvelle
			secondary_weapon = current_weapon
			current_weapon = new_weapon
			update_weapon_display()
	elif weapons.size() == 2:
		# Si le joueur a déjà 2 armes, on remplace la première
		weapons.erase(weapons[0])

		var new_weapon = weapon_scene.instantiate()
		weapons.append(new_weapon)
		weapon_holder.add_child(new_weapon)
		new_weapon.position = Vector2.ZERO
		
		# Remplacer l'arme actuelle par la nouvelle
		secondary_weapon = current_weapon
		current_weapon = new_weapon
		update_weapon_display()

# Permet de basculer entre les armes avec le bouton M
func _input(event):
	if event.is_action_pressed("switch_weapon"):
		if weapons.size() > 1:
			if current_weapon == weapons[0]:
				current_weapon = weapons[1]
				secondary_weapon = weapons[0]
			else:
				current_weapon = weapons[0]
				secondary_weapon = weapons[1]
				
			update_weapon_display()
		
# Fonction pour mettre à jour l'affichage de l'arme équipée
func update_weapon_display():
	if current_weapon:
		current_weapon.show()
		if secondary_weapon:
			secondary_weapon.hide()  
		print("Arme équipée : %s" % current_weapon.name)
	
	if current_weapon:
		Gamemanager.update_sprite_current_weapon(current_weapon.stats.texture)
		Gamemanager.update_max_ammo(current_weapon.stats.max_ammo)
		Gamemanager.update_max_ammo_magazin(current_weapon.stats.ammo_per_magazine)
		Gamemanager.update_current_magazine(current_weapon.current_magazine)
