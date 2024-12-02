extends Node2D
class_name Weapon

@export var stats: WeaponStats
@export var scene_reference: PackedScene

var time_since_last_shot: float = 0
var current_magazine: int
var is_reloading: bool = false 

@onready var marker_2d: Marker2D = $Muzzle
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var main_camera: Camera2D = get_node("/root/MainScene/MainCamera")
@onready var muzzle_particle: GPUParticles2D = $MuzzleParticle

func _ready():
	current_magazine = stats.ammo_per_magazine
	
	Gamemanager.update_sprite_current_weapon(stats.texture)
	Gamemanager.update_max_ammo(stats.max_ammo)
	Gamemanager.update_max_ammo_magazin(stats.ammo_per_magazine)
	Gamemanager.update_current_magazine(current_magazine)


func _process(delta: float):
	time_since_last_shot += delta

	if current_magazine <= 0 and not stats.infinite_ammo and not is_reloading:
		reload()

func shoot(position: Vector2, direction: Vector2):
	if is_reloading:
		print("Le rechargement est en cours. Impossible de tirer.")
		return

	# Vérification du taux de tir
	if time_since_last_shot >= 1.0 / stats.fire_rate:
		if current_magazine > 0 or stats.infinite_ammo:
			time_since_last_shot = 0
			animation_player.play(stats.shoot_animation)

			if muzzle_particle:
				muzzle_particle.emitting = true 

			for i in range(stats.bullet_count):
				var recoil_adjusted_direction = apply_recoil(direction)
				spawn_projectile(marker_2d.global_position, recoil_adjusted_direction)

			apply_shake(stats.camera_shake_intensity)

			if not stats.infinite_ammo:
				current_magazine -= stats.bullet_count
		
			Gamemanager.update_sprite_current_weapon(stats.texture)
			Gamemanager.update_max_ammo(stats.max_ammo)
			Gamemanager.update_max_ammo_magazin(stats.ammo_per_magazine)
			Gamemanager.update_current_magazine(current_magazine)
		else:
			print("Pas assez de munitions!")

func spawn_projectile(position: Vector2, direction: Vector2):
	if stats.projectile_scene:
		var projectile = stats.projectile_scene.instantiate()
		get_tree().current_scene.add_child(projectile)
		projectile.initialize(position, direction.rotated(randf_range(-stats.spread, stats.spread)), stats.damage)

func apply_recoil(direction: Vector2) -> Vector2:
	var recoil_angle = randf_range(-stats.recoil, stats.recoil)
	return direction.rotated(deg_to_rad(recoil_angle))

func apply_shake(intensity: int):
	if main_camera:
		main_camera.apply_shake(intensity)

# Fonction pour recharger les munitions
func reload():
	if is_reloading or stats.infinite_ammo:
		return

	is_reloading = true
	print("Rechargement en cours...")

	# Calculer combien de balles il manque pour remplir le chargeur
	var needed_ammo = stats.ammo_per_magazine - current_magazine

	# Vérifier combien de munitions sont disponibles dans le max_ammo
	var ammo_to_reload = min(needed_ammo, stats.max_ammo)

	# Réduire les munitions totales et remplir le chargeur
	stats.max_ammo -= ammo_to_reload
	current_magazine += ammo_to_reload

	# Mettre à jour l'interface utilisateur
	Gamemanager.update_sprite_current_weapon(stats.texture)
	Gamemanager.update_max_ammo(stats.max_ammo)
	Gamemanager.update_max_ammo_magazin(stats.ammo_per_magazine)
	Gamemanager.update_current_magazine(current_magazine)

	# Attendre la durée du rechargement
	await get_tree().create_timer(stats.reload_time).timeout

	is_reloading = false
	print("Rechargement terminé.")


func toggle_infinite_ammo(enabled: bool):
	stats.infinite_ammo = enabled
	print("Munitions infinies " + ( "activées." if enabled else "désactivées." ))
	
