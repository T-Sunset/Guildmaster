# NAME.GD
extends Effect
class_name ScavengerEffect

# Constructor
func _init():
	super("Scavenger", "This hero increases the gold and EXP yield of quests they participate " + \
	"in by 33%.")

# Overrides
func _get_quest_gold_reward_modifier(quest:QuestData) -> float:
	return 1.33 # 33% Gold reward mod
func _get_quest_exp_reward_modifier(quest:QuestData) -> float:
	return 1.33 # 33% EXP reward mod
