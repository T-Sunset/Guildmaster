# NAME.GD
extends Effect
class_name BoardEventRareFinds

# Constructor
func _init():
	super("Rare Finds", "Treasure hunters reporting valuable loot!\n+ Increased chance for higher-rarity quests.")

# Overrides
func _rarity_find_rate_mod(rarity:Rarity) -> float:
	if rarity == Defs.get_rarity_by_name("Common"):
		return 1.0
	elif rarity == Defs.get_rarity_by_name("Uncommon"):
		return 0.8
	elif rarity == Defs.get_rarity_by_name("Rare"):
		return 0.3
	elif rarity == Defs.get_rarity_by_name("Epic"):
		return 0.1
	else:
		return 0.02
