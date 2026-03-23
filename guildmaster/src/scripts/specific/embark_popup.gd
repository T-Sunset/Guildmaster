# embark_popup.gd
extends PanelContainer
class_name EmbarkPopup

# Signals
signal popup_closing

# Parameters 
var quest : QuestData
var selecting_hero : Node = null
@onready var quest_roster = $MarginContainer/Contents/QuestRosterParent/QuestRosterScrollview/QuestRoster

# Functions
func open_popup(q : QuestData):
	visible = true
	setup(q)
func close_popup():
	visible = false
	popup_closing.emit()
	
func setup(q : QuestData):
	# Set Quest
	quest = q
	
	# Display Quest
	for child in $MarginContainer/Contents/QuestContentParent.get_children():
		child.queue_free()
	var row = preload("res://src/scenes/prefabs/ui/QuestDisplay.tscn").instantiate()
	row.show_slots = false
	row.can_embark = false
	row.setup(q)
	$MarginContainer/Contents/QuestContentParent.add_child(row)
	
	# Go through heroes in quest 
	for i in range(len($MarginContainer/Contents/QuestRosterParent/QuestRosterRow.get_children())):
		if len(q.quest_party) > i:
			var child = $MarginContainer/Contents/QuestRosterParent/QuestRosterRow.get_child(i)
			child.setup(q.quest_party[i], q)
			if not child.portrait_clicked.is_connected(_roster_portrait_pressed):
				child.portrait_clicked.connect(_roster_portrait_pressed)
		else:
			var child = $MarginContainer/Contents/QuestRosterParent/QuestRosterRow.get_child(i)
			child.setup(null, q)
			if not child.portrait_clicked.is_connected(_roster_portrait_pressed):
				child.portrait_clicked.connect(_roster_portrait_pressed)
	
	# Display Hero Selection List
	for child in quest_roster.get_children():
		child.queue_free()
	if selecting_hero != null:
		$MarginContainer/Contents/QuestRosterParent/QuestRosterSelectorLabel.visible = true
		$MarginContainer/Contents/QuestRosterParent/QuestRosterScrollview.visible = true
		var possible_heroes : Array[HeroData]
		for hero in HeroManager.roster:
			if hero not in quest.quest_party and hero.hero_state == Defs.HeroStates.IDLE:
				possible_heroes.append(hero)
		if len(possible_heroes) > 0:
			for hero in possible_heroes:
				var hero_row = preload("res://src/scenes/prefabs/ui/HeroDisplay.tscn").instantiate()
				hero_row.select_this_hero.connect(_add_remove_hero)
				hero_row.can_select = true
				hero_row.setup(hero)
				quest_roster.add_child(hero_row)
	else:
		$MarginContainer/Contents/QuestRosterParent/QuestRosterSelectorLabel.visible = false
		$MarginContainer/Contents/QuestRosterParent/QuestRosterScrollview.visible = false
	
	# Display Projected Results
	var ap_range = QuestManager.get_aptitude_range(q)
	$MarginContainer/Contents/ChanceRow/AptitudeLabel.text = "Aptitude: " + \
	str(ap_range[0]) + " ~ " + str(ap_range[1])
	$MarginContainer/Contents/ChanceRow/DifficultyLabel.text = "Difficulty: " + \
	str(q.quest_difficulty)
	ap_range = QuestManager.get_damage_range(q)
	$MarginContainer/Contents/ChanceRow2/DamageLabel.text = "Damage: " + \
	str(ap_range[0]) + " ~ " + str(ap_range[1])
	$MarginContainer/Contents/ChanceRow3/ChanceLabel.text = "Success Chance: " + \
	str(int(QuestManager.get_success_chance(q) * 100)) + "%"
	$MarginContainer/Contents/ChanceRow2/TimeLabel.text = "Time: " + \
	GameManager.convert_seconds_to_time_string(q.get_quest_duration()) + " (-" +\
	str(q.get_extra_speed()) + "s)"

# Click on a roster to determine what slot to put a hero in
func _roster_portrait_pressed(node:Node):
	if selecting_hero != node:
		selecting_hero = node
		if node.hero != null:
			_add_remove_hero(node.hero)
	else:
		selecting_hero = null
	setup(quest)

# Add / Remove a Hero from the Quest
func _add_remove_hero(hero:HeroData):
	if quest.quest_party.has(hero):
		if quest.remove_hero(hero):
			selecting_hero = null
			setup(quest)
	elif hero not in quest.quest_party:
		if quest.add_hero(hero):
			selecting_hero = null
			setup(quest)

func _on_close_button_pressed() -> void:
	for hero in quest.quest_party:
		quest.remove_hero(hero)
	close_popup()

func _on_embark_button_pressed() -> void:
	if len(quest.quest_party) > 0:
		QuestManager.embark(quest)
		close_popup()
