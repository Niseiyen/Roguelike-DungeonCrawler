extends Camera2D

@export var shake_fade: int = 0.0

var rng = RandomNumberGenerator.new()
var shake_strength: int = 0.0

func _ready() -> void:
	Events.room_entered.connect(func(room: Room):
		global_position = room.camera_pos.global_position
	)
	
func apply_shake(intensity: int):
	print(intensity)
	shake_strength = intensity

func _process(delta: float) -> void:
	if(shake_strength > 0):
		shake_strength = lerp(shake_strength, 0, shake_fade * delta)
		
		offset = randomOffset()

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
