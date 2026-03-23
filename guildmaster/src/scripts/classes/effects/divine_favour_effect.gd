# NAME.GD
extends Effect
class_name DivineFavourEffect

# Constructor
func _init():
	super("Divine Favour", "When this hero participates in a quest, the upper limit of " + \
	"possible aptitude variance increases by 33%.")

# Overrides
func _get_quest_upper_variance_bonus(quest:QuestData) -> int:
	return int(float(effect_hero.get_stat(Defs.Stats.WILLPOWER)) * 0.33)
