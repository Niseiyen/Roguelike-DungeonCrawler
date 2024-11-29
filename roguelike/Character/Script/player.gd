extends CharacterBody2D

@export var speed: float = 200.0
var current_weapon: Node
var weapon_holder: Node 

# Chargé lorsque la scène est prête
func _ready() -> void:
	weapon_holder = $WeaponHolder
	assert(weapon_holder != null, "WeaponHolder node is missing!")

	if weapon_holder.get_child_count() > 0:
		current_weapon = weapon_holder.get_child(0)

# Obtenir l'input de déplacement
func _get_input() -> Vector2:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_bottom") - Input.get_action_strength("move_top")
	return input_vector.normalized()

# Mise à jour physique
func _physics_process(delta: float) -> void:
	# Déplacement
	velocity = _get_input() * speed
	move_and_slide()

	# Gestion de la rotation de l'arme
	if current_weapon:
		var mouse_position = get_global_mouse_position()
		var angle_to_mouse = (mouse_position - global_position).angle()
		current_weapon.rotation = angle_to_mouse

	# Gestion du tir
	if Input.is_action_pressed("shoot") and current_weapon:
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - global_position).normalized()
		current_weapon.shoot(global_position, direction)
		

# Équiper une arme
func equip_weapon(weapon_scene: PackedScene):
	if current_weapon:
		current_weapon.queue_free() 
	current_weapon = weapon_scene.instance()
	add_child(current_weapon)
	current_weapon.position = Vector2.ZERO  
