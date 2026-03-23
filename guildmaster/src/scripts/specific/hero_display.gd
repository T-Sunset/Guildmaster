# hero_display.gd
extends VBoxContainer
class_name HeroDisplay

# Signals
signal hire_any_hero
signal hire_this_hero
signal fire_this_hero(hero:HeroData)
signal select_this_hero(hero:HeroData)
signal reclass_this_hero(hero:HeroData)

# Parameters
var hero_data : HeroData
var showmore : bool = false
var can_fire : bool = false
var can_select : bool = false
var fire_been_tapped_once : bool = false

# Functions
func setup(hero:HeroData):
	# Is this display for a hero?
	if hero != null:
		# Set Data 
		hero_data = hero
		
		# Display Hero Information
		# TOP ROW
		# portrait
		$TopRow/NameLabel.text = hero.hero_name
		if hero.hero_state == Defs.HeroStates.IDLE:
			$TopRow/NameLabel.text += " (Idle)"
		elif hero.hero_state == Defs.HeroStates.ONQUEST:
			$TopRow/NameLabel.text += " (On Quest)"
		elif hero.hero_state == Defs.HeroStates.RESTING:
			$TopRow/NameLabel.text += " (Resting)"
		$TopRow.visible = true
		
		# CLASS ROW
		$ClassRow/ClassLabel.text = hero.hero_class.get_current_promotion_name(hero.hero_levels[hero.hero_class])
		$ClassRow/ClassLevel.text = "Lv " + str(hero.hero_levels[hero.hero_class]) + " (" + \
			str(hero.get_total_level()) + ") | EXP: " + str(hero.hero_cur_exp) + "/" + str(hero.get_max_exp())
		$ClassRow.visible = true
		
		# HEALTH ROW
		$HealthRow/HealthBar.max_value = hero.get_max_hp()
		$HealthRow/HealthBar.value = hero.hero_cur_hp
		$HealthRow/HealthBar/HealthLabel.text = str(hero.hero_cur_hp) + "/" + str(hero.get_max_hp()) + \
			" HP"
		$HealthRow.visible = true
		
		# SIMPLE ROW
		$SimpleRow/SimpleStats.text = "STR: " + str(hero.hero_stats[Defs.Stats.STRENGTH]) + \
			" | INT: " + str(hero.hero_stats[Defs.Stats.INTELLIGENCE]) + \
			" | DEX: " + str(hero.hero_stats[Defs.Stats.DEXTERITY])
		$SimpleRow.visible = true
		
		# EXPANDED ROW
		$Expanded/StatGrid/Strength.text = get_stat_string("STR: ", Defs.Stats.STRENGTH)
		$Expanded/StatGrid/Endurance.text = get_stat_string("END: ", Defs.Stats.ENDURANCE)
		$Expanded/StatGrid/Intellect.text = get_stat_string("INT: ", Defs.Stats.INTELLIGENCE)
		$Expanded/StatGrid/Willpower.text = get_stat_string("WIL: ", Defs.Stats.WILLPOWER)
		$Expanded/StatGrid/Dexterity.text = get_stat_string("DEX: ", Defs.Stats.DEXTERITY)
		$Expanded/StatGrid/Agility.text = get_stat_string("AGI: ", Defs.Stats.AGILITY)
		$Expanded/StatGrid/Luck.text = get_stat_string("LUK: ", Defs.Stats.LUCK)
		$Expanded/Weapon.text = "Weapon: ---"
		$Expanded/Armour.text = "Armour: ---"
		$Expanded/Accessory.text = "Accessory: ---"
		var trait_text = "Traits (" + str(hero.hero_rarity.rarity_trait_count) + "):"
		for t in hero.hero_effects:
			if t.effect_is_trait:
				trait_text += "\n > " + t.get_effect_name()
		trait_text += "\n\nSkills:"
		for t in hero.hero_effects:
			if not t.effect_is_trait:
				trait_text += "\n > " + t.get_effect_name()
		$Expanded/TraitLabel.text = trait_text
		
		$Expanded.visible = false
		
		# BUTTON ROW
		$Buttons/HireHero.visible = false
		if hero not in HeroManager.roster:
			$Buttons/HireThisHero.visible = true
			$Buttons/HireThisHero.text = "+ Hire (" + str(HeroManager.calculate_hero_cost(hero)) + \
				"g)"
			$Buttons/FireThisHero.visible = false
			$Buttons/SelectHero.visible = false
			$Buttons/ReclassButton.visible = false
		else:
			$Buttons/FireThisHero.visible = can_fire and hero.hero_state == Defs.HeroStates.IDLE
			$Buttons/SelectHero.visible = can_select and hero.hero_state == Defs.HeroStates.IDLE
			if GuildManager.get_can_reclass_bool():
				$Buttons/ReclassButton.visible = not can_select and hero.hero_state == Defs.HeroStates.IDLE
			else:
				$Buttons/ReclassButton.visible = false
			$Buttons/HireThisHero.visible = false
			
		$Buttons/MoreLess.visible = true
	else:
		for child in get_children():
			child.visible = false
		$Buttons.visible = true
		$Buttons/FireThisHero.visible = false
		$Buttons/HireThisHero.visible = false
		$Buttons/MoreLess.visible = false
		$Buttons/HireHero.visible = true
		$Buttons/SelectHero.visible = false
		$Buttons/ReclassButton.visible = false
func toggle_more():
	if showmore:
		$SimpleRow.visible = false
		$Expanded.visible = true
	else:
		$SimpleRow.visible = true
		$Expanded.visible = false

# Tick
func tick():
	if hero_data == null:
		return
	# Display Hero Information
	# TOP ROW
	# portrait
	$TopRow/NameLabel.text = hero_data.hero_name
	if hero_data.hero_state == Defs.HeroStates.IDLE:
		$TopRow/NameLabel.text += " (Idle)"
	elif hero_data.hero_state == Defs.HeroStates.ONQUEST:
		$TopRow/NameLabel.text += " (On Quest)"
	elif hero_data.hero_state == Defs.HeroStates.RESTING:
		$TopRow/NameLabel.text += " (Resting)"
	$TopRow.visible = true
	
	# HEALTH ROW
	$HealthRow/HealthBar.max_value = hero_data.get_max_hp()
	$HealthRow/HealthBar.value = hero_data.hero_cur_hp
	$HealthRow/HealthBar/HealthLabel.text = str(hero_data.hero_cur_hp) + "/" + str(hero_data.get_max_hp()) + \
		" HP"
	$HealthRow.visible = true

# Helpers
func get_stat_string(prefix:String, stat:Defs.Stats):
	return prefix + str(hero_data.hero_stats[stat])

func _on_hire_any_hero_pressed() -> void:
	hire_any_hero.emit()

func _on_hire_this_hero_pressed() -> void:
	hire_this_hero.emit(hero_data)

func _on_fire_this_hero_pressed() -> void:
	if not fire_been_tapped_once:
		fire_been_tapped_once = true
		$Buttons/FireThisHero/Timer.start()
		$Buttons/FireThisHero.text = ("ARE YOU SURE?")
	else:
		fire_this_hero.emit(hero_data)

func _on_more_less_pressed() -> void:
	showmore = !showmore
	toggle_more()

func _on_select_hero_pressed() -> void:
	select_this_hero.emit(hero_data)


func _on_timer_timeout() -> void:
	fire_been_tapped_once = false
	$Buttons/FireThisHero.text = ("- Fire")

func _on_reclass_button_pressed() -> void:
	reclass_this_hero.emit(hero_data)
