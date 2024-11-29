extends Node2D

@export var fire_rate: float = 1.0
@export var damage: float = 10.0
@export var projectile_scene: PackedScene
@export var spread: float = 0.0
@export var upgrades: Array = []

var time_since_last_shot: float = 0
@onready var marker_2d: Marker2D = $Marker2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta: float):
	time_since_last_shot += delta

func shoot(position: Vector2, direction: Vector2):
	if time_since_last_shot >= 1.0 / fire_rate:
		time_since_last_shot = 0
		spawn_projectile(position, direction)
		animation_player.play("BaseWeaponShoot")

func spawn_projectile(position: Vector2, direction: Vector2):
	if projectile_scene:
		var projectile = projectile_scene.instantiate()
		var pos = marker_2d.global_position
		get_tree().current_scene.add_child(projectile)  
		projectile.initialize(pos, direction.rotated(randf_range(-spread, spread)), damage)
