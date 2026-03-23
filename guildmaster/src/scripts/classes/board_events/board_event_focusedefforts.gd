# NAME.GD
extends Effect
class_name BoardEventFocusedEfforts

# Constructor
func _init():
	super("Focused Efforts", "Our heroes are giving it their all today.\nHeroes have +25% DEX today!")

# Overrides
func _get_stat_modifier(stat:Defs.Stats) -> float: # Does this effect modify this hero's stat(s) at all?
	if stat == Defs.Stats.DEXTERITY: return 1.25
	else: return 1.0
