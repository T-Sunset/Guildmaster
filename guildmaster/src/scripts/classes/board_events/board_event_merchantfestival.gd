# NAME.GD
extends Effect
class_name BoardEventMerchantFestival

# Constructor
func _init():
	super("Merchant Festival", "Traders flood the city.\n+50% Gold rewards from all quests.")

# Overrides
func _get_quest_gold_reward_modifier(quest:QuestData) -> float:
	return 1.5
