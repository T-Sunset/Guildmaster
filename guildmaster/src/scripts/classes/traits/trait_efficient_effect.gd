# NAME.GD
extends Effect
class_name TraitEfficientEffect

# Constructor
func _init():
	super("Efficient", "This hero reduces quest duration by 5% per rank.", true)

# Overrides
func _get_quest_duration_modifier(quest:QuestData) -> float: # Effect add or reduce speed?
	var val = 1.0
	for i in range(effect_level):
		val -= 0.05 # Reduce quest duration by 5% per rank
	return val
