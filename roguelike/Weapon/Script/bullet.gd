extends Area2D

@export var speed: float = 400.0
@export var damage: float = 10.0
@export var lifetime: float = 3.0

var direction: Vector2 = Vector2.ZERO
var time_alive: float = 0.0

func initialize(position: Vector2, direction: Vector2, damage: float):
	global_position = position
	self.direction = direction.normalized()
	self.damage = damage

func _process(delta: float):
	global_position += direction * speed * delta

	time_alive += delta
	if time_alive >= lifetime:
		queue_free()

func _on_bullet_zone_area_entered(area: Area2D):
	if area.has_method("take_damage"):
		area.take_damage(damage)
	queue_free()
