# NAME.GD
extends Effect
class_name DisciplineEffect

# Constructor
func _init():
	super("Discipline","This hero receives -33% damage from quests.")

# Overrides
func _get_damage_received_modifier(quest:QuestData) -> float: # Effect any incoming damage JUST to this hero?
	return 0.66 # 33% reduction
