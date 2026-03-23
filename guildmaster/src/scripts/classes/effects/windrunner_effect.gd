# NAME.GD
extends Effect
class_name WindrunnerEffect

# Constructor
func _init():
	super("Windrunner", "This hero's AGI is tripled whilst they are on full HP.")

# Overrides
func _get_stat_modifier(stat:Defs.Stats) -> float: # Does this effect modify this hero's stat(s) at all?
	if stat == Defs.Stats.AGILITY and effect_hero.hero_cur_hp == effect_hero.get_max_hp():
		return 3.0 # Triple agility when full health!
	else:
		return 1.0
