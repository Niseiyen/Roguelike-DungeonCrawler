extends Node

@onready var current_weapon_layout: Control = get_node("/root/MainScene/CanvasLayer/Current_Weapon_Layout")
@onready var heart_container: HBoxContainer = get_node("/root/MainScene/CanvasLayer/HeartContainer")

func update_sprite_current_weapon(texture: Texture2D):
	current_weapon_layout.update_sprite_current_weapon(texture)
	
func update_current_magazine(current_magazine: int):
	current_weapon_layout.update_current_magazine(current_magazine)
	
func update_max_ammo(max: int):
	current_weapon_layout.update_max_ammo(max)

func update_max_ammo_magazin(max_ammo_magazine: int):
	current_weapon_layout.update_max_ammo_magazin(max_ammo_magazine)

func setup_hearts(max_health: int) -> void:
	heart_container.setup_hearts(max_health)

func update_hearts(current_health: int) -> void:
	heart_container.update_hearts(current_health)
