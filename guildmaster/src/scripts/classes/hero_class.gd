# hero_class.gd
extends Resource
class_name HeroClass

# Parameters
var hc_name : Array[String]
var hc_stat_growths : Dictionary[Defs.Stats, int]
var hc_milestones : Dictionary[int, String]

# Constructor 
func _init(_name:Array[String], _growths:Dictionary[Defs.Stats, int], _milestones:Dictionary[int,String]):
	hc_name = _name
	hc_stat_growths = _growths
	hc_milestones = _milestones

# Functions
# Get the name of our current "form" of this class
func get_current_promotion_name(hero_level:int):
	for i in range(hc_name.size()):
		if hero_level <= Defs.LEVEL_THRESHOLDS[i]:
			return hc_name[i]
