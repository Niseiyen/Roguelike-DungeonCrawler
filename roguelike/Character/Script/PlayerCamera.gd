extends Area2D

@onready var camera_2d: Camera2D = $"../Camera2D"

func _on_area_entered(area: Area2D) -> void:
	if(area.name == "PlayerArea"):
		camera_2d.enabled = true


func _on_area_exited(area: Area2D) -> void:
	if(area.name == "PlayerArea"):
		camera_2d.enabled = false
