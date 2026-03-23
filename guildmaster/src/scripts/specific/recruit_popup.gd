# recruit_popup.gd
extends PanelContainer
class_name RecruitPopup

# Signal
signal popup_closing

# Components
@onready var options = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HeroOptions

# Parameters
var heroes : Array[HeroData] = []

# Functions
# Generate new hero options and display them to our list
func generate_options():
	# Clear our old heroes array
	heroes.clear()
	
	# Delete old children
	for child in options.get_children():
		child.queue_free()
	
	# Generate new heroes and add them as children
	for hero in HeroManager.recruitable_roster:
		# Get recruitable heroes
		heroes.append(hero)
		
		# Generate hire row prefab
		var row = preload("res://src/scenes/prefabs/ui/HeroDisplay.tscn").instantiate()
		
		# Apply hero information to hero row prefab
		row.setup(hero)
		row.hire_this_hero.connect(hire_hero)
		
		# Set prefab to child of herooptions to assign it to the list
		options.add_child(row)

# When Hire button pressed
func hire_hero(hero:HeroData) -> void:
	var cost = HeroManager.calculate_hero_cost(hero)
	# Have we room for another hero?
	if HeroManager.has_room_in_roster():
		# Can we afford this hero?
		if GameManager.spend_gold(cost) and HeroManager.add_hero(hero):
			close_popup()
			HeroManager.recruitable_roster.erase(hero)
			SaveManager.save_game()
			return
	if len(HeroManager.roster) == 0:
		if HeroManager.has_room_in_roster():
			if HeroManager.add_hero(hero):
				close_popup()
				HeroManager.recruitable_roster.erase(hero)
				SaveManager.save_game()
				return

# Open popup
func open_popup():
	generate_options()
	visible = true

# Close popup
func close_popup():
	visible = false
	popup_closing.emit()

func _on_close_button_pressed() -> void:
	close_popup()


func _on_reroll_button_pressed() -> void:
	if GameManager.influence > 0:
		HeroManager.refresh_heroes()
		GameManager.spend_influence(1)
		generate_options()
