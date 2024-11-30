extends Node2D
class_name Weapon

@export var fire_rate: float
@export var damage: float
@export var projectile_scene: PackedScene
@export var spread: float
@export var recoil: float
@export var bullet_count: int
@export var camera_shake_intensity: int

@export var shoot_animation: String = "BaseWeaponShoot" 

@export var upgrades: Array = []
var time_since_last_shot: float = 0

@onready var marker_2d: Marker2D = $Muzzle
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var main_camera: Camera2D = get_node("/root/MainScene/MainCamera")
@onready var muzzle_particle: GPUParticles2D = $MuzzleParticle

func _process(delta: float):
	time_since_last_shot += delta

func shoot(position: Vector2, direction: Vector2):
	if time_since_last_shot >= 1.0 / fire_rate:
		time_since_last_shot = 0
		animation_player.play(shoot_animation)

		if muzzle_particle:
			muzzle_particle.emitting = true 

		# Applique le recul à chaque projectile
		for i in bullet_count:
			var recoil_adjusted_direction = apply_recoil(direction)
			spawn_projectile(marker_2d.global_position, recoil_adjusted_direction)
		
		apply_shake(camera_shake_intensity)

func spawn_projectile(position: Vector2, direction: Vector2):
	if projectile_scene:
		var projectile = projectile_scene.instantiate()
		get_tree().current_scene.add_child(projectile)
		projectile.initialize(position, direction.rotated(randf_range(-spread, spread)), damage)

func apply_recoil(direction: Vector2) -> Vector2:
	var recoil_angle = randf_range(-recoil, recoil)
	return direction.rotated(deg_to_rad(recoil_angle))
	
func apply_shake(intensity: int):
	if main_camera:
		main_camera.apply_shake(intensity)
