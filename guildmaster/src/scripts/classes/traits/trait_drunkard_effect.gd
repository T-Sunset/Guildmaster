# NAME.GD
extends Effect
class_name TraitDrunkardEffect

# Constructor
func _init():
	super("Drunkard", "This hero regenerates health at a +1 rate per rank while in base.", true)

# Overrides
func _get_base_regeneration() -> int:
	var val = 1
	for i in range(effect_level):
		val += 1
	return val # Increase base health regeneration by +1 per rank.
