extends CharacterBody2D

@export var speed: float = 25.0
@export var damage: int = 10
@export var life: float

@onready var player := get_tree().get_nodes_in_group("Player")[0] 
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_player_detected: bool = false

func _physics_process(delta: float) -> void:
	if is_player_detected:
		var dir = to_local(navigation_agent_2d.get_next_path_position()).normalized()
		velocity = dir * speed
		move_and_slide()
		
		update_sprite_flip(dir)

func makepath():
	if is_player_detected and player:
		navigation_agent_2d.target_position = player.global_position
	
func _on_timer_timeout() -> void:
	makepath()
	
func take_damage(damage: float):
	life -= damage
	print(life)
	
	if life <= 0:
		_die()
	
func _die():
	print("Enemy dead")
	queue_free()
	
func _on_enemy_1_hurt_box_area_entered(hitbox: Area2D) -> void:
	if hitbox.is_in_group("Bullets"):
		take_damage(hitbox.damage)
		hitbox.explode()

func _on_aggro_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_player_detected = true
		makepath()

func update_sprite_flip(direction: Vector2) -> void:
	if direction.x != 0:
		animated_sprite_2d.flip_h = direction.x < 0
