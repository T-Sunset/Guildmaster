# NAME.GD
extends Effect
class_name GuardianEffect

# Constructor
func _init():
	super("Guardian", "This hero reduces the damage that quests they participate in " + \
	"deal to themselves and all allies by 33%.")

# Overrides
func _get_quest_damage_dealt_modifier(quest:QuestData) -> float: #Does this effect modify the quest's damage?
	return 0.66 # 33% reduction
