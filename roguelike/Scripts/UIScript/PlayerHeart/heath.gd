extends MarginContainer
class_name Heart

@onready var heart_image: AnimatedSprite2D = $HeartImage

var current_state: String = "empty"

func take_half_damage():
	heart_image.play("half_heart")

func take_full_heart():
	heart_image.play("zero_heart")  

func init():
	heart_image.play("init")  

func play_animate(animation_name: String):
	heart_image.play(animation_name)
