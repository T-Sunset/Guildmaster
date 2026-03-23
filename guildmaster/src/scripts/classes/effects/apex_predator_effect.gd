# NAME.GD
extends Effect
class_name ApexPredatorEffect

# Constructor
func _init():
	super("Apex Predator", "This hero contributes 100%/120%/140%/160%/200% of their normal amount "\
	+ "based on the rarity of the quest they're undertaking.")

# Overrides
func _get_aptitude_modifier(quest:QuestData) -> float: # Does this effect modify this hero's output aptitude
	# for a given quest at all?
	return quest.quest_rarity.rarity_modifier # Contribution increases as quest rarity increases.
