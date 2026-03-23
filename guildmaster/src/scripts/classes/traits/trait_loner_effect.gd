# NAME.GD
extends Effect
class_name TraitLonerEffect

# Constructor
func _init():
	super("Loner", "This hero is +10% faster at completing quests solo per rank.", true)

# Overrides
func _get_quest_duration_modifier(quest:QuestData) -> float: # Effect add or reduce speed?
	var val = 1.0
	for i in range(effect_level):
		val -= 0.1 # -10% quest duration per rank when alone.
	if len(quest.quest_party) == 1:
		return val # -50% quest duration when Ranger going alone
	else:
		return 1.0
