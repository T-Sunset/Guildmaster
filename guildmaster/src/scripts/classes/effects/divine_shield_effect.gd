# NAME.GD
extends Effect
class_name DivineShieldEffect

# Constructor
func _init():
	super("Divine Shield", "This hero has a 10% chance to nullify all damage dealt by quests " + \
	"they participate in, to themselves and all party members.")

# Overrides
func _get_quest_damage_dealt_modifier(quest:QuestData) -> float: #Does this effect modify the quest's damage?
	var rand = randi_range(1,10)
	if rand == 10:
		return 0.0 # 10% chance to nullify all quest damage.
	else:
		return 1.0
