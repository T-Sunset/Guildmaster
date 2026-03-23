# NAME.GD
extends Effect
class_name BackstabEffect

# Constructor
func _init():
	super("Backstab", "When this hero participates in a quest, the maximum rollable " + 
	"aptitude value is doubled, vastly increasing the party's potential result.")

# Overrides
func _get_quest_upper_variance_modifier(quest:QuestData) -> float:
	return 2.0 # Double upper variance limit
