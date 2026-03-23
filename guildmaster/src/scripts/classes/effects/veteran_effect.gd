# NAME.GD
extends Effect
class_name VeteranEffect

# Constructor
func _init():
	super("Veteran", "This hero will consistently perform at their best (upper variance limit). However, their " + \
	"best is reduced by 20%.")

# Overrides
func _get_quest_lower_variance_modifier(quest:QuestData) -> float:
	return 999.0 # Lower limit will be set to the same as upper limit
func _get_quest_upper_variance_modifier(quest:QuestData) -> float:
	return 0.8 # Reduces upper limit by 20%
