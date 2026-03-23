# quest_data.gd
extends Resource
class_name QuestData

# Parameters 
var quest_uid : int
var quest_name : String
var quest_action : QuestAction
var quest_target : QuestTarget
var quest_location : QuestLocation
var quest_max_party_size: int
var quest_party : Array[HeroData]
var quest_difficulty : int
var quest_duration : int # (In seconds)
var quest_start_time # Timestamp
var quest_end_time # Timestamp
var quest_ended : bool = false
var quest_gold_reward : int 
var quest_rarity : Rarity
var quest_modifier : QuestModifier
var quest_result_string : String

# Constructor
func _init(_name:String,_action:QuestAction, _target:QuestTarget,_location:QuestLocation, _partysize:int, \
 _difficulty:int,_dur:int,_reward:int,_rarity:Rarity,_mod:QuestModifier = null):
	quest_uid = GameManager.get_quest_uid()
	# Set rarity 
	quest_rarity = _rarity
	
	# Set values 
	quest_name = _name
	quest_action = _action
	quest_target = _target
	quest_location = _location
	quest_max_party_size = _partysize
	quest_difficulty = apply_rarity_to_value(_difficulty)
	quest_duration = apply_rarity_to_value(_dur)
	quest_gold_reward = apply_rarity_to_value(_reward)
	
	# Modifier
	if _mod != null:
		quest_modifier = _mod
		apply_modifier(_mod)
	
	# Apply facility bonus
	# quest_gold_reward = int(float(quest_gold_reward) * GuildManager.get_quest_gold_reward_mod())

# Apply rarity to a value
func apply_rarity_to_value(val:int) -> int:
	var result = float(val)
	result = result * quest_rarity.rarity_modifier
	return int(result)

# Apply a modifier
func apply_modifier(mod:QuestModifier):
	quest_difficulty = int(float(quest_difficulty) * mod.quest_mod_difficulty)
	quest_duration = int(float(quest_duration) * mod.quest_mod_timer)
	quest_gold_reward = int(float(quest_gold_reward) * mod.quest_mod_gold_reward)

# Add a hero to this quest
func add_hero(hero:HeroData):
	if hero not in quest_party and len(quest_party) < Defs.QUEST_MAX_PARTY_SIZE:
		quest_party.append(hero)
		return true
	else: 
		return false
func remove_hero(hero:HeroData):
	if hero in quest_party:
		quest_party.erase(hero)
		return true
	else:
		return false

# Return base aptitude
func base_aptitude_from_hero(hero:HeroData) -> int:
	var result = 0
	if quest_action.action_stats.has(Defs.Stats.STRENGTH):
		result += int(float(hero.get_stat(Defs.Stats.STRENGTH)) * quest_action.action_stats[Defs.Stats.STRENGTH])
	if quest_action.action_stats.has(Defs.Stats.INTELLIGENCE):
		result += int(float(hero.get_stat(Defs.Stats.INTELLIGENCE)) * quest_action.action_stats[Defs.Stats.INTELLIGENCE])
	if quest_action.action_stats.has(Defs.Stats.DEXTERITY):
		result += int(float(hero.get_stat(Defs.Stats.DEXTERITY)) * quest_action.action_stats[Defs.Stats.DEXTERITY])
	# Get effects
	for effect in hero.hero_effects:
		result = int(float(result) * effect._get_aptitude_modifier(self))
	for effect in hero.hero_effects:
		result += effect._get_aptitude_bonus(self)
	# THEN APPLY APTITUDE MODIFIERS HERE
	return result
func base_party_aptitude() -> int:
	var result = 0
	for hero in quest_party:
		result += base_aptitude_from_hero(hero)
	var ratio = (result / quest_difficulty)
	if ratio > 1.0:
		result = quest_difficulty + int(float(result - quest_difficulty) * Defs.QUEST_APTITUDE_FALLOFF)
	return result

# Return base damage
func base_damage() -> int:
	var damage = int(float(quest_difficulty) * Defs.QUEST_DAMAGE_PER_DIFFICULTY)
	# Effects
	for hero in quest_party:
		for effect in hero.hero_effects:
			damage = int(float(damage) * effect._get_quest_damage_dealt_modifier(self))
	for hero in quest_party:
		for effect in hero.hero_effects:
			damage += effect._get_quest_damage_dealt_bonus(self)
	if GuildManager.daily_event != null: damage = int(float(damage) * GuildManager.daily_event._get_quest_damage_dealt_modifier(self))
	return damage

# Get total party stat
func get_party_stat(stat:Defs.Stats):
	var tally = 0
	for hero in quest_party:
		tally += hero.get_stat(stat)
	return tally

# Get quest difficulty cliff
func get_difficulty_cliff():
	return int(float(quest_difficulty) * Defs.QUEST_DIFFICULTY_CLIFF)
# Get quest max contribution cap for AGI & LUK
func get_max_effective_contribution():
	return int(float(quest_difficulty) * Defs.QUEST_EFFECTIVE_CONTRIBUTION_CAP)

# Get quest duration after agility
func get_extra_speed_from_hero(hero:HeroData):
	if hero == null:
		return 0
	var contribution : int = max(0,hero.get_stat(Defs.Stats.AGILITY) - get_difficulty_cliff())
	for effect in hero.hero_effects:
		contribution += effect._get_quest_speed_bonus(self)
	return min(contribution, get_max_effective_contribution())
func get_extra_speed():
	var result = 0
	for hero in quest_party:
		result += get_extra_speed_from_hero(hero)
	return result
func get_quest_duration():
	var scaled_duration = quest_duration
	for hero in quest_party:
		for effect in hero.hero_effects:
			scaled_duration = int(float(scaled_duration) * effect._get_quest_duration_modifier(self))
	if GuildManager.daily_event != null:
		scaled_duration = int(float(scaled_duration) * GuildManager.daily_event._get_quest_duration_modifier(self))
	return max(0, scaled_duration - get_extra_speed())

# Get quest reward
func get_gold_reward():
	var val = quest_gold_reward
	for hero in quest_party:
		for effect in hero.hero_effects:
			val = int(float(val) * effect._get_quest_gold_reward_modifier(self))
	if GuildManager.daily_event != null: val = int(float(val) * GuildManager.daily_event._get_quest_gold_reward_modifier(self))
	val = int(float(val) * GuildManager.get_quest_gold_reward_mod())
	return val
func get_exp_reward():
	var val = quest_difficulty * Defs.QUEST_EXP_PER_DIFFICULTY
	for hero in quest_party:
		for effect in hero.hero_effects:
			val = int(float(val) * effect._get_quest_exp_reward_modifier(self))
	if GuildManager.daily_event != null: val = int(float(val) * GuildManager.daily_event._get_quest_exp_reward_modifier(self))
	val = int(float(val) * GuildManager.get_quest_exp_reward_mod())
	return val

# Get extra luck
func get_extra_luck_from_hero(hero:HeroData):
	if hero == null:
		return 0
	var contribution : int = max(0,hero.get_stat(Defs.Stats.LUCK) - get_difficulty_cliff())
	return min(contribution, get_max_effective_contribution())
func get_extra_luck():
	var result = 0
	for hero in quest_party:
		result += get_extra_luck_from_hero(hero)
	return result

# Get Tags
func get_tags():
	var result = []
	for tag in quest_action.action_tags:
		if tag not in result:
			result.append(tag)
	for tag in quest_location.location_tags:
		if tag not in result:
			result.append(tag)
	if quest_target != null:
		for tag in quest_target.target_tags:
			if tag not in result:
				result.append(tag)
	if quest_modifier != null:
		for tag in quest_modifier.quest_mod_tags:
			if tag not in result:
				result.append(tag)
	return result

# Serialize / Deserialize
func serialize():
	var result = {
		"quest_name":quest_name,
		"quest_uid":quest_uid,
		"quest_action":quest_action.serialize(),
		"quest_location":quest_location.serialize()
		}
	if quest_target != null:
		result.merge({"quest_target":quest_target.serialize()})
	result.merge({
		"quest_max_party_size":quest_max_party_size
	})
	if len(quest_party) > 0:
		var party = []
		for hero in quest_party:
			party.append(HeroManager.roster.find(hero))
		result.merge({"quest_party":party})
	else:
		result.merge({"quest_party":[]})
	result.merge({
		"quest_difficulty":quest_difficulty,
		"quest_duration":quest_duration,
		"quest_start_time":quest_start_time,
		"quest_end_time":quest_end_time,
		"quest_ended":quest_ended,
		"quest_gold_reward":quest_gold_reward,
		"quest_rarity":quest_rarity.rarity_name,
		"quest_result_string":quest_result_string
	})
	if quest_modifier != null:
		result.merge({"quest_modifier":quest_modifier.serialize()})
	
	return result
func deserialize(data):
	quest_name = data["quest_name"]
	quest_uid = data["quest_uid"]
	var action = QuestAction.new("",{},[],Defs.QuestContexts.NEUTRAL)
	action.deserialize(data["quest_action"])
	quest_action = action
	var location = QuestLocation.new("",[])
	location.deserialize(data["quest_location"])
	quest_location = location
	if data.has("quest_target"):
		var target = QuestTarget.new("",[],Defs.QuestContexts.NEUTRAL)
		target.deserialize(data["quest_target"])
		quest_target = target
	else:
		quest_target = null
	quest_max_party_size = data["quest_max_party_size"]
	if len(data["quest_party"]) > 0:
		for val in data["quest_party"]:
			quest_party.append(HeroManager.roster[val])
	quest_difficulty = data["quest_difficulty"]
	quest_duration = data["quest_duration"]
	quest_start_time = data["quest_start_time"]
	quest_end_time = data["quest_end_time"]
	quest_ended = data["quest_ended"]
	quest_gold_reward = data["quest_gold_reward"]
	quest_rarity = Defs.get_rarity_by_name(data["quest_rarity"])
	quest_result_string = data["quest_result_string"]
	if data.has("quest_modifier"):
		var mod = QuestModifier.new("",[],0.0,0.0,0.0,0.0)
		mod.deserialize(data["quest_modifier"])
		quest_modifier = mod
	else:
		quest_modifier = null
