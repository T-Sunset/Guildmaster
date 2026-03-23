# hero_data.gd
extends Resource
class_name HeroData

# Parameters
var hero_uid : int
var hero_name : String 
var hero_class : HeroClass 
var hero_levels : Dictionary[HeroClass, int]
var hero_stats : Dictionary[Defs.Stats, int]
var hero_rarity : Rarity
var hero_quest : QuestData

var hero_cur_hp : int 
var hero_cur_exp: int 

var hero_state : Defs.HeroStates = Defs.HeroStates.IDLE

var hero_effects : Array[Effect] = []

# Constructor 
func _init(_name:String, _class:HeroClass, _stats:Dictionary[Defs.Stats,int], _rarity:Rarity):
	# Set values 
	hero_uid = GameManager.get_hero_uid()
	hero_name = _name
	hero_class = _class 
	hero_stats = _stats
	hero_rarity = _rarity
	if _stats != {}:
		hero_cur_hp = get_max_hp()
	hero_state = Defs.HeroStates.IDLE
	
	# Initialise hero levels dict (all classes level to 0)
	for hc in Defs.CLASSES:
		hero_levels.set(hc, 0)
	hero_levels[hero_class] = 1

# Functions 
func get_max_hp():
	return Defs.BASE_HEALTH + (get_stat(Defs.Stats.ENDURANCE) * 5)
func get_max_exp():
	return get_total_level() * Defs.EXP_REQ_PER_LEVEL
func get_total_level():
	var result = 1
	for hc in hero_levels.keys():
		if hero_levels[hc] > 1:
			result += (hero_levels[hc]-1)
	return result
func change_state(_state:Defs.HeroStates):
	hero_state = _state
func take_damage(damage:int):
	var dmg = damage
	for effect in hero_effects:
		dmg = int(float(dmg) * effect._get_damage_received_modifier(hero_quest))
	for effect in hero_effects:
		dmg += effect._get_damage_received_bonus(hero_quest)
	if dmg < 0:
		dmg = 0
	hero_cur_hp -= dmg
	if hero_cur_hp <= 0:
		hero_cur_hp = 0
		change_state(Defs.HeroStates.RESTING)
func heal(amt:int):
	hero_cur_hp += amt
	if hero_cur_hp > get_max_hp():
		hero_cur_hp = get_max_hp()
		change_state(Defs.HeroStates.IDLE)
func regenerate():
	var heal_base = 1
	for effect in hero_effects:
		heal_base += effect._get_base_regeneration()
	heal_base = heal_base + int(float(get_stat(Defs.Stats.WILLPOWER)) * 0.1)
	for effect in hero_effects:
		heal_base = int(float(heal_base) * effect._get_regeneration_modifier())
	if hero_state == Defs.HeroStates.RESTING:
		heal(heal_base)
	elif hero_state == Defs.HeroStates.IDLE and GuildManager.get_idle_regen_bool():
		heal(heal_base)
func receive_exp(amt:int):
	for i in range(amt):
		hero_cur_exp += 1
		if hero_cur_exp > get_max_exp():
			level_up()
func level_up():
	# Reset EXP
	hero_cur_exp = 0
	
	# If we CAN level up...
	if hero_levels[hero_class] < GuildManager.get_level_cap():
		# Increment level
		hero_levels[hero_class] += 1
		
		# Increment stats
		for stat in hero_class.hc_stat_growths:
			hero_stats[stat] += hero_class.hc_stat_growths[stat]
		
		# Get a new skill?
		if hero_class.hc_milestones.has(hero_levels[hero_class]):
			add_effect(Defs.get_effect_by_name(hero_class.hc_milestones[hero_levels[hero_class]]))

func add_effect(effect_def:Dictionary):
	var effect = Effect.create(effect_def, self)
	var contained = has_effect_of_type(effect.get_script())
	if not contained:
		hero_effects.append(effect)
		print("Should?")
	else:
		get_effect_of_type(effect.get_script()).level_up()
func has_effect_of_type(script):
	for effect in hero_effects:
		if effect.get_script() == script:
			return true
	return false
func get_effect_of_type(script):
	var result = false
	for effect in hero_effects:
		if effect.get_script() == script:
			return effect
	return null

func get_stat(stat : Defs.Stats):
	var val = hero_stats[stat]
	# Get %Mod
	for effect in hero_effects:
		val = int(float(val) * effect._get_stat_modifier(stat))
	# Add flat val
	for effect in hero_effects:
		val += effect._get_stat_bonus(stat)
	# Event val
	if GuildManager.daily_event != null: val = int(float(val) * GuildManager.daily_event._get_stat_modifier(stat))
	return val
func reclass(c:HeroClass):
	if c == hero_class:
		return false
	else:
		if hero_levels[c] == 0:
			hero_levels[c] = 1
		hero_class = c
		return true

# Serialize/Deserialize
func serialize():
	var effects_serialized = []
	for effect in hero_effects:
		for level in effect.effect_level:
			effects_serialized.append(effect.serialize())
	return {
		"id": hero_uid,
		"hero_name":hero_name,
		"hero_class":hero_class.hc_name[0],
		"hero_levels":serialize_levels(),
		"hero_stats":hero_stats,
		"hero_rarity":hero_rarity.rarity_name,
		"hero_cur_hp":hero_cur_hp,
		"hero_cur_exp":hero_cur_exp,
		"hero_state":hero_state,
		"hero_effects":effects_serialized
	}
func serialize_levels():
	var result = {}
	for hc in hero_levels:
		result.set(hc.hc_name[0], hero_levels[hc])
	return result
func deserialize(data):
	hero_stats.clear()
	hero_levels.clear()
	hero_uid = data["id"]
	hero_name = data["hero_name"]
	hero_class = Defs.get_class_by_name(data["hero_class"])
	for i in data["hero_levels"].keys():
		hero_levels.set(Defs.get_class_by_name(i), int(data["hero_levels"][i]))
	for i in data["hero_stats"].keys():
		var stat = int(i)
		hero_stats[stat] = int(data["hero_stats"][i])
	for i in data["hero_effects"]:
		var effect_id = i["type"]
		var effect_def = Defs.get_effect_by_name(effect_id)
		add_effect(effect_def)
		
	hero_rarity = Defs.get_rarity_by_name(data["hero_rarity"])
	hero_cur_hp = data["hero_cur_hp"]
	hero_cur_exp = data["hero_cur_exp"]
	hero_state = data["hero_state"]
