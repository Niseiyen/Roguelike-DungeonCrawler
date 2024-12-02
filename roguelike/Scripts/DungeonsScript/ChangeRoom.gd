extends Area2D

@onready var teleportation_marker: Marker2D = $TeleportationMarker

func _on_body_entered(body: Node2D) -> void:
	print(body)
	if(body.name == "Player"):
		body.global_position = teleportation_marker.global_position
