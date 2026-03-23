# NAME.GD
extends Effect
class_name SpellEfficiencyEffect

# Constructor
func _init():
	super("Spell Efficiency", "This hero reduces the duration of quests they participate in " + \
	"by a value equal to 50% of their INT.")

# Overrides
func _get_quest_speed_bonus(quest:QuestData) -> int:
	return int(float(effect_hero.get_stat(Defs.Stats.INTELLIGENCE) * 0.5)) # Reduce quest time by INT/2.
