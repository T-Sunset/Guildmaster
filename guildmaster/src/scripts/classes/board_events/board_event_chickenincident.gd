# NAME.GD
extends Effect
class_name BoardEventChickenIncident

# Constructor
func _init():
	super("The Chicken Incident", "Don't ask.\nSmall chance quests will instantly finish today.")

# Overrides
func _get_quest_speed_bonus(quest:QuestData) -> int:
	var rand = randi_range(1,4)
	if rand == 4:
		return 9999999 # 25% chance to instantly complete the quest
	else:
		return 0
