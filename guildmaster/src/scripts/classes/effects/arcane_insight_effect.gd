# NAME.GD
extends Effect
class_name ArcaneInsightEffect

# Constructor
func _init():
	super("Arcane Insight", "This hero's Intelligence is passively increased by 33%.")

# Overrides
func _get_stat_modifier(stat:Defs.Stats) -> float: # Does this effect modify this hero's stat(s) at all?
	if stat == Defs.Stats.INTELLIGENCE:
		return 1.33 # +33% bonus
	else: return 1.0
