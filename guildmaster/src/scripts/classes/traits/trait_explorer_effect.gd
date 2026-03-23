# NAME.GD
extends Effect
class_name TraitExplorerEffect

# Constructor
func _init():
	super("Explorer", "This hero is +20% more effective per rank in quests tagged 'Explore'.", true)

# Overrides
func _get_aptitude_modifier(quest:QuestData) -> float: # Does this effect modify this hero's output aptitude
	# for a given quest at all?
	var val = 1.0
	for i in range(effect_level):
		val += 0.2 # +20% effectiveness against given type
	if quest.get_tags().has("explore"):
		return val
	else:
		return 1.0
