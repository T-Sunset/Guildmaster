# NAME.GD
extends Effect
class_name RestorationEffect

# Constructor
func _init():
	super("Restoration", "This hero regenerates health at +50% rate.")

# Overrides
func _get_regeneration_modifier() -> float:
	return 1.5 # +50% rest time speed
