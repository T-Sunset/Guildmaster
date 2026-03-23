# guild_manager.gd
extends Node

# Parameters
var facilities : Dictionary[String, int]
var has_load : bool = false
var daily_login_timestamp
var daily_event : Effect
var seen_event : bool = false

# Functions
func _ready() -> void:
	initialise_facilities()
	GameManager.world_tick.connect(world_tick)

# Initialize facility list
func initialise_facilities():
	if has_load:
		return
	facilities.clear()
	for fac in Defs.FACILITIES:
		facilities.set(fac.facility_name, fac.facility_level)

# Upgrade facility
func upgrade_facility(f:String):
	# Failsafe
	if Defs.get_facility(f).can_level_up(facilities[f]) and \
	GameManager.spend_gold(Defs.get_facility(f).get_cost(facilities[f])):
		facilities[f] += 1

# Get values
func get_max_roster_size():
	return Defs.BASE_ROSTER_SIZE + facilities["Barracks"]
func get_recruitable_roster_size():
	return Defs.BASE_ROSTER_SIZE + facilities["Recruitment Office"]
func get_level_cap():
	return max(Defs.BASE_LEVEL_CAP, Defs.BASE_LEVEL_CAP + (3 * facilities["Training Grounds"]))
func get_quest_refresh_size():
	return Defs.BASE_QUESTS_PER_REFRESH + facilities["Quest Board"]
func get_quest_gold_reward_mod() -> float:
	return max(1.0, 1.0 + (0.1 * float(facilities["Treasury"])))
func get_quest_exp_reward_mod() -> float:
	return max(1.0, 1.0 + (0.1 * float(facilities["Training Grounds"])))
func get_idle_regen_bool() -> bool:
	return facilities["Tavern"] > 0
func get_idle_regen_step() -> int:
	return 30 - (5 * facilities["Tavern"])
func get_can_reclass_bool() -> bool:
	return facilities["Library"] > 0
func get_can_load_daily_events() -> bool:
	return facilities["Notice Board"] > 0

# World tick
func world_tick():
	# Did Update
	var need_new_event = false
	
	# Update, if needed, daily login timestamp
	if daily_login_timestamp == null:
		if get_can_load_daily_events():
			daily_login_timestamp = GameManager.now
			need_new_event = true
	elif abs(GameManager.now - daily_login_timestamp) > 86400:
		if get_can_load_daily_events():
			daily_login_timestamp = GameManager.now
			need_new_event = true
	
	# Reroll world event
	if need_new_event:
		roll_new_daily_event()
func roll_new_daily_event():
	# Set event
	var valid = []
	for key in Defs.EFFECTS.keys():
		if Defs.EFFECTS[key]["category"] == "event":
			valid.append(key)
	var e = valid.pick_random()
	daily_event = Effect.create(Defs.EFFECTS[e], null)
	seen_event = false

# Serialize / Deserialize
func serialize():
	var val = {
		"facilities":facilities,
		"seen_event":seen_event
	}
	if get_can_load_daily_events():
		val.merge({"daily_login_timestamp":daily_login_timestamp})
	if daily_event != null:
		val.merge({"daily_event":daily_event.serialize()})
	return val
func deserialize(data):
	has_load = true
	facilities.clear()
	if data.has("facilities"):
		for entry in data["facilities"].keys():
			facilities.set(entry, int(data["facilities"][entry]))
	if data.has("daily_login_timestamp"):
		if data["daily_login_timestamp"] != null:
			daily_login_timestamp = data["daily_login_timestamp"]
	if data.has("daily_event"):
		daily_event = Effect.create(Defs.get_effect_by_name(data["daily_event"]["type"]), null)
	if data.has("seen_event"):
		seen_event = data["seen_event"]
