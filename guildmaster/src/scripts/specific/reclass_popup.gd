# reclass_popup.gd
extends PanelContainer
class_name ReclassPopup

# Signals
signal popup_closing

# Parameters
var hero : HeroData

# Functions
func open_popup(h:HeroData):
	setup(h)
	self.visible = true
func close_popup():
	self.visible = false
	popup_closing.emit()

# Setup
func setup(h:HeroData):
	# Set Value
	hero = h
	
	# Display
	$MarginContainer/ReclassContent/ReclassLabel.text = "Reclassing: " + h.hero_name
	
	# Instantiate ClassDisplays
	for child in $MarginContainer/ReclassContent/ScrollContainer/ReclassList.get_children():
		child.queue_free()
	for c in Defs.CLASSES:
		var row = preload("res://src/scenes/prefabs/ui/ClassDisplay.tscn").instantiate()
		row.setup(h, c)
		row.class_chosen.connect(change_hero_class)
		$MarginContainer/ReclassContent/ScrollContainer/ReclassList.add_child(row)

# Change Hero Class
func change_hero_class(c:HeroClass):
	if hero.reclass(c):
		close_popup()

func _on_close_button_pressed() -> void:
	close_popup()
