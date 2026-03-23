# NAME.GD
extends Effect
class_name PrecisionEffect

# Constructor
func _init():
	super("Precision", "This hero's DEX is increased by 33%.")

# Overrides
func _get_stat_modifier(stat:Defs.Stats) -> float: # Does this effect modify this hero's stat(s) at all?
	if stat == Defs.Stats.DEXTERITY:
		return 1.33
	else:
		return 1.0
