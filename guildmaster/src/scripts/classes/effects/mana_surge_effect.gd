# NAME.GD
extends Effect
class_name ManaSurgeEffect

# Constructor
func _init():
	super("Mana Surge", "After successfully completing a quest, this hero has a 25% chance to " + \
	"heal themselves for an amount equal to their INT.")

# Overrides
func _quest_complete_event(quest:QuestData):
	var rand = randi_range(1,4)
	if rand == 4: # 25% chance to heal for INT health at the end of each quest
		effect_hero.heal(effect_hero.get_stat(Defs.Stats.INTELLIGENCE))
		effect_hero.change_state(Defs.HeroStates.IDLE)
