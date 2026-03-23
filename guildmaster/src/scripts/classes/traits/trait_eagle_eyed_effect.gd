# NAME.GD
extends Effect
class_name TraitEagleEyedEffect

# Constructor
func _init():
	super("Eagle-Eyed", "This hero is +20% more effective per rank in quests tagged 'Scout'.", true)

# Overrides
func _get_aptitude_modifier(quest:QuestData) -> float: # Does this effect modify this hero's output aptitude
	# for a given quest at all?
	var val = 1.0
	for i in range(effect_level):
		val += 0.2 # +20% effectiveness against given type
	if quest.get_tags().has("scout"):
		return val
	else:
		return 1.0
