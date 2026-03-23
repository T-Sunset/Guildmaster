# NAME.GD
extends Effect
class_name BoardEventHappyHours

# Constructor
func _init():
	super("Happy Hour(s)!", "The guild tavern ale flows freely all day today. Was this the right move?\nHeroes have +25% WIL today!")

# Overrides
func _get_stat_modifier(stat:Defs.Stats) -> float: # Does this effect modify this hero's stat(s) at all?
	if stat == Defs.Stats.WILLPOWER: return 1.25
	else: return 1.0
