# NAME.GD
extends Effect
class_name BoardEventMonsterSurge

# Constructor
func _init():
	super("Monster Surge", "The fiends grow restless.\n+30% Quest damage dealt.\n+50% Quest gold and EXP rewards.")

# Overrides
func _get_quest_damage_dealt_modifier(quest:QuestData) -> float: #Does this effect modify the quest's damage?
	return 1.5
func _get_quest_gold_reward_modifier(quest:QuestData) -> float:
	return 1.5
func _get_quest_exp_reward_modifier(quest:QuestData) -> float:
	return 1.5
