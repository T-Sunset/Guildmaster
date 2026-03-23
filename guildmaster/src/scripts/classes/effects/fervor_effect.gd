# NAME.GD
extends Effect
class_name FervorEffect

# Constructor
func _init():
	super("Fervour", "Half of this hero's base STR is applied to their INT, and half of their " + \
	"base INT is applied to their STR.")

# Overrides
func _get_stat_bonus(stat:Defs.Stats) -> int:
	if stat == Defs.Stats.STRENGTH:
		return int(float(effect_hero.hero_stats[Defs.Stats.INTELLIGENCE]) * 0.5) 
		# Add half base INT to STR
	elif stat == Defs.Stats.INTELLIGENCE:
		return int(float(effect_hero.hero_stats[Defs.Stats.STRENGTH]) * 0.5)
		# Add half base STR to INT
	else:
		return 0
