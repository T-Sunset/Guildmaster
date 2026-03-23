# effect.gd
extends Resource
class_name Effect

# Parameters
var effect_name : String
var effect_uid : int
var effect_description : String
# var effect_icon 
var effect_level : int = 1
var effect_hero : HeroData
var effect_is_trait : bool = false

# Constructor
func _init(_name:String, _desc:String, _is_trait:bool = false):
	effect_name = _name
	effect_description = _desc
	effect_is_trait = _is_trait
	effect_uid = GameManager.get_effect_uid()

# Static Function (factory)
static func create(effect_def: Dictionary, owner):
	var effect = effect_def["type"].new()
	effect.effect_hero = owner
	
	if effect_def.has("params"):
		effect.setup(effect_def["params"])
	
	return effect
func setup(params: Dictionary):
	# override in subclasses if needed
	pass

# Functions
func set_hero(h:HeroData): effect_hero = h
func get_effect_name():
	var result = effect_name
	match effect_level:
		1: result += " I"
		2: result += " II"
		3: result += " III"
		4: result += " IV"
		5: result += " V"
		_: result += ""
	return result
func level_up():
	if effect_level < Defs.MAX_EFFECT_LEVEL:
		effect_level += 1

# Triggers
func _get_stat_modifier(stat:Defs.Stats) -> float: # Does this effect modify this hero's stat(s) at all?
	return 1.0
func _get_stat_bonus(stat:Defs.Stats) -> int:
	return 0
func _get_base_regeneration() -> int:
	return 0
func _get_regeneration_modifier() -> float:
	return 1.0
func _get_damage_received_modifier(quest:QuestData) -> float: # Effect any incoming damage JUST to this hero?
	return 1.0
func _get_damage_received_bonus(quest:QuestData) -> int:
	return 0
func _get_aptitude_modifier(quest:QuestData) -> float: # Does this effect modify this hero's output aptitude
	# for a given quest at all?
	return 1.0
func _get_aptitude_bonus(quest:QuestData) -> int:
	return 0
func _get_quest_damage_dealt_modifier(quest:QuestData) -> float: #Does this effect modify the quest's damage?
	return 1.0
func _get_quest_damage_dealt_bonus(quest:QuestData) -> int:
	return 0
func _get_quest_duration_modifier(quest:QuestData) -> float: # Effect add or reduce speed?
	return 1.0
func _get_quest_speed_bonus(quest:QuestData) -> int:
	return 0
func _get_quest_gold_reward_modifier(quest:QuestData) -> float:
	return 1.0
func _get_quest_exp_reward_modifier(quest:QuestData) -> float:
	return 1.0
func _get_quest_lower_variance_modifier(quest:QuestData) -> float:
	return 1.0
func _get_quest_lower_variance_bonus(quest:QuestData) -> int:
	return 0
func _get_quest_upper_variance_modifier(quest:QuestData) -> float:
	return 1.0
func _get_quest_upper_variance_bonus(quest:QuestData) -> int:
	return 0
func _quest_complete_event(quest:QuestData):
	pass
func _rarity_find_rate_mod(rarity:Rarity) -> float:
	return -1.0
func _quest_tag_additions(quest:QuestData) -> Array[String]:
	return []

func serialize():
	return {
		"type":effect_name,
	} 
