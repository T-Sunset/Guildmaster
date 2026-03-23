# ui_manager.gd
extends Control
class_name UIManager

# Components 
@onready var hero_panel = $HeroPanel
@onready var heroes_button = $BottomBar/MarginContainer/Row/HeroesButton
@onready var hero_list = $HeroPanel/MarginContainer/VBoxContainer/ScrollContainer/HeroList
@onready var recruit_popup = $RecruitPopup
@onready var reclass_popup = $ReclassPopup
@onready var quest_panel = $QuestPanel
@onready var quests_button = $BottomBar/MarginContainer/Row/QuestsButton
@onready var quest_available_list = $QuestPanel/MarginContainer/VBoxContainer/ScrollContainer/AvailableQuestList
@onready var quest_current_list = $QuestPanel/MarginContainer/VBoxContainer/ScrollContainer2/CurrentQuestList
@onready var embark_popup = $EmbarkPopup
@onready var guild_panel = $GuildPanel
@onready var guild_list = $GuildPanel/MarginContainer/VBoxContainer/ScrollContainer/FacilityList
@onready var guild_button = $BottomBar/MarginContainer/Row/GuildButton
@onready var facility_popup = $FacilityPopup
@onready var gold_display = $TopBar/MarginContainer/Row/GoldLabel
@onready var influence_display = $TopBar/MarginContainer/Row/InfluenceLabel
@onready var daily_event_popup = $DailyEventPopup
@onready var daily_event_button = $DailyEventButton
@onready var daily_login_popup = $DailyLoginTrack
@onready var daily_login_button = $LoginTrackButton

# Parameters
enum UiState { NONE, HEROES, QUESTS, GUILD }
var ui_state : UiState = UiState.NONE
var old_state : UiState = UiState.NONE

# Start Funct
func _ready():
	heroes_button.pressed.connect(toggle_ui_state.bind(UiState.HEROES))
	quests_button.pressed.connect(toggle_ui_state.bind(UiState.QUESTS))
	guild_button.pressed.connect(toggle_ui_state.bind(UiState.GUILD))
	GameManager.gold_changed.connect(_update_gold_display)
	GameManager.influence_changed.connect(_update_influence_display)
	recruit_popup.popup_closing.connect(update_hero_panel)
	embark_popup.popup_closing.connect(update_quests_panel)
	
	GameManager.world_tick.connect(_on_world_tick)
	
	QuestManager.quest_list_refreshed.connect(update_quests_panel)

# Functions
# Update Top Bar: Gold
func _update_gold_display():
	gold_display.text = str(GameManager.gold) + "g"
# Update top bar: Influence
func _update_influence_display():
	influence_display.text = str(GameManager.influence) + " influence"

# TOGGLE GIVEN PANEL ON/OFF
func toggle_ui_state(new_state : UiState):
	# Set the UI state 
	old_state = ui_state
	if ui_state != new_state:
		ui_state = new_state
	else:
		ui_state = UiState.NONE
	
	# Display the current panel
	show_panel()

# Show our current panel 
func show_panel():
	# Open our new state if necessary
	if ui_state != UiState.NONE: # Opening
		# Get our new panel and display it
		match ui_state:
			UiState.HEROES:
				open_hero_panel()
			UiState.QUESTS:
				open_quests_panel()
			UiState.GUILD:
				open_guild_panel()
			_:
				pass
	
	# Close our old state if necessary
	if old_state != UiState.NONE:
		# Get our old panel and close it
		match old_state:
			UiState.HEROES:
				close_hero_panel()
			UiState.QUESTS:
				close_quests_panel()
			UiState.GUILD:
				close_guild_panel()
			_:
				pass

# HEROES PANEL
func open_hero_panel():
	# Tween in Hero panel
	var tween = create_tween()
	tween.tween_property(hero_panel, "position:x", 0, 0.25)
	update_hero_panel()
func update_hero_panel():
	# Set Hero Count Text
	$HeroPanel/MarginContainer/VBoxContainer/TitleLabel.text = "Heroes: " + \
	str(len(HeroManager.roster)) + " / " + str(GuildManager.get_max_roster_size())
	# Clear our hero list 
	for child in hero_list.get_children():
		child.queue_free()
	# Instantiate and setup our hero roster 
	for hero in HeroManager.roster:
		var row = preload("res://src/scenes/prefabs/ui/HeroDisplay.tscn").instantiate()
		if len(HeroManager.roster) > 1:
			row.can_fire = true
		row.fire_this_hero.connect(trigger_hero_firing)
		row.reclass_this_hero.connect(_open_reclass_popup)
		row.setup(hero)
		hero_list.add_child(row)
	# Instantiate hire button 
	if HeroManager.has_room_in_roster():
		var row = preload("res://src/scenes/prefabs/ui/HeroDisplay.tscn").instantiate()
		row.setup(null)
		row.hire_any_hero.connect(_open_recruit_popup)
		hero_list.add_child(row)
func tick_hero_panel():
	for child in hero_list.get_children():
		child.tick()
func close_hero_panel():
	# Tween OUT Hero panel
	var tween = create_tween()
	tween.tween_property(hero_panel, "position:x", -hero_panel.size.x, 0.25)
func _open_recruit_popup():
	recruit_popup.open_popup()
func trigger_hero_firing(hero:HeroData):
	HeroManager.remove_hero(hero)
	update_hero_panel()
func _open_reclass_popup(h:HeroData):
	reclass_popup.open_popup(h)
	reclass_popup.popup_closing.connect(update_hero_panel)

# QUESTS PANEL
func open_quests_panel():
	# Tween in Hero panel
	var tween = create_tween()
	tween.tween_property(quest_panel, "position:y", 64, 0.25)
	update_quests_panel()
func update_quests_panel():
	# Delete old children
	for child in quest_available_list.get_children():
		child.queue_free()
	for child in quest_current_list.get_children():
		child.queue_free()
	
	# Show available quests
	for quest in QuestManager.quest_list:
		var row = preload("res://src/scenes/prefabs/ui/QuestDisplay.tscn").instantiate()
		row.can_embark = true
		row.setup(quest)
		row.embark_clicked.connect(open_embark_popup)
		quest_available_list.add_child(row)
	# Show current quests
	for quest in QuestManager.active_quests:
		var row = preload("res://src/scenes/prefabs/ui/QuestDisplay.tscn").instantiate()
		row.can_embark = false
		row.show_slots = true
		row.setup(quest)
		row.close_clicked.connect(clear_away_quest)
		quest_current_list.add_child(row)
func tick_quests_panel():
	for child in quest_current_list.get_children():
		child.tick()
func close_quests_panel():
	# Tween OUT Hero panel
	var tween = create_tween()
	tween.tween_property(quest_panel, "position:y", (quest_panel.size.y * 1.5), 0.25)
func open_embark_popup(quest : QuestData):
	embark_popup.open_popup(quest)
func clear_away_quest(quest:QuestData):
	if quest in QuestManager.active_quests and quest.quest_ended:
		QuestManager.active_quests.erase(quest)
		update_quests_panel()

# GUILD PANEL
func open_guild_panel():
	# Tween in the panel
	var tween = create_tween()
	tween.tween_property(guild_panel, "position:x", \
	(get_viewport().size.x * 0.39), 0.25)
	update_guild_panel()
func update_guild_panel():
	# Clear old children
	for child in guild_list.get_children():
		child.queue_free()
	
	# Instantiate new ones baybee
	for facility in GuildManager.facilities.keys():
		var row = preload("res://src/scenes/prefabs/ui/FacilityDisplay.tscn").instantiate()
		row.setup(facility, GuildManager.facilities[facility])
		row.facility_pressed.connect(open_facility_popup)
		guild_list.add_child(row)
func close_guild_panel():
	# Tween out the panel
	var tween = create_tween()
	tween.tween_property(guild_panel, "position:x", \
	(get_viewport().size.x * 1.5), 0.25)
func open_facility_popup(facility:String):
	facility_popup.open_popup(facility, GuildManager.facilities[facility])
	if not facility_popup.popup_closed.is_connected(update_guild_panel):
		facility_popup.popup_closed.connect(update_guild_panel)

# DAILY EVENTS
func open_daily_event_popup():
	daily_event_popup.setup()
	GuildManager.seen_event = true
	daily_event_popup.visible = true
func close_daily_event_popup():
	daily_event_popup.visible = false
func _on_daily_event_button_pressed() -> void:
	open_daily_event_popup()
	if not daily_event_popup.close_popup.is_connected(close_daily_event_popup):
		daily_event_popup.close_popup.connect(close_daily_event_popup)

# DAILY LOGIN REWARDS
func open_daily_login_track():
	daily_login_popup.open_popup()
func _on_login_track_button_pressed() -> void:
	open_daily_login_track()


# On world tick
func _on_world_tick():
	tick_hero_panel()
	tick_quests_panel()
	_update_gold_display()
	_update_influence_display()
	daily_event_button.visible = GuildManager.daily_event != null
	if not GuildManager.seen_event:
		$DailyEventButton.text = "(NEW!)"
	else: $DailyEventButton.text = ""
func _on_refresh_button_pressed() -> void:
	if GameManager.influence > 0:
		QuestManager.refresh_quests()
		GameManager.spend_influence(1)
		update_quests_panel()
