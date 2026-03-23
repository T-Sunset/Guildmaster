# NAME.GD
extends Effect
class_name GuildFinancierEffect

# Constructor
func _init():
	super("Guild Financier", "This hero doubles all quest rewards for quests they participate in.")

# Overrides
func _get_quest_gold_reward_modifier(quest:QuestData) -> float:
	return 2.0 # Double all quest gold rewards
