# NAME.GD
extends Effect
class_name BoardEventFortuneSmiles

# Constructor
func _init():
	super("Fortune Smiles!", "Luck is in the air.\nHeroes have +25% LUK today!")

# Overrides
func _get_stat_modifier(stat:Defs.Stats) -> float: # Does this effect modify this hero's stat(s) at all?
	if stat == Defs.Stats.LUCK: return 1.25
	else: return 1.0
