extends HBoxContainer

var hearts: Array = []
const HEATH = preload("res://UI/Player/Heath.tscn")

func setup_hearts(max_health: int) -> void:
	# Supprime les cœurs existants
	for heart in hearts:
		heart.queue_free()
	hearts.clear()
	
	# Calcule le nombre de cœurs nécessaires (1 cœur pour 2 points de santé)
	var num_hearts = ceil(max_health / 2.0)
	
	# Ajoute le nombre requis de cœurs
	for i in range(num_hearts):
		var heart_instance = HEATH.instantiate()
		add_child(heart_instance)
		hearts.append(heart_instance)
	
	update_hearts(max_health)

func update_hearts(current_health: int) -> void:
	var full_hearts = current_health / 2
	var half_hearts = current_health % 2 

	# Mise à jour des cœurs
	for i in range(hearts.size()):
		var heart_sprite: Heart = hearts[i]
		
		# Si l'index est inférieur au nombre de cœurs pleins, c'est un cœur plein
		if i < full_hearts:
			if heart_sprite.current_state != "full":
				heart_sprite.init()  # Cœur plein
				heart_sprite.play_animate("init") 
			heart_sprite.current_state = "full" 
		# Si on est sur le dernier cœur et que la santé est impair, c'est un demi-cœur
		elif i == full_hearts and half_hearts > 0:
			if heart_sprite.current_state != "half":
				heart_sprite.take_half_damage() 
				heart_sprite.play_animate("half_heart") 
			heart_sprite.current_state = "half"
		else:
			if heart_sprite.current_state != "empty":
				heart_sprite.take_full_heart()  
				heart_sprite.play_animate("zero_heart") 
			heart_sprite.current_state = "empty"  
 
