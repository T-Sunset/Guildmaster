# NAME.GD
extends Effect
class_name UnstoppableEffect

# Constructor
func _init():
	super("Unstoppable", "This hero cannot rest, and will remain on 1HP regardless of " + \
	"damage taken.")

# Overrides
func _quest_complete_event(quest:QuestData):
	# Are we dead?
	if effect_hero.hero_state == Defs.HeroStates.RESTING:
		effect_hero.change_state(Defs.HeroStates.IDLE)
		effect_hero.hero_cur_hp = 1
