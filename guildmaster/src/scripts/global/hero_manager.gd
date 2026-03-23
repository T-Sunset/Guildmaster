# hero_manager.gd
extends Node
# class_name HeroManager

# Signals
signal roster_updated

# Parameters 
var roster : Array[HeroData] = []
var recruitable_roster : Array[HeroData] = []
var next_refresh
var last_regen_timestamp
var last_tavern_regen_timestamp
var last_tavern_regen_step : int = 0

# Start
func _ready():
	GameManager.world_tick.connect(on_world_tick)

# Functions 
# Add Hero to the Roster 
func add_hero(hero: HeroData):
	# Reject if we're full
	if not has_room_in_roster():
		return false
	# Otherwise, proceed 
	roster.append(hero)
	roster_updated.emit()
	return true 
# Remove a Hero from the roster 
func remove_hero(hero:HeroData):
	if hero in roster:
		roster.erase(hero)
		roster_updated.emit()
# Get hero by UID
func get_hero_by_uid(_id:int):
	for hero in roster:
		if hero.hero_uid == _id:
			return hero
	return null

# Have we got room in the roster?
func has_room_in_roster() -> bool:
	return roster.size() < GuildManager.get_max_roster_size()

# Generate a new hero
func generate_hero(rand_level:bool = false, set_rarity : Rarity = null):
	# Get hero information
	var new_name = Defs.NAMES.pick_random()
	var new_class = Defs.CLASSES.pick_random()
	var new_rarity
	if set_rarity == null: new_rarity = Defs.roll_rarity()
	else: new_rarity = set_rarity
	var new_stats = roll_base_stats(new_rarity)
	var hero = HeroData.new(new_name,new_class,new_stats,new_rarity)
	if rand_level:
		var level = randi_range(1,get_lowest_hero_lv())
		if level > 1:
			for lv in range(level):
				hero.level_up()
	var valid = []
	for key in Defs.EFFECTS.keys():
		if Defs.EFFECTS[key]["category"] == "trait":
			valid.append(key)
	for i in range(new_rarity.rarity_trait_count):
		var e = valid.pick_random()
		hero.add_effect(Defs.EFFECTS[e])
	return hero

# Refresh the recruitment list
func refresh_heroes():
	# Do nothing if GameManager isn't set up yet.
	if GameManager.now == null:
		return
		
	# Set next refresh
	next_refresh = GameManager.now + 3600
	
	# Reset roster
	recruitable_roster = []
	for i in range(GuildManager.get_recruitable_roster_size()):
		var hero = generate_hero(true)
		recruitable_roster.append(hero)
	print("Heroes generated")

# Base Hero Stat Rolls
func roll_base_stats(rarity:Rarity) -> Dictionary[Defs.Stats,int] :
	var result : Dictionary[Defs.Stats,int] 
	for stat in Defs.Stats.values():
		result.set(stat, int((randi_range(Defs.MINIMUM_BASE_STAT,Defs.MAXIMUM_BASE_STAT) * 
		rarity.rarity_modifier)))
	return result

# Generate Hero gold cost from their stats 
func calculate_hero_cost(hero:HeroData):
	var aptitude_total = (hero.hero_stats[Defs.Stats.STRENGTH] +
	hero.hero_stats[Defs.Stats.INTELLIGENCE] + hero.hero_stats[Defs.Stats.DEXTERITY])
	return Defs.BASE_HERO_COST + (aptitude_total * 10)

# Get our highest hero level
func get_highest_hero_lv():
	var v = 1
	for hero in roster:
		if hero.get_total_level() > v:
			v = hero.get_total_level()
	return v
# Get our lowest hero level
func get_lowest_hero_lv():
	var v = 1201
	for hero in roster:
		if hero.get_total_level() < v:
			v = hero.get_total_level()
	if len(roster) <= 0:
		return 1
	else:
		return v
# Get average hero level
func get_average_hero_lv():
	if len(roster) <= 0:
		return 1
	else:
		var levels = []
		for hero in roster:
			levels.append(hero.get_total_level())
		var result = 0
		for lv in levels:
			result += lv
		result = (result / len(levels))
		return result

# Process hero upkeep and check for fresh recruits
func on_world_tick():
	check_hero_refresh()
	regen_resting_heroes()
func check_hero_refresh():
	if next_refresh == null or GameManager.now > next_refresh:
		refresh_heroes()
func regen_resting_heroes():
	if last_regen_timestamp != null and last_tavern_regen_timestamp != null:
		for hero in roster:
			if hero.hero_state == Defs.HeroStates.RESTING:
				for i in range(abs(GameManager.now - last_regen_timestamp)):
					hero.regenerate()
			elif hero.hero_state == Defs.HeroStates.IDLE and \
			GuildManager.get_idle_regen_bool():
				for i in range(abs(GameManager.now - last_tavern_regen_timestamp)):
					last_tavern_regen_step += 1
					if last_tavern_regen_step >= GuildManager.get_idle_regen_step():
						hero.regenerate()
						last_tavern_regen_step = 0
				
	last_regen_timestamp = GameManager.now
	last_tavern_regen_timestamp = GameManager.now

# Serialize / Deserialize
func serialize():
	var hero_data = []
	for hero in roster:
		hero_data.append(hero.serialize())
	var recruitable_data = []
	for hero in recruitable_roster:
		recruitable_data.append(hero.serialize())
	return {
		"hero_data":hero_data,
		"recruitable_data":recruitable_data,
		"next_refresh":next_refresh,
		"last_regen_timestamp":last_regen_timestamp,
		"last_tavern_regen_timestamp":last_tavern_regen_timestamp
	}
func deserialize(data):
	if data.has("next_refresh"):
		next_refresh = data["next_refresh"]
	if data.has("last_regen_timestamp"):
		last_regen_timestamp = data["last_regen_timestamp"]
	if data.has("last_tavern_regen_timestamp"):
		last_tavern_regen_timestamp = data["last_tavern_regen_timestamp"]
	roster.clear()
	recruitable_roster.clear()
	for hero_data in data["hero_data"]:
		var hero = HeroData.new("default", Defs.CLASSES.pick_random(), {}, Defs.RARITIES.pick_random())
		hero.deserialize(hero_data)
		roster.append(hero)
	if data.has("recruitable_data"):
		for hero_data in data["recruitable_data"]:
			var hero = HeroData.new("default", Defs.CLASSES.pick_random(), {}, Defs.RARITIES.pick_random())
			hero.deserialize(hero_data)
			recruitable_roster.append(hero)
