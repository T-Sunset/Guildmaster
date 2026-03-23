# NAME.GD
extends Effect
class_name TraitFastLearnerEffect

# Constructor
func _init():
	super("Fast Learner", "This hero receives +5% EXP per quest per rank.", true)

# Overrides
func _get_quest_exp_reward_modifier(quest:QuestData) -> float:
	var val = 1.0
	for i in range(effect_level):
		val += 0.05 # +5% EXP gained per rank
	return val
