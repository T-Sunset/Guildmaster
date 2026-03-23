# NAME.GD
extends Effect
class_name NecromasteryEffect

# Parameters
var souls : int = 0

# Constructor
func _init():
	super("Necromastery", "This hero increases the gold and experience rewarded from " + \
	"quests they complete by 1% for every quest they complete after learning this skill.")

# Overrides
func _get_quest_gold_reward_modifier(quest:QuestData) -> float:
	return 1.0 + (float(souls) * 0.01) # 1% Gold reward up per soul
func _get_quest_exp_reward_modifier(quest:QuestData) -> float:
	return 1.0 + (float(souls) * 0.01) # 1% EXP reward up per soul
func _quest_complete_event(quest:QuestData):
	souls += 1
