extends Control

@onready var max_ammo: Label = $"MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Max Ammo"
@onready var max_magazin: Label = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/max_magazin
@onready var magazin_ammo: Label = $"MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/Magazin Ammo"
@onready var texture_rect: TextureRect = $MarginContainer/MarginContainer/VBoxContainer/MarginContainer/TextureRect


func update_max_ammo(max: int):
	print(max)
	max_ammo.text = str(max)
	
func update_max_ammo_magazin(max_ammo_magazine: int):
	print(max_ammo_magazine)
	max_magazin.text = str(max_ammo_magazine) + "/"
	
func update_current_magazine(current_magazine: int):
	print(current_magazine)
	magazin_ammo.text = str(current_magazine)
	
func update_sprite_current_weapon(texture: Texture2D):
	texture_rect.texture = texture
