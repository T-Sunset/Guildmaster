# NAME.GD
extends Effect
class_name PathfinderEffect

# Constructor
func _init():
	super("Pathfinder", "This hero reduces quest completion time by an additional flat amount" + \
	" equal to 33% of their AGI.")

# Overrides
func _get_quest_speed_bonus(quest:QuestData) -> int:
	return int(float(effect_hero.get_stat(Defs.Stats.AGILITY)) * 0.33) # 33% Agility always applied
