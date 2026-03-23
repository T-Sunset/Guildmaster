# NAME.GD
extends Effect
class_name AssassinationEffect

# Constructor
func _init():
	super("Assassination", "This hero has a 10% chance to instantly complete their assigned " + \
	"quests.")

# Overrides
func _get_quest_speed_bonus(quest:QuestData) -> int:
	var rand = randi_range(1,10)
	if rand == 10:
		return 9999999 # 10% chance to instantly complete the quest
	else:
		return 0
