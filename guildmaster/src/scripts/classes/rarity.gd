# rarity.gd
extends Resource
class_name Rarity 

# Parameters
var rarity_name : String
var rarity_color : Color
var rarity_modifier : float
var rarity_weight : float
var rarity_trait_count : int = 1

# Constructor 
func _init(_name:String, _col:Color, _mod:float, _weight:float, _traits:int = 1):
	rarity_name = _name
	rarity_color = _col 
	rarity_modifier = _mod
	rarity_weight = _weight
	rarity_trait_count = _traits
