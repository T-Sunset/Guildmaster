# facility_data.gd
extends Resource
class_name FacilityData

# Parameters
var facility_name : String
var facility_description : String
var facility_level : int
var facility_cost_per_level : int
var facility_max_level : int 

# Constructor
func _init(_name:String, _desc:String, _cost:int, _start_level:int, _max_level:int = -1):
	facility_name = _name
	facility_description = _desc
	facility_level = _start_level
	facility_cost_per_level = _cost
	facility_max_level = _max_level

# Get cost
func get_cost(_from_level:int):
	return max(facility_cost_per_level, int(float(facility_cost_per_level) * pow(1.65, float(_from_level))))

# Level Up
func can_level_up(_from_level:int):
	if (_from_level + 1) <= facility_max_level or facility_max_level == -1:
		return true
	else:
		return false
