# quest_manager.gd
extends Node

# Signals
signal quest_list_refreshed

# Parameters 
var quest_list : Array[QuestData] 
var active_quests : Array[QuestData]
var next_refresh

# Functions
# Start 
func _ready():
	GameManager.world_tick.connect(on_world_tick)
	# refresh_quests()

# Generate a new quest
func generate_quest():
	# Get quest context 
	var r = randi_range(0,2)
	var context = null
	if r == 0:
		context = Defs.QuestContexts.AGGRESSIVE
	elif r == 1:
		context = Defs.QuestContexts.NEUTRAL
	else:
		context = Defs.QuestContexts.SUPPORTIVE
	
	# Get Action, Target and Location
	var action : QuestAction = Defs.get_quest_actions_of_context(context).pick_random()
	var target : QuestTarget = null
	if (context != Defs.QuestContexts.NEUTRAL):
		target = Defs.get_quest_targets_of_context(context).pick_random()
	var location : QuestLocation = Defs.QUEST_LOCATIONS.pick_random()
	
	# Name the quest 
	var q_name = ""
	if (context != Defs.QuestContexts.NEUTRAL):
		q_name = action.action_name + " the " + target.target_name + " in the " + location.location_name
	else:
		q_name = action.action_name + " the " + location.location_name
	
	# Get quest tags
	var tags : Array[String] = []
	for tag in action.action_tags:
		if tag not in tags:
			tags.append(tag)
	if (context != Defs.QuestContexts.NEUTRAL):
		for tag in target.target_tags:
			if tag not in tags:
				tags.append(tag)
	for tag in location.location_tags:
		if tag not in tags:
			tags.append(tag)
	
	# Get quest difficulty 
	var lower_limit = HeroManager.get_average_hero_lv() - Defs.LOWER_QUEST_LEVEL_LIMIT
	print(str(lower_limit) + " - Lower Limit")
	var upper_limit = HeroManager.get_average_hero_lv() + Defs.UPPER_QUEST_LEVEL_LIMIT
	print(str(upper_limit) + " - Upper Limit")
	if lower_limit < 1:
		lower_limit = 1
	var difficulty = randi_range(lower_limit,upper_limit) * Defs.QUEST_DIFFICULTY_PER_LEVEL
	print("New quest difficulty: " + str(difficulty))
	
	# Quest Duration
	var duration = difficulty * Defs.QUEST_DURATION_PER_DIFFICULTY
	
	# Quest Rewards 
	var reward = difficulty * randi_range(Defs.QUEST_REWARD_LOWER_RANGE_PER_DIFFICULTY,\
	Defs.QUEST_REWARD_UPPER_RANGE_PER_DIFFICULTY)
	
	# Quest Modifier 
	var modifier : QuestModifier = null
	if randf() < Defs.QUEST_MODIFIER_CHANCE:
		modifier = Defs.QUEST_MODIFIERS.pick_random()
	if modifier != null:
		q_name += " (" + modifier.quest_mod_name + "!)"
	
	# Quest Rarity 
	var rarity = Defs.roll_rarity()
	
	# Create quest 
	return QuestData.new(q_name,action,target,location,Defs.QUEST_MAX_PARTY_SIZE,difficulty,duration,\
	reward,rarity,modifier)

# Refresh available quest list
func refresh_quests():
	# Do nothing if GameManager isn't set up yet.
	if GameManager.now == null:
		return
		
	# Set next refresh
	next_refresh = GameManager.now + 3600
	
	# Reset quest list
	quest_list = []
	for i in range(GuildManager.get_quest_refresh_size()):
		quest_list.append(generate_quest())
	print("Quests generated.")
	quest_list_refreshed.emit()

# Resolve a quest
func resolve_quest(quest : QuestData):
	# Print Debug
	print("Resolving quest " + quest.quest_name)
	
	# End the quest
	quest.quest_ended = true
	
	# Unset OnQuest Status and apply experience 
	var xp = quest.get_exp_reward()
	for hero in quest.quest_party:
		hero.change_state(Defs.HeroStates.IDLE)
	
	# Get result
	var quest_result = roll_success(quest)
	var quest_damage_range = get_damage_range(quest)
	var quest_damage = randi_range(quest_damage_range[0], quest_damage_range[1])
	
	# Apply Damage
	for hero in quest.quest_party:
		hero.take_damage(quest_damage)
		hero.hero_quest = null
	
	# Apply result
	if quest_result == Defs.QuestResults.CRIT_SUCCESS:
		GameManager.add_gold(quest.get_gold_reward())
		GameManager.add_influence(2)
		quest.quest_result_string = "Critical Success!\n+" + str(quest.get_gold_reward()) \
		+ "g! +" + str(xp) + "XP! -" + str(quest_damage) + "HP!\nClick to clear!"
		for hero in quest.quest_party:
			hero.receive_exp(xp)
	elif quest_result == Defs.QuestResults.SUCCESS:
		GameManager.add_gold(quest.get_gold_reward())
		GameManager.add_influence(1)
		quest.quest_result_string = "Quest Success!\n+" + str(quest.get_gold_reward()) \
		+ "g! +" + str(xp) + "XP! -" + str(quest_damage) + "HP!\nClick to clear!"
		for hero in quest.quest_party:
			hero.receive_exp(xp)
	elif quest_result == Defs.QuestResults.PARTIAL_SUCCESS:
		quest.quest_result_string = "Quest Partial Success...\n+" + \
		str(int(float(xp) * 0.6)) + "XP! -" + str(quest_damage) \
		+ "hp!\nClick to clear!"
		for hero in quest.quest_party:
			hero.receive_exp(int(float(xp) * 0.6))
	elif quest_result == Defs.QuestResults.FAIL:
		# Apply MORE damage
		for hero in quest.quest_party:
			hero.take_damage(quest_damage/2)
		quest.quest_result_string = "Quest Failure...\n" + "-" + str(quest_damage * 1.5) \
		+ "hp!\nClick to clear!"
	
	# Post Quest Events
	for hero in quest.quest_party:
		for effect in hero.hero_effects:
			effect._quest_complete_event(quest)
	
	# Save
	SaveManager.save_game()

# Get aptitude range for a party completing a quest
func get_aptitude_range(quest : QuestData) -> Array[int]:
	var result : Array[int] = []
	var lower = float(quest.base_party_aptitude()) * (1.0 - Defs.QUEST_APTITUDE_VARIANCE)
	lower = int(lower)
	lower += quest.get_extra_luck()
	for hero in quest.quest_party:
		for effect in hero.hero_effects:
			lower = int(float(lower) * effect._get_quest_lower_variance_modifier(quest))
	for hero in quest.quest_party:
		for effect in hero.hero_effects:
			lower += effect._get_quest_lower_variance_bonus(quest)
	var upper = float(quest.base_party_aptitude()) * (1.0 + Defs.QUEST_APTITUDE_VARIANCE)
	upper = int(upper)
	for hero in quest.quest_party:
		for effect in hero.hero_effects:
			upper = int(float(upper) * effect._get_quest_upper_variance_modifier(quest))
	for hero in quest.quest_party:
		for effect in hero.hero_effects:
			upper += effect._get_quest_upper_variance_bonus(quest)
	lower = min(lower, upper)
	result.append(lower)
	result.append(upper)
	return result
# Min and Max Damage range taken for a party completing a quest
func get_damage_range(quest : QuestData) -> Array[int]:
	var result : Array[int] = []
	var lower = float(quest.base_damage()) * (1.0 - Defs.QUEST_DAMAGE_VARIANCE)
	lower = int(lower)
	var upper = float(quest.base_damage()) * (1.0 + Defs.QUEST_DAMAGE_VARIANCE)
	upper = int(upper)
	upper -= quest.get_extra_luck()
	upper = max(lower,upper)
	result.append(lower)
	result.append(upper)
	return result
# Success chance for a party to complete a quest
func get_success_chance(quest : QuestData):
	# Get range
	var aptitude = get_aptitude_range(quest)
	var max_apt = aptitude[1]
	var min_apt = aptitude[0]
	# Get sure win / loss
	if quest.quest_difficulty > max_apt:
		return 0.0
	elif quest.quest_difficulty < min_apt:
		return 1.0
	
	var chance = float(max_apt - quest.quest_difficulty) / float(max_apt - min_apt)
	chance = clamp(chance, 0, 1)
	return chance
# Does a party succeed at a quest?
func roll_success(quest : QuestData):
	var aptitude_range = get_aptitude_range(quest)
	var max_roll = aptitude_range[1]
	var min_roll = aptitude_range[0]
	var crit_threshold = float(quest.quest_difficulty) * Defs.QUEST_CRIT_THRESHOLD_FACTOR
	var critfail_threshold = float(quest.quest_difficulty) * Defs.QUEST_CRITFAIL_THRESHOLD_FACTOR
	var roll = randf_range(min_roll, max_roll)
	
	# Get result
	if roll >= crit_threshold:
		return Defs.QuestResults.CRIT_SUCCESS
	elif roll >= quest.quest_difficulty:
		return Defs.QuestResults.SUCCESS
	elif roll >= critfail_threshold:
		return Defs.QuestResults.PARTIAL_SUCCESS
	else:
		return Defs.QuestResults.FAIL

# Embark on a Quest!
func embark(quest:QuestData):
	# Set timestamp
	quest.quest_start_time = GameManager.now
	quest.quest_end_time = quest.quest_start_time + quest.get_quest_duration()
	for hero in quest.quest_party:
		hero.change_state(Defs.HeroStates.ONQUEST)
		hero.hero_quest = quest
	
	# Append to active quests
	active_quests.append(quest)
	
	# Remove from quest list
	quest_list.erase(quest)

# On World Tick: Check for new quest list updates and check for quests complete
func on_world_tick():
	check_quests()
	check_quest_refresh()
func check_quests(): # Check if active quests have ticked over to be complete per second
	# Go through active quests
	for quest in active_quests:
		# Are we past them?
		if GameManager.now >= quest.quest_end_time and not quest.quest_ended:
			resolve_quest(quest)
func check_quest_refresh(): # Check if our quest list can refresh per second
	if next_refresh == null:
		refresh_quests()
	elif GameManager.now >= next_refresh:
		refresh_quests()

# Serialize / Deserialize
func serialize():
	var quests = []
	for quest in quest_list:
		quests.append(quest.serialize())
	var activequests = []
	for quest in active_quests:
		activequests.append(quest.serialize())
	return {
		"quest_list":quests,
		"active_quests":activequests,
		"next_refresh":next_refresh
	}
func deserialize(data):
	if data.has("next_refresh"):
		next_refresh = data["next_refresh"]
	
	quest_list.clear()
	active_quests.clear()

	for quest_data in data["quest_list"]:
		var quest = QuestData.new("",Defs.QUEST_ACTIONS.pick_random(),
		Defs.QUEST_TARGETS.pick_random(),Defs.QUEST_LOCATIONS.pick_random(),1,1,1,1,
		Defs.RARITIES.pick_random())

		quest.deserialize(quest_data)
		quest_list.append(quest)

	for quest_data in data["active_quests"]:
		var quest = QuestData.new("",Defs.QUEST_ACTIONS.pick_random(),
		Defs.QUEST_TARGETS.pick_random(),Defs.QUEST_LOCATIONS.pick_random(),1,1,1,1,
		Defs.RARITIES.pick_random())

		quest.deserialize(quest_data)
		active_quests.append(quest)
