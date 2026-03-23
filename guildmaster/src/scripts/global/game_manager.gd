# game_manager.gd
extends Node
# class_name GameManager 

# Components
var world_timer
var now

# Parameters -- Core 
var gold : int = 500
var influence: int = 0
var time_since_last_save : int = Defs.AUTOSAVE_TIMER
var login_streak : int = 0
var daily_login_timestamp
var seen_streak_reward : bool = false
var daily_login_reward : LoginReward
var hero_uid : int = 0
var quest_uid : int = 0
var effect_uid : int = 0

# Signals 
signal gold_changed 
signal influence_changed
signal world_tick

# Debug Input Handling
#func _process(delta: float) -> void:
	#if Input.is_action_pressed("debug_addgold"):
		#add_gold(10)

# Load game on run
func _ready() -> void:
	# SaveManager.wipe_save()
	SaveManager.load_game()
	emit_world_timer()

# Functions
# Set World Timer
func set_world_timer(obj):
	world_timer = obj
	world_timer.timeout.connect(emit_world_timer)
func emit_world_timer():
	now = Time.get_unix_time_from_system()
	time_since_last_save -= 1
	if (time_since_last_save <= 0):
		SaveManager.save_game()
		time_since_last_save = Defs.AUTOSAVE_TIMER
	world_tick.emit()
	
	# Check daily login
	if daily_login_timestamp == null:
		get_daily_login_reward()
	elif abs(now - daily_login_timestamp) > 86400:
		get_daily_login_reward()
	elif abs(now - daily_login_timestamp) > 172800:
		login_streak = 0
	
# Convert seconds to time string
func convert_seconds_to_time_string(time:int):
	var hours = int(time / 3600)
	var remaining_time = int(time % 3600)
	var minutes = int(remaining_time / 60)
	remaining_time = int(remaining_time % 60)
	var seconds = remaining_time
	var result = ""
	if hours > 0:
		result += "{0}h ".format([hours])
	if minutes > 0:
		result += "{0}m ".format([minutes])
	if seconds > 0:
		result += "{0}s".format([seconds])
	return result

# Get daily login reward
func get_daily_login_reward():
	# Set unseen and timestamp
	daily_login_timestamp = now
	seen_streak_reward = false
	
	# Set reward
	login_streak += 1
	var reward_type : LoginReward.RewardType = LoginReward.RewardType.GOLD
	for i in range(login_streak - 1):
		if reward_type == LoginReward.RewardType.GOLD:
			reward_type = LoginReward.RewardType.INFLUENCE
			continue
		elif reward_type == LoginReward.RewardType.INFLUENCE:
			reward_type = LoginReward.RewardType.HERO
			continue
		else:
			reward_type = LoginReward.RewardType.GOLD
			continue
	daily_login_reward = Defs.get_reward_by_type(reward_type)

# Add gold 
func add_gold(amount):
	gold += amount 
	gold_changed.emit()
# Add Influence 
func add_influence(amount):
	influence += amount
	influence_changed.emit()

# Spend gold 
func spend_gold(amount):
	if gold >= amount:
		gold -= amount
		gold_changed.emit()
		return true 
	else:
		return false
# Spend Influence 
func spend_influence(amount):
	if influence >= amount:
		influence -= amount 
		influence_changed.emit()
		return true 
	else:
		return false

# Get Save Data
func get_save_data():
	return {
		"version":Defs.VERSION_NUMBER,
		"gold":gold,
		"influence":influence,
		"heroUID":hero_uid,
		"questUID":quest_uid,
		"login_streak":login_streak,
		"daily_login_timestamp":daily_login_timestamp,
		"daily_login_reward":daily_login_reward.reward_type,
		"seen_streak_reward":seen_streak_reward,
		"heroes":HeroManager.serialize(),
		"quests":QuestManager.serialize(),
		"facilities":GuildManager.serialize()
	}

# Load save data
func load_save_data(data):
	# Apply data
	gold = data["gold"]
	influence = data["influence"]
	hero_uid = data["heroUID"]
	quest_uid = data["questUID"]
	if data.has("login_streak"):
		login_streak = data["login_streak"]
		daily_login_timestamp = data["daily_login_timestamp"]
		seen_streak_reward = data["seen_streak_reward"]
		daily_login_reward = Defs.get_reward_by_type(data["daily_login_reward"] as LoginReward.RewardType)
	gold_changed.emit()
	influence_changed.emit()
	
	HeroManager.deserialize(data["heroes"])
	QuestManager.deserialize(data["quests"])
	if data.has("facilities"):
		GuildManager.deserialize(data["facilities"])

# Handle game closing / pausing / etc
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			SaveManager.save_game()
		NOTIFICATION_APPLICATION_PAUSED:
			SaveManager.save_game()

# Get unique IDs
func get_hero_uid() -> int:
	var val = hero_uid
	hero_uid += 1
	return val
func get_quest_uid() -> int:
	var val = quest_uid
	quest_uid += 1
	return val
func get_effect_uid() -> int:
	var val = effect_uid
	effect_uid += 1
	return val
