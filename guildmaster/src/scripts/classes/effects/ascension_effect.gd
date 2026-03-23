# NAME.GD
extends Effect
class_name AscensionEffect

# Constructor
func _init():
	super("Ascension", "This hero will fully heal all party members at the end of each " + \
	"successful quest.")

# Overrides
func _quest_complete_event(quest:QuestData):
	for hero in quest.quest_party:
		hero.heal(hero.get_max_hp()) # Fully heal allies per quest
