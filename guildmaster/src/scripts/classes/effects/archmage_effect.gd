# NAME.GD
extends Effect
class_name ArchmageEffect

# Constructor
func _init():
	super("Archmage", "This hero will contribute an additional flat amount to any quest they " + \
	"participate in, equal to half of their INT.")

# Overrides
func _get_aptitude_bonus(quest:QuestData) -> int:
	return int(float(effect_hero.get_stat(Defs.Stats.INTELLIGENCE) * 0.5))
