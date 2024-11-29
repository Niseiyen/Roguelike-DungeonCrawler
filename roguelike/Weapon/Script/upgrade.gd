extends Resource

@export var name: String
@export var description: String
@export var modifiers: Dictionary = {
	"damage": 0.0,
	"fire_rate": 0.0,
	"spread": 0.0
}

func apply_upgrade(weapon: Node):
	for key in modifiers.keys():
		if weapon.has_property(key):
			weapon.set(key, weapon.get(key) + modifiers[key])
		else:
			print("Warning: Weapon does not have property '%s'" % key)
