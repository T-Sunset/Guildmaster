# defs.gd
extends Node
# class_name Defs

# Universal Definitions 
# Version Number
const VERSION_NUMBER : int = 1

# Stats and Statnames
enum Stats { STRENGTH, ENDURANCE, INTELLIGENCE, WILLPOWER, DEXTERITY, AGILITY, LUCK }
static var STATNAMES : Dictionary[Stats, String] = {
	Stats.STRENGTH:"STR",Stats.ENDURANCE:"END",
	Stats.INTELLIGENCE:"INT",Stats.WILLPOWER:"WIL",
	Stats.DEXTERITY:"DEX",Stats.AGILITY:"AGI",
	Stats.LUCK:"LUK"
}
func get_stat_by_name(statname:String):
	for s in STATNAMES.keys():
		if statname == STATNAMES[s]:
			return s
	return null

# All possible hero states
enum HeroStates { IDLE, ONQUEST, RESTING }

# Rarities 
static var RARITIES : Array[Rarity] = [
	Rarity.new("Common", Color.GRAY, 1.0, 1.0),
	Rarity.new("Uncommon", Color.GREEN, 1.2, 0.4, 2),
	Rarity.new("Rare", Color.BLUE, 1.4, 0.15, 3),
	Rarity.new("Epic", Color.PURPLE, 1.6, 0.05, 4),
	Rarity.new("Legendary", Color.GOLD, 2.0, 0.01, 5)
]
func get_rarity_by_name(rarityname:String):
	for rarity in RARITIES:
		if rarity.rarity_name == rarityname:
			return rarity
	return null

# All hero classes
static var CLASSES : Array[HeroClass] = [
	# BARBARIAN
	HeroClass.new(["Barbarian", "Berserker", "Primal Warrior", "Primal Warlord"], {
		Stats.STRENGTH:3,
		Stats.ENDURANCE:2,
		Stats.INTELLIGENCE:1,
		Stats.WILLPOWER:1,
		Stats.DEXTERITY:1,
		Stats.AGILITY:2,
		Stats.LUCK:1
	}, {
		10:"Berserker Rage",
		20:"Reckless Assault",
		30:"Unstoppable",
		40:"Avatar of War"
	}),
	# FIGHTER
	HeroClass.new(["Fighter", "Knight", "Knight-Captain", "Legionnaire"], {
		Stats.STRENGTH:2,
		Stats.ENDURANCE:3,
		Stats.INTELLIGENCE:1,
		Stats.WILLPOWER:2,
		Stats.DEXTERITY:1,
		Stats.AGILITY:1,
		Stats.LUCK:1
	}, {
		10:"Discipline",
		20:"Veteran",
		30:"Guardian",
		40:"Indomitable"
	}),
	# MAGE
	HeroClass.new(["Mage", "Arcanist", "Sage", "Archmage"], {
		Stats.STRENGTH:1,
		Stats.ENDURANCE:1,
		Stats.INTELLIGENCE:3,
		Stats.WILLPOWER:2,
		Stats.DEXTERITY:1,
		Stats.AGILITY:2,
		Stats.LUCK:1
	}, {
		10:"Arcane Insight",
		20:"Spell Efficiency",
		30:"Mana Surge",
		40:"Archmage"
	}),
	# PRIEST
	HeroClass.new(["Cleric", "Priest", "High Priest", "Divine Channeler"], {
		Stats.STRENGTH:1,
		Stats.ENDURANCE:1,
		Stats.INTELLIGENCE:1,
		Stats.WILLPOWER:3,
		Stats.DEXTERITY:1,
		Stats.AGILITY:2,
		Stats.LUCK:2
	}, {
		10:"Healing Light",
		20:"Divine Favour",
		30:"Restoration",
		40:"Ascension"
	}),
	# ROGUE
	HeroClass.new(["Rogue", "Agent", "Assassin", "Shadowblade"], {
		Stats.STRENGTH:1,
		Stats.ENDURANCE:1,
		Stats.INTELLIGENCE:1,
		Stats.WILLPOWER:1,
		Stats.DEXTERITY:3,
		Stats.AGILITY:2,
		Stats.LUCK:2
	}, {
		10:"Backstab",
		20:"Evasion",
		30:"Shadowstep",
		40:"Assassination"
	}),
	# SCOUT
	HeroClass.new(["Scout", "Strider", "Outrunner", "Windrunner"], {
		Stats.STRENGTH:1,
		Stats.ENDURANCE:2,
		Stats.INTELLIGENCE:1,
		Stats.WILLPOWER:2,
		Stats.DEXTERITY:1,
		Stats.AGILITY:3,
		Stats.LUCK:1
	}, {
		10:"Pathfinder",
		20:"Recon",
		30:"Spy Tactics",
		40:"Windrunner"
	}),
	# MERCHANT
	HeroClass.new(["Scavenger", "Peddler", "Merchant", "Treasure Hunter"], {
		Stats.STRENGTH:1,
		Stats.ENDURANCE:1,
		Stats.INTELLIGENCE:1,
		Stats.WILLPOWER:2,
		Stats.DEXTERITY:1,
		Stats.AGILITY:2,
		Stats.LUCK:3
	}, {
		10:"Scavenger",
		20:"Appraisal",
		30:"Networking",
		40:"Guild Financier"
	}),
	# PALADIN
	HeroClass.new(["Paladin", "Holy Knight", "Inquisitor", "High Inquisitor"], {
		Stats.STRENGTH:2,
		Stats.ENDURANCE:2,
		Stats.INTELLIGENCE:3,
		Stats.WILLPOWER:1,
		Stats.DEXTERITY:1,
		Stats.AGILITY:1,
		Stats.LUCK:1
	}, {
		10:"Bless",
		20:"Fervour",
		30:"Divine Shield",
		40:"Champion of Light"
	}),
	# NECROMANCER
	HeroClass.new(["Dark Priest", "Necromancer", "Warlock", "Gravelord"], {
		Stats.STRENGTH:1,
		Stats.ENDURANCE:1,
		Stats.INTELLIGENCE:3,
		Stats.WILLPOWER:2,
		Stats.DEXTERITY:2,
		Stats.AGILITY:1,
		Stats.LUCK:1
	}, {
		10:"Necromancy",
		20:"Dark Pact",
		30:"Soul Harvest",
		40:"Necromastery"
	}),
	# RANGER
	HeroClass.new(["Ranger", "Hunter", "Stalker", "Sniper"], {
		Stats.STRENGTH:2,
		Stats.ENDURANCE:1,
		Stats.INTELLIGENCE:1,
		Stats.WILLPOWER:1,
		Stats.DEXTERITY:3,
		Stats.AGILITY:2,
		Stats.LUCK:1
	}, {
		10:"Lone Wolf",
		20:"Precision",
		30:"Hunter's Mark",
		40:"Apex Predator"
	})
]
func get_class_by_name(hcname:String):
	for hc in CLASSES:
		if hc.hc_name[0] == hcname:
			return hc
	return null

# Debug names list
const NAMES = ["Alric","Cedric","Marla","Elowen","Borin","Thera","Joric","Lysa"]

# Hero traits list
static var EFFECTS = {
	"Beast Slayer":{"type":TraitBeastSlayerEffect,"category":"trait"},
	"Born to Fight":{"type":TraitBornToFightEffect,"category":"trait"},
	"Demon Slayer":{"type":TraitDemonSlayerEffect,"category":"trait"},
	"Down to Earth":{"type":TraitDownToEarthEffect,"category":"trait"},
	"Drunkard":{"type":TraitDrunkardEffect,"category":"trait"},
	"Eagle-Eyed":{"type":TraitEagleEyedEffect,"category":"trait"},
	"Efficient":{"type":TraitEfficientEffect,"category":"trait"},
	"Explorer":{"type":TraitExplorerEffect,"category":"trait"},
	"Fast Learner":{"type":TraitFastLearnerEffect,"category":"trait"},
	"Focused":{"type":TraitFocusedEffect,"category":"trait"},
	"Greedy":{"type":TraitGreedyEffect,"category":"trait"},
	"Homebody":{"type":TraitHomebodyEffect,"category":"trait"},
	"Humanoid Slayer":{"type":TraitHumanoidSlayerEffect,"category":"trait"},
	"Loner":{"type":TraitLonerEffect,"category":"trait"},
	"Lucky":{"type":TraitLuckyEffect,"category":"trait"},
	"Protective":{"type":TraitProtectiveEffect,"category":"trait"},
	"Reckless":{"type":TraitRecklessEffect,"category":"trait"},
	"Resilient":{"type":TraitResilientEffect,"category":"trait"},
	"Team Player":{"type":TraitTeamPlayerEffect,"category":"trait"},
	"Undead Slayer":{"type":TraitUndeadSlayerEffect,"category":"trait"},
	"Wilds Explorer":{"type":TraitWildsExplorerEffect,"category":"trait"},
	
	"Berserker Rage":{"type":BerserkerRageEffect,"category":"skill"},
	"Reckless Assault":{"type":RecklessAssaultEffect,"category":"skill"},
	"Unstoppable":{"type":UnstoppableEffect,"category":"skill"},
	"Avatar of War":{"type":AvatarOfWarEffect,"category":"skill"},
	"Discipline":{"type":DisciplineEffect,"category":"skill"},
	"Veteran":{"type":VeteranEffect,"category":"skill"},
	"Guardian":{"type":GuardianEffect,"category":"skill"},
	"Indomitable":{"type":IndomitableEffect,"category":"skill"},
	"Arcane Insight":{"type":ArcaneInsightEffect,"category":"skill"},
	"Spell Efficiency":{"type":SpellEfficiencyEffect,"category":"skill"},
	"Mana Surge":{"type":ManaSurgeEffect,"category":"skill"},
	"Archmage":{"type":ArchmageEffect,"category":"skill"},
	"Healing Light":{"type":HealingLightEffect,"category":"skill"},
	"Divine Favour":{"type":DivineFavourEffect,"category":"skill"},
	"Restoration":{"type":RestorationEffect,"category":"skill"},
	"Ascension":{"type":AscensionEffect,"category":"skill"},
	"Backstab":{"type":BackstabEffect,"category":"skill"},
	"Evasion":{"type":EvasionEffect,"category":"skill"},
	"Shadowstep":{"type":ShadowstepEffect,"category":"skill"},
	"Assassination":{"type":AssassinationEffect,"category":"skill"},
	"Pathfinder":{"type":PathfinderEffect,"category":"skill"},
	"Recon":{"type":ReconEffect,"category":"skill"},
	"Spy Tactics":{"type":SpyTacticsEffect,"category":"skill"},
	"Windrunner":{"type":WindrunnerEffect,"category":"skill"},
	"Scavenger":{"type":ScavengerEffect,"category":"skill"},
	"Appraisal":{"type":AppraisalEffect,"category":"skill"},
	"Networking":{"type":NetworkingEffect,"category":"skill"},
	"Guild Financier":{"type":GuildFinancierEffect,"category":"skill"},
	"Bless":{"type":BlessEffect,"category":"skill"},
	"Fervour":{"type":FervorEffect,"category":"skill"},
	"Divine Shield":{"type":DivineShieldEffect,"category":"skill"},
	"Champion of Light":{"type":ChampionOfLightEffect,"category":"skill"},
	"Necromancy":{"type":NecromancyEffect,"category":"skill"},
	"Dark Pact":{"type":DarkPactEffect,"category":"skill"},
	"Soul Harvest":{"type":SoulHarvestEffect,"category":"skill"},
	"Necromastery":{"type":NecromasteryEffect,"category":"skill"},
	"Lone Wolf":{"type":LoneWolfEffect,"category":"skill"},
	"Precision":{"type":PrecisionEffect,"category":"skill"},
	"Hunter's Mark":{"type":HuntersMarkEffect,"category":"skill"},
	"Apex Predator":{"type":ApexPredatorEffect,"category":"skill"},
	
	"Arcane Winds":{"type":BoardEventArcaneWinds,"category":"event"},
	"The Chicken Incident":{"type":BoardEventChickenIncident,"category":"event"},
	"Focused Efforts":{"type":BoardEventFocusedEfforts,"category":"event"},
	"Happy Hour(s)!":{"type":BoardEventHappyHours,"category":"event"},
	"Merchant Festival":{"type":BoardEventMerchantFestival,"category":"event"},
	"Monster Surge":{"type":BoardEventMonsterSurge,"category":"event"},
	"Quiet Roads":{"type":BoardEventQuietRoads,"category":"event"},
	"Rare Finds":{"type":BoardEventRareFinds,"category":"event"},
	"Tax Season":{"type":BoardEventTaxSeason,"category":"event"},
	"Training Day":{"type":BoardEventTrainingDay,"category":"event"},
	"Undead Rising!":{"type":BoardEventUndeadRising,"category":"event"},
	"Urgent Contracts":{"type":BoardEventUrgentContracts,"category":"event"},
	"War Fever":{"type":BoardEventWarFever,"category":"event"},
}
static func get_effect_by_name(_name:String):
	return EFFECTS.get(_name, null)


# Quest information & helpers
enum QuestContexts { AGGRESSIVE, NEUTRAL, SUPPORTIVE }
static var QUEST_ACTIONS : Array[QuestAction] = [
	# AGGRESSIVE 
	QuestAction.new("Clear", {Stats.STRENGTH:A_SCALING}, ["combat","vs many"], QuestContexts.AGGRESSIVE),
	QuestAction.new("Defeat", {Stats.DEXTERITY:A_SCALING}, ["combat", "vs few"], QuestContexts.AGGRESSIVE),
	QuestAction.new("Slay", {Stats.STRENGTH:B_SCALING,Stats.DEXTERITY:B_SCALING}, ["combat", "vs few"], QuestContexts.AGGRESSIVE),
	QuestAction.new("Spy On", {Stats.INTELLIGENCE:A_SCALING}, ["scout", "vs many"], QuestContexts.AGGRESSIVE),
	QuestAction.new("Ambush", {Stats.INTELLIGENCE:B_SCALING,Stats.DEXTERITY:B_SCALING}, ["combat", "vs many"], QuestContexts.AGGRESSIVE),
	QuestAction.new("Strike At", {Stats.STRENGTH:B_SCALING, Stats.INTELLIGENCE:B_SCALING}, ["combat","vs few"], QuestContexts.AGGRESSIVE),
	
	# NEUTRAL
	QuestAction.new("Watch Over", {Stats.STRENGTH:A_SCALING}, ["protect","scout"], QuestContexts.NEUTRAL),
	QuestAction.new("Survey", {Stats.INTELLIGENCE:A_SCALING}, ["explore","scout"], QuestContexts.NEUTRAL),
	QuestAction.new("Explore", {Stats.DEXTERITY:A_SCALING}, ["explore","scout"], QuestContexts.NEUTRAL),
	
	# SUPPORTIVE 
	QuestAction.new("Escort", {Stats.STRENGTH:A_SCALING}, ["protect"], QuestContexts.SUPPORTIVE),
	QuestAction.new("Recover", {Stats.DEXTERITY:A_SCALING}, ["retrieve"], QuestContexts.SUPPORTIVE),
	QuestAction.new("Assist", {Stats.INTELLIGENCE:A_SCALING}, ["protect"], QuestContexts.SUPPORTIVE),
]
func get_quest_actions_of_context(c:QuestContexts)->Array[QuestAction]:
	var result : Array[QuestAction] = []
	for a in QUEST_ACTIONS:
		if a.action_context == c:
			result.append(a)
	return result
static var QUEST_TARGETS : Array[QuestTarget]= [
	# AGGRESSIVE
	QuestTarget.new("Goblins", ["goblin","humanoid"], QuestContexts.AGGRESSIVE),
	QuestTarget.new("Trolls", ["troll","humanoid"], QuestContexts.AGGRESSIVE),
	QuestTarget.new("Orcs", ["orc","humanoid"], QuestContexts.AGGRESSIVE),
	QuestTarget.new("Bandits", ["bandit","humanoid"], QuestContexts.AGGRESSIVE),
	QuestTarget.new("Skeletons", ["skeleton","undead"], QuestContexts.AGGRESSIVE),
	QuestTarget.new("Drakes", ["drake","draconic"], QuestContexts.AGGRESSIVE),
	QuestTarget.new("Evil Spirits", ["spirit","undead"], QuestContexts.AGGRESSIVE),
	QuestTarget.new("Demons", ["demonic"], QuestContexts.AGGRESSIVE),
	
	# SUPPORTIVE 
	QuestTarget.new("Merchants", ["merchant","humanoid"], QuestContexts.SUPPORTIVE),
	QuestTarget.new("Villagers", ["peasant","humanoid"], QuestContexts.SUPPORTIVE),
	QuestTarget.new("Peasants", ["peasant","humanoid"], QuestContexts.SUPPORTIVE),
	QuestTarget.new("Farmers", ["peasant","humanoid"], QuestContexts.SUPPORTIVE),
	QuestTarget.new("Travelling Priests", ["holy","humanoid"], QuestContexts.SUPPORTIVE),
	QuestTarget.new("Circus Troupe", ["peasant","humanoid"], QuestContexts.SUPPORTIVE),
	QuestTarget.new("Lost Alchemist", ["peasant","humanoid"], QuestContexts.SUPPORTIVE),
	QuestTarget.new("Knights", ["peasant","humanoid"], QuestContexts.SUPPORTIVE)
]
func get_quest_targets_of_context(c:QuestContexts)->Array[QuestTarget]:
	var result : Array[QuestTarget] = []
	for t in QUEST_TARGETS:
		if t.target_context == c:
			result.append(t)
	return result
static var QUEST_LOCATIONS = [
	QuestLocation.new("Forest", ["forest","outdoors","wild"]),
	QuestLocation.new("Underground Ruins", ["ruin","indoors","underground"]),
	QuestLocation.new("Castle Ruins", ["ruin","outdoors","wild"]),
	QuestLocation.new("Caves", ["cave","underground","wild"]),
	QuestLocation.new("Flooded Caves", ["cave","underground","aquatic"]),
	QuestLocation.new("Swamp", ["swamp","outdoors","aquatic"]),
	QuestLocation.new("Village", ["village","outdoors","settled"]),
	QuestLocation.new("Mountain Pass", ["mountain","outdoors","wild"]),
	QuestLocation.new("Mines", ["mine","underground","settled"]),
	QuestLocation.new("Old Road", ["road","outdoors","settled"]),
	QuestLocation.new("Catacombs", ["catacomb","underground","indoors"]),
]
const QUEST_MOD_CHANCE : float = 0.66
static var QUEST_MODIFIERS = [
	QuestModifier.new("Dangerous", ["dangerous"], 1.5),
	QuestModifier.new("Urgent", ["urgent"], 1.25, 0.5),
	QuestModifier.new("Lucrative", ["lucrative"], 1.0, 1.0, 1.5),
	QuestModifier.new("Cursed", ["undead","cursed"], 1.25),
	QuestModifier.new("Unknown Territory", ["explore"], 1.0, 1.25),
	QuestModifier.new("Boss Present", ["boss"], 2.0, 2.0, 2.0)
]

# Stat scalings
const C_SCALING : float = 0.25
const B_SCALING : float = 0.5
const A_SCALING : float = 1.0
const SCALING_STRINGS : Dictionary[float,String] = {
	C_SCALING:"C",
	B_SCALING:"B",
	A_SCALING:"A"
}

# Different outcomes for a quest
enum QuestResults { CRIT_SUCCESS, SUCCESS, PARTIAL_SUCCESS, FAIL }

# Facilities
static var FACILITIES = [
	FacilityData.new("Barracks", "Increases max roster size by +1 per upgrade.",\
	400, 0, 10),
	FacilityData.new("Recruitment Office", "Increases the number of new recruits per " + \
	"refresh by +1 per upgrade.", 600, 0, 10),
	FacilityData.new("Quest Board", "Increase the number of quests available at " + \
	"the quest board per refresh by +1 per upgrade.", 600, 0, 10),
	FacilityData.new("Tavern", "Idle heroes will regenerate health as if resting " + \
	"at a reduced speed. Speed increases per upgrade.", 500, 0, 5),
	FacilityData.new("Training Grounds", "Increase level cap by 5 and universal quest reward " + \
	"experience by 33% per upgrade.", 900, 0, 10),
	FacilityData.new("Treasury", "Increase universal quest reward gold by 10%" + \
	" per upgrade.", 1000, 0, 10),
	FacilityData.new("Library", "Rank 1: Allows you to re-class your heroes.\n" + \
	"Rank 2: Allows you to reroll hero traits for gold.\n" + \
	"Rank 3: Allows you to trade hero traits to and from the library for gold.", 1500, 0, 3),
	# FacilityData.new("Blacksmith", "Grants you randomised equipment per day. " + \
	#" Better equipment will show up with higher upgrades.", 5000, 0, 10)
	FacilityData.new("Notice Board", "Random events will occur daily. They will grant " + \
	"more variety and rewards per upgrade.",100, 0, 5)
]
func get_facility(_name:String):
	for fac in FACILITIES:
		if fac.facility_name == _name:
			return fac
	return null

# Login rewards
static var LOGIN_REWARDS = [
	LoginReward.new("Gold Reward!", LoginReward.RewardType.GOLD),
	LoginReward.new("Hero Recruit!", LoginReward.RewardType.HERO),
	LoginReward.new("Influence Boost!", LoginReward.RewardType.INFLUENCE)
]
func get_reward_by_type(t : LoginReward.RewardType):
	for reward in LOGIN_REWARDS:
		if reward.reward_type == t:
			return reward
	return null

# Gamewide constants
const BASE_HEALTH : int = 100
const LEVEL_THRESHOLDS : Array[int] = [10, 20, 30, 40]

const LOWER_QUEST_LEVEL_LIMIT : int = 3
const UPPER_QUEST_LEVEL_LIMIT : int = 5
const QUEST_DIFFICULTY_PER_LEVEL : int = 2
const QUEST_DURATION_PER_DIFFICULTY : int = 2
const QUEST_DAMAGE_PER_DIFFICULTY: float = 1.2
const QUEST_REWARD_LOWER_RANGE_PER_DIFFICULTY : int = 4
const QUEST_REWARD_UPPER_RANGE_PER_DIFFICULTY : int = 8
const QUEST_EXP_PER_DIFFICULTY : int = 1
const QUEST_MODIFIER_CHANCE : float = 0.5
const QUEST_MAX_PARTY_SIZE : int = 3
const QUEST_APTITUDE_VARIANCE : float = 0.2
const QUEST_DAMAGE_VARIANCE : float = 0.2
const QUEST_CRIT_THRESHOLD_FACTOR : float = 1.5
const QUEST_CRITFAIL_THRESHOLD_FACTOR : float = 0.7
const QUEST_DIFFICULTY_CLIFF : float = 0.7
const QUEST_EFFECTIVE_CONTRIBUTION_CAP : float = 1.5 # Max contribution for AGI & LUK
const QUEST_APTITUDE_FALLOFF : float = 0.6 # Aptitude falloff after reaching quest difficulty

const MINIMUM_BASE_STAT: int = 4
const MAXIMUM_BASE_STAT: int = 10

const BASE_HERO_COST : int = 50
const BASE_ROSTER_SIZE : int = 2
const BASE_QUESTS_PER_REFRESH : int = 3

const EXP_REQ_PER_LEVEL : int = 10
const BASE_LEVEL_CAP : int = 10
const MAX_EFFECT_LEVEL : int = 5

const DAILY_GOLD_REWARD : int = 500

const AUTOSAVE_TIMER : int = 60

# Universal rarity rolls
func roll_rarity():
	var r = randf()
	var result = null
	for rarity in RARITIES:
		if r < rarity.rarity_weight:
			result = rarity
		else:
			break
	return result
