# quest_location.gd
extends Resource
class_name QuestLocation

# Parameters
var location_name : String
var location_tags : Array

# Constructor
func _init(_name:String, _tags:Array[String]):
	location_name = _name
	location_tags = _tags

# Serialize/Deserialize
func serialize():
	return {
		"location_name":location_name,
		"location_tags":location_tags
	}
func deserialize(data):
	location_name = data["location_name"]
	location_tags = data["location_tags"]
