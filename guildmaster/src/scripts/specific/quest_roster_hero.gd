# quest_roster_hero.gd
extends VBoxContainer
class_name QuestRosterHero

# Signals
signal portrait_clicked(us:Node)

# Parameters
var hero : HeroData
var stats : Array[Defs.Stats]

# Functions
func setup(h:HeroData, q: QuestData):
	hero = h
	if hero != null:
		# Portrait HERE
		$QuestRosterHeroNameLabel.text = hero.hero_name
		$QuestRosterHeroHealth.visible = true
		$QuestRosterHeroCont.visible = true
		$QuestRosterHeroCont2.visible = true
		$QuestRosterHeroHealth.max_value = hero.get_max_hp()
		$QuestRosterHeroHealth.value = hero.hero_cur_hp
		$QuestRosterHeroHealth/QuestRosterHeroHealthLabel.text = \
		str(hero.hero_cur_hp) + "/" + str(hero.get_max_hp())
		
		var stat_string = "("
		stats = q.quest_action.action_stats.keys()
		var num = len(stats)
		var cur_num = num
		for i in range(num):
			if stats[i] == Defs.Stats.STRENGTH:
				stat_string += "STR"
			elif stats[i] == Defs.Stats.INTELLIGENCE:
				stat_string += "INT"
			else:
				stat_string += "DEX"
			cur_num -= 1
			if cur_num > 0:
				stat_string += " + "
		stat_string += ") " + str(q.base_aptitude_from_hero(hero))
		$QuestRosterHeroCont.text = stat_string
		$QuestRosterHeroCont2.text = "AGI: " + \
		str(q.get_extra_speed_from_hero(h)) + \
		" (-" + str(q.get_difficulty_cliff()) + ")"
	else:
		$QuestRosterHeroNameLabel.text = "Add Hero"
		$QuestRosterHeroHealth.visible = false
		$QuestRosterHeroCont.visible = false
		$QuestRosterHeroCont2.visible = false

func _on_quest_roster_button_pressed() -> void:
	portrait_clicked.emit(self)
