extends Area2D
class_name Bullet

@export var stats: BulletStats

@onready var explosion_particle: GPUParticles2D = $ExplosionParticle
@onready var explosion_sound: AudioStreamPlayer2D = $ExplosionSound  
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var trails: GPUParticles2D = $Trails

var direction: Vector2 = Vector2.ZERO
var time_alive: float = 0.0
var exploded: bool = false 
var damage: float 

func initialize(position: Vector2, direction: Vector2, weapon_damage: float):
	global_position = position
	self.direction = direction.normalized()
	damage = weapon_damage

func _process(delta: float):
	if not exploded: 
		global_position += direction * stats.speed * delta

	time_alive += delta
	if time_alive >= stats.lifetime:
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

	if explosion_particle:
		explosion_particle.emitting = true

	set_physics_process(false) 
	animated_sprite_2d.visible = false
	trails.emitting = false

	await get_tree().create_timer(0.5).timeout
	queue_free()
