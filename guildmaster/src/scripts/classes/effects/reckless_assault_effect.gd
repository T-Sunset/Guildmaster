# NAME.GD
extends Effect
class_name RecklessAssaultEffect

# Constructor
func _init():
	super("Reckless Assault", "This hero contributes 33% more to quests, but takes 33% more damage.")

# Overrides
func _get_aptitude_modifier(quest:QuestData): # Does this effect modify this hero's output aptitude
	# for a given quest at all?
	return 1.3 # 30% increase
func _get_damage_received_modifier(quest:QuestData): # Effect any incoming damage JUST to this hero?
	return 1.3 # 30% increase
