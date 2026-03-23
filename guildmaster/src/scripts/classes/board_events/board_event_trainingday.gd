# NAME.GD
extends Effect
class_name BoardEventTrainingDay

# Constructor
func _init():
	super("Training Day", "The guild invests in our heroes.\n+50% EXP gained per quest.")

# Overrides
func _get_quest_exp_reward_modifier(quest:QuestData) -> float:
	return 1.5
