# NAME.GD
extends Effect
class_name TraitGreedyEffect

# Constructor
func _init():
	super("Greedy", "This hero increases gold yield from quests they participate in " + \
	"by 5% per rank.", true)

# Overrides
func _get_quest_gold_reward_modifier(quest:QuestData) -> float:
	var val = 1.0
	for i in range(effect_level):
		val += 0.05 # +5% Gold gained per rank
	return val
