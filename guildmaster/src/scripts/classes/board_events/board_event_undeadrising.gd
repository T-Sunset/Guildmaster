# NAME.GD
extends Effect
class_name BoardEventUndeadRising

# Constructor
func _init():
	super("Undead Rising!", "The dead walk again.\nAll quests will feature undead.\n+15% EXP gained per quest.")

# Overrides
func _quest_tag_additions(quest:QuestData) -> Array[String]:
	return ["undead"]
func _get_quest_exp_reward_modifier(quest:QuestData) -> float:
	return 1.15
