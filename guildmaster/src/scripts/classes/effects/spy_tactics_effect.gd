# NAME.GD
extends Effect
class_name SpyTacticsEffect

# Constructor
func _init():
	super("Spy Tactics", "This hero takes reduced damage from quests by an amount equal to their AGI.")

# Overrides
func _get_damage_received_bonus(quest:QuestData) -> int:
	return -effect_hero.get_stat(Defs.Stats.AGILITY) # Reduce damage taken by AGI
