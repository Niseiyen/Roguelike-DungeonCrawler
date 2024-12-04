extends CharacterBody2D

@export var speed: float = 25.0
@export var damage: int = 10
@export var life: float = 100.0

var player = null

func _process(delta):
	# Si un joueur est détecté, le poursuivre
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		
func take_damage(damage: float):
	life = life - damage
	print(life)
	
	if life <= 0:
		_die()
	
func _die():
	print("Enemy dead")
	queue_free()
	
func _on_de_aggro_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body

func _on_enemy_1_hurt_box_area_entered(hitbox: Area2D) -> void:
	print("Damage " + str(hitbox.damage))
	if hitbox.is_in_group("Bullets"):
		take_damage(hitbox.damage)
		hitbox.queue_free()
