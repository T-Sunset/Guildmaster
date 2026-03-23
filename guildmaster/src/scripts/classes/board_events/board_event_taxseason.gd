# NAME.GD
extends Effect
class_name BoardEventTaxSeason

# Constructor
func _init():
	super("Tax Season", "The crown demands it's due.\n-25% Gold rewards from all quests.\n+25% EXP gained from all quests.")

# Overrides
func _get_quest_gold_reward_modifier(quest:QuestData) -> float:
	return 0.75
func _get_quest_exp_reward_modifier(quest:QuestData) -> float:
	return 1.25
