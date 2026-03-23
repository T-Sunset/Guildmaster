extends PanelContainer
class_name FacilityPopup

# Signal
signal popup_closed

# Parameters
var facility : String 
var level : int

# Functions
func open_popup(f:String, l:int):
	visible = true
	setup(f,l)
func close_popup():
	visible = false
	popup_closed.emit()

#Setup
func setup(f:String, l:int):
	# Set values
	facility = f
	level = l
	var can_level = Defs.get_facility(f).can_level_up(l)
	
	# Set display
	$MarginContainer/VBoxContainer/FacilityNameLabel.text = f
	# ICON
	$MarginContainer/VBoxContainer/FacilityLabel.text = Defs.get_facility(f).facility_description
	if can_level:
		$MarginContainer/VBoxContainer/LevelLabel.text = "Lv " + str(l) + " >> " + str(l+1) + \
		"\nCost: " + str(Defs.get_facility(f).get_cost(l)) + "g"
		$MarginContainer/VBoxContainer/HBoxContainer/UpgradeButton.visible = true
	else:
		$MarginContainer/VBoxContainer/LevelLabel.text = "Max upgrade level reached."
		$MarginContainer/VBoxContainer/HBoxContainer/UpgradeButton.visible = false

func _on_close_button_pressed() -> void:
	close_popup()

func _on_upgrade_button_pressed() -> void:
	GuildManager.upgrade_facility(facility)
