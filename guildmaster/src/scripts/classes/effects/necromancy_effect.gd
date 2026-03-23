# NAME.GD
extends Effect
class_name NecromancyEffect

# Constructor
func _init():
	super("Necromancy", "This hero contributes +50% aptitude towards quests for every empty " + \
	"party member slot there is remaining.")

# Overrides
func _get_aptitude_modifier(quest:QuestData) -> float: # Does this effect modify this hero's output aptitude
	# for a given quest at all?
	var val = 1.0
	if len(quest.quest_party) > 0:
		val = 2.5
		for hero in quest.quest_party:
			val -= 0.5
	return val # +50% aptitude per missing ally
