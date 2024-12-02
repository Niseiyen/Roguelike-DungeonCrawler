extends Resource
class_name WeaponStats

@export var fire_rate: float
@export var damage: float
@export var projectile_scene: PackedScene
@export var spread: float
@export var recoil: float
@export var bullet_count: int
@export var camera_shake_intensity: int
@export var shoot_animation: String = "BaseWeaponShoot"
@export var texture: Texture2D
@export var upgrades: Array = []

# Ammo-related variables
@export var max_ammo: int
@export var ammo_per_magazine: int
@export var reload_time: float
@export var infinite_ammo: bool = false
