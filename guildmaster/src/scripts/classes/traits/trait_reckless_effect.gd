# NAME.GD
extends Effect
class_name TraitRecklessEffect

# Constructor
func _init():
	super("Reckless", "This hero takes +10% more damage, but completes quests 5% faster per rank.", true)

# Overrides
func _get_quest_duration_modifier(quest:QuestData) -> float: # Effect add or reduce speed?
	var val = 1.0
	for i in range(effect_level):
		val -= 0.05 # -5% quest duration per rank
	return val
func _get_damage_received_modifier(quest:QuestData) -> float: # Effect any incoming damage JUST to this hero?
	var val = 1.0
	for i in range(effect_level):
		val += 0.1 # +10% damage taken per rank
	return val
