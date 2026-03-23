# NAME.GD
extends Effect
class_name IndomitableEffect

# Constructor
func _init():
	super("Indomitable", "This hero contributes a flat additional +1 for every level-up they've " + \
	"ever received across all classes.")

# Overrides
func _get_aptitude_bonus(quest:QuestData) -> int:
	return effect_hero.get_total_level() # Apply 1 contribution for every hero level
