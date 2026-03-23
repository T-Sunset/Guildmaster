# NAME.GD
extends Effect
class_name AvatarOfWarEffect

# Constructor
func _init():
	super("Avatar of War", "This hero will contribute an additional flat value equal to " + \
	"half of their STR to every quest they participate in.")

# Overrides
func _get_aptitude_bonus(quest:QuestData) -> int:
	return int(float(effect_hero.get_stat(Defs.Stats.STRENGTH) * 0.5))
