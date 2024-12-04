extends Node2D
class_name Room

@onready var camera_pos: Marker2D = $CameraPos

var connected_rooms = {
	Vector2(1, 0): null,
	Vector2(-1, 0): null,
	Vector2(0, 1): null,
	Vector2(0, -1): null
}

var number_of_connections = 0


func _on_player_detection_body_entered(body: Node2D) -> void:
	Events.room_entered.emit(self)
