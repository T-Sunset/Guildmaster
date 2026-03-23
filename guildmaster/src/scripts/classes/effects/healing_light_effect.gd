# NAME.GD
extends Effect
class_name HealingLightEffect

# Constructor
func _init():
	super("Healing Light", "At the end of each quest this hero successfully completes, " + \
	"they will heal all of their party members by an amount equal to their WIL.")

# Overrides
func _quest_complete_event(quest:QuestData):
	for hero in quest.quest_party:
		hero.heal(effect_hero.get_stat(Defs.Stats.WILLPOWER)) # Heal party for WIL
