# quest_target.gd
extends Resource
class_name QuestTarget

# Parameters
var target_name : String
var target_tags : Array
var target_context : Defs.QuestContexts

# Constructor
func _init(_name:String, _tags:Array[String], _context:Defs.QuestContexts):
	target_name = _name
	target_tags = _tags
	target_context = _context

# Serialize/Deserialize
func serialize():
	return {
		"target_name":target_name,
		"target_tags":target_tags,
		"target_context":target_context
	}
func deserialize(data):
	target_name = data["target_name"]
	target_tags = data["target_tags"]
	target_context = data["target_context"] as Defs.QuestContexts
