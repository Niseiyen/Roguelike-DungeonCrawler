extends Area2D

@export var weapon_scene: PackedScene 
@export var pickup_sprite: Texture2D  
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.texture = pickup_sprite

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): 
		var player = body  
		player.add_weapon(weapon_scene)  
		queue_free() 
