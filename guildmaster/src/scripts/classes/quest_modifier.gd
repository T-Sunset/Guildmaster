# quest_modifier.gd
extends Resource
class_name QuestModifier

# Parameters
var quest_mod_name : String 
var quest_mod_difficulty : float = 1.0
var quest_mod_timer : float = 1.0
var quest_mod_gold_reward : float = 1.0
var quest_mod_influence_reward : float = 1.0
var quest_mod_tags : Array

# Constructor
func _init(_name:String, _tags:Array[String], _difficulty:float=1.0, _timer:float=1.0, \
_reward:float=1.0, _influence:float=1.0):
	quest_mod_name = _name
	quest_mod_tags = _tags
	quest_mod_difficulty = _difficulty
	quest_mod_timer = _timer
	quest_mod_gold_reward = _reward
	quest_mod_influence_reward = _influence

# Serialize/Deserialize
func serialize():
	return {
		"quest_mod_name":quest_mod_name,
		"quest_mod_difficulty":quest_mod_difficulty,
		"quest_mod_timer":quest_mod_timer,
		"quest_mod_gold_reward":quest_mod_gold_reward,
		"quest_mod_influence_reward":quest_mod_influence_reward,
		"quest_mod_tags":quest_mod_tags
	}
func deserialize(data):
	quest_mod_name = data["quest_mod_name"]
	quest_mod_difficulty = data["quest_mod_difficulty"]
	quest_mod_timer = data["quest_mod_timer"]
	quest_mod_gold_reward = data["quest_mod_gold_reward"]
	quest_mod_influence_reward = data["quest_mod_influence_reward"]
	quest_mod_tags = data["quest_mod_tags"]
