# NAME.GD
extends Effect
class_name TraitResilientEffect

# Constructor
func _init():
	super("Resilient", "This hero takes 5% LESS damage from quests per rank.", true)

# Overrides
func _get_damage_received_modifier(quest:QuestData) -> float: #Does this effect modify the quest's damage?
	var val = 1.0
	for i in range(effect_level):
		val -= 0.05 # Reduce damage taken by 5% per rank
	return val
