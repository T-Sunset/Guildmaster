# NAME.GD
extends Effect
class_name EvasionEffect

# Constructor
func _init():
	super("Evasion", "This hero has a 25% chance to receive no damage from quests they "\
	+ "participate in.")

# Overrides
func _get_damage_received_modifier(quest:QuestData) -> float: # Effect any incoming damage JUST to this hero?
	var rand = randi_range(1,4)
	if rand == 4:
		return 0.0 # 25% chance to take no damage from a quest
	else:
		return 1.0
