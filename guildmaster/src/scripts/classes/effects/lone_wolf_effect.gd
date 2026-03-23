# NAME.GD
extends Effect
class_name LoneWolfEffect

# Constructor
func _init():
	super("Lone Wolf", "This hero will take 50% less time to complete quests they embark upon solo.")

# Overrides
func _get_quest_duration_modifier(quest:QuestData) -> float: # Effect add or reduce speed?
	if len(quest.quest_party) == 1:
		return 0.5 # -50% quest duration when Ranger going alone
	else:
		return 1.0
