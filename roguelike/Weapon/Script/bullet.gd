extends Area2D
class_name Bullet

@export var speed: float = 400.0
var damage: float
@export var lifetime: float = 3.0
@onready var explosion_particle: GPUParticles2D = $ExplosionParticle
@onready var explosion_sound: AudioStreamPlayer2D = $ExplosionSound  # Facultatif pour le son
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var trails: GPUParticles2D = $Trails

var direction: Vector2 = Vector2.ZERO
var time_alive: float = 0.0
var exploded: bool = false  # Évite les explosions multiples

func initialize(position: Vector2, direction: Vector2, damage: float):
	global_position = position
	self.direction = direction.normalized()
	self.damage = damage

func _process(delta: float):
	if not exploded:  # Si la balle n'a pas explosé, continue de se déplacer
		global_position += direction * speed * delta

	time_alive += delta
	if time_alive >= lifetime:
		queue_free()

# Gestion de la collision avec une zone
func _on_bullet_zone_area_entered(area: Area2D):
	if area.has_method("take_damage"):
		area.take_damage(damage)
	explode()

# Gestion de la collision avec un corps
func _on_body_entered(body: Node2D) -> void:
	if body.name == "TileMap" or body.has_method("take_damage"):
		explode()

# Fonction pour déclencher une explosion
func explode():
	if exploded:
		return 
	exploded = true

	# Activer les particules
	if explosion_particle:
		explosion_particle.emitting = true

	# Désactiver la balle (facultatif)
	set_physics_process(false) 
	animated_sprite_2d.visible = false
	trails.emitting = false

	await get_tree().create_timer(0.5).timeout
	queue_free()
