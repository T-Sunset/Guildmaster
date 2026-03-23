# NAME.GD
extends Effect
class_name HuntersMarkEffect

# Constructor
func _init():
	super("Hunter's Mark", "This hero contributes 300% aptitude towards quests featuring Bosses.")

# Overrides
func _get_aptitude_modifier(quest:QuestData) -> float: # Does this effect modify this hero's output aptitude
	# for a given quest at all?
	if quest.get_tags().has("boss"):
		return 3.0 # 3x contribution vs. Bosses
	else:
		return 1.0
