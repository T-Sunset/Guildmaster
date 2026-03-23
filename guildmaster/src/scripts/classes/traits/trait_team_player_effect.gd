# NAME.GD
extends Effect
class_name TraitTeamPlayerEffect

# Constructor
func _init():
	super("Team Player", "This hero reduces quest duration on quests they participate in by " + \
	"10% per rank when part of a full party of 3.", true)

# Overrides
func _get_quest_duration_modifier(quest:QuestData) -> float: # Effect add or reduce speed?
	var val = 1.0
	for i in range(effect_level):
		val -= 0.1 # -10% quest duration per rank when alone.
	if len(quest.quest_party) == 3:
		return val # -50% quest duration when Ranger going alone
	else:
		return 1.0
