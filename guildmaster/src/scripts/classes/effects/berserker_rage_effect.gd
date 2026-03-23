# Berserker_Rage_Effect.gd
extends Effect
class_name BerserkerRageEffect

# Constructor
func _init():
	super("Berserker Rage", "This hero gains +50% STR when they're below 50% HP.")

# Overrides
func _get_stat_modifier(stat:Defs.Stats): # Does this effect modify this hero's stat(s) at all?
	if stat == Defs.Stats.STRENGTH:
		if effect_hero.hero_cur_hp <= (effect_hero.get_max_hp() / 2):
			return 1.5 # Add 50%
		else: return 1.0
	else:
		return 1.0
