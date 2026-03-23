# login_Reward.gd
extends Resource
class_name LoginReward

# Parameters
var reward_name : String
enum RewardType {GOLD, HERO, INFLUENCE}
var reward_type : RewardType = RewardType.GOLD

# Constructor
func _init(_name:String, _type:RewardType):
	# Set values
	reward_name = _name
	reward_type = _type

# Get reward
func get_reward(streak:int):
	if reward_type == RewardType.GOLD:
		return Defs.DAILY_GOLD_REWARD * streak
	elif reward_type == RewardType.HERO:
		if streak <= 2:
			return HeroManager.generate_hero(true, Defs.get_rarity_by_name("Uncommon"))
		elif streak <= 4:
			return HeroManager.generate_hero(true, Defs.get_rarity_by_name("Rare"))
		elif streak <= 6:
			return HeroManager.generate_hero(true, Defs.get_rarity_by_name("Epic"))
		else:
			return HeroManager.generate_hero(true, Defs.get_rarity_by_name("Legendary"))
	else:
		return streak
