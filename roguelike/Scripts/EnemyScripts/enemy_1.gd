extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var player: Node2D = get_node("/root/Scene/Player")  # Référence au joueur, ajustez le chemin si nécessaire

@export var speed: float = 100  # Vitesse de déplacement de l'ennemi
@export var detection_range: float = 500  # Distance à laquelle l'ennemi détecte le joueur

# Appelé au démarrage du script
func _ready() -> void:
	navigation_agent_2d.target_position = player.position  # Initialiser la position cible (celle du joueur)

# Appelé à chaque frame pour suivre le joueur
func _process(delta: float) -> void:
	if player.position.distance_to(position) < detection_range:  # Si le joueur est dans la portée
		navigation_agent_2d.target_position = player.position  # Mettre à jour la cible de l'agent
	else:
		navigation_agent_2d.target_position = position  # Si le joueur est hors portée, l'ennemi s'arrête

	# Suivre le chemin calculé par NavigationAgent2D
	update_velocity(delta)

# Met à jour la vitesse en fonction du chemin trouvé par l'agent
func update_velocity(delta: float) -> void:
	var path = navigation_agent_2d.get_current_path()  # Récupérer le chemin actuel

	if path.size() > 0:
		var direction = (path[0] - position).normalized()  # Direction vers la prochaine position du chemin
		velocity = direction * speed  # Appliquer la vitesse
		move_and_slide()  # Déplacer l'ennemi selon la vitesse
