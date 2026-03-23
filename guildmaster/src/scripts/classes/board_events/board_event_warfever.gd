# NAME.GD
extends Effect
class_name BoardEventWarFever

# Constructor
func _init():
	super("War Fever", "Our heroes are eager for battle!\nHeroes have +25% STR today!")

# Overrides
func _get_stat_modifier(stat:Defs.Stats) -> float: # Does this effect modify this hero's stat(s) at all?
	if stat == Defs.Stats.STRENGTH: return 1.25
	else: return 1.0
