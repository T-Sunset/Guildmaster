# quest_action.gd
extends Resource
class_name QuestAction

# Parameters
var action_name : String
var action_stats : Dictionary[Defs.Stats, float]
var action_tags : Array
var action_context : Defs.QuestContexts

# Constructor
func _init(_name:String, _stats:Dictionary[Defs.Stats,float], _tags:Array[String],\
_context:Defs.QuestContexts):
	action_name = _name
	action_stats = _stats
	action_tags = _tags
	action_context = _context

# Serialize/Deserialize
func serialize():
	return {
		"action_name":action_name,
		"action_tags":action_tags,
		"action_context":action_context,
		"action_stats":action_stats
	}
func deserialize(data):
	action_name = data["action_name"]
	action_context = data["action_context"] as Defs.QuestContexts
	action_tags = data["action_tags"]
	for stat in data["action_stats"]:
		action_stats.set(stat as Defs.Stats, data["action_stats"][stat])
