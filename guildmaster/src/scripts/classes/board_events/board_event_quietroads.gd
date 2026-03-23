# NAME.GD
extends Effect
class_name BoardEventQuietRoads

# Constructor
func _init():
	super("Quiet Roads", "Travel is unusually safe.\n-33% Quest duration.\n-15% Quest EXP rewards.")

# Overrides
func _get_quest_duration_modifier(quest:QuestData) -> float: # Effect add or reduce speed?
	return 0.66
func _get_quest_exp_reward_modifier(quest:QuestData) -> float:
	return 0.85
