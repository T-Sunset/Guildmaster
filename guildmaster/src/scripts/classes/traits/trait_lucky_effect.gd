# NAME.GD
extends Effect
class_name TraitLuckyEffect

# Constructor
func _init():
	super("Lucky", "This hero shrinks the lower variance limit for aptitude on quests they " + \
	"participate in by 5% per rank.", true)

# Overrides
func _get_quest_lower_variance_modifier(quest:QuestData) -> float:
	var val = 1.0
	for i in range(effect_level):
		val += 0.05 # -5% Downward variance range per rank
	return val
