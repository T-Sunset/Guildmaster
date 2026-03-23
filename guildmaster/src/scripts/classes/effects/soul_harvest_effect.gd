# NAME.GD
extends Effect
class_name SoulHarvestEffect

# Parameters
var souls : int = 0

# Constructor
func _init():
	super("Soul Harvest", "This hero gains +1 soul for every quest completed after learning this skill." + \
	" All aptitude contributions they put forth are increased by +1 per soul.")

# Overrides
func _quest_complete_event(quest:QuestData):
	souls += 1
func _get_aptitude_bonus(quest:QuestData) -> int:
	return souls # Gain a Soul for every quest successfully completed.
	# Increase all quest contributions by 1 per soul.
