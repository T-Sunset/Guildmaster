# NAME.GD
extends Effect
class_name TraitProtectiveEffect

# Constructor
func _init():
	super("Protective", "This hero is +20% more effective per rank in quests tagged 'Protect'.", true)

# Overrides
func _get_aptitude_modifier(quest:QuestData) -> float: # Does this effect modify this hero's output aptitude
	# for a given quest at all?
	var val = 1.0
	for i in range(effect_level):
		val += 0.2 # +20% effectiveness against given type
	if quest.get_tags().has("protect"):
		return val
	else:
		return 1.0
