# NAME.GD
extends Effect
class_name BoardEventUrgentContracts

# Constructor
func _init():
	super("Urgent Contracts", "Our clients demand speed.\n-40% Quest duration.")

# Overrides
func _get_quest_duration_modifier(quest:QuestData) -> float: # Effect add or reduce speed?
	return 0.6
