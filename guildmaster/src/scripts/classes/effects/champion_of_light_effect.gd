# NAME.GD
extends Effect
class_name ChampionOfLightEffect

# Constructor
func _init():
	super("Champion of Light", "This hero contributes +25% aptitude per ally on the same quest " + \
	"alongside them.")

# Overrides
func _get_aptitude_modifier(quest:QuestData) -> float: # Does this effect modify this hero's output aptitude
	# for a given quest at all?
	var val = 0.75
	for hero in quest.quest_party:
		val += 0.25 # +25% aptitude per ally on the quest with you
	return val
