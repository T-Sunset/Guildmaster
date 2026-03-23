# NAME.GD
extends Effect
class_name DarkPactEffect

# Constructor
func _init():
	super("Dark Pact", "This hero receives +50% damage from all sources, but has all of " + \
	"their stats increased by 25%.")

# Overrides
func _get_damage_received_modifier(quest:QuestData) -> float: # Effect any incoming damage JUST to this hero?
	return 1.5 # +50% damage received.
func _get_stat_modifier(stat:Defs.Stats) -> float: # Does this effect modify this hero's stat(s) at all?
	return 1.25 # 25% bonus to all stats.
