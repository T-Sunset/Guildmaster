# NAME.GD
extends Effect
class_name ShadowstepEffect

# Constructor
func _init():
	super("Shadowstep", "This hero reduces the duration of quests they participate in by 20%.")

# Overrides
func _get_quest_duration_modifier(quest:QuestData) -> float: # Effect add or reduce speed?
	return 0.8 # 20% reduced quest duration
