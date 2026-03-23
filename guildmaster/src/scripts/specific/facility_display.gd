# facility_display.gd
extends VBoxContainer
class_name FacilityDisplay

# Signals
signal facility_pressed(facility:String)

# Parameters
var facility : String
var facility_level : int

# Functions
func setup(f:String, l:int):
	# Set
	facility = f
	facility_level = l
	#ICON HERE
	$PanelContainer/MarginContainer/Row/VBoxContainer/FacilityLabel.text = f
	$PanelContainer/MarginContainer/Row/VBoxContainer/FacilityLevelLabel.text = "Lv " + str(l) + \
	" / " + str(Defs.get_facility(f).facility_max_level)

func _on_facility_icon_button_pressed() -> void:
	facility_pressed.emit(facility)
