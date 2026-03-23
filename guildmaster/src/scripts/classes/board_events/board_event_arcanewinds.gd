# NAME.GD
extends Effect
class_name BoardEventArcaneWinds

# Constructor
func _init():
	super("Arcane Winds", "Magic flows freely.\nHeroes have +25% INT today!")

# Overrides
func _get_stat_modifier(stat:Defs.Stats) -> float: # Does this effect modify this hero's stat(s) at all?
	if stat == Defs.Stats.INTELLIGENCE: return 1.25
	else: return 1.0
