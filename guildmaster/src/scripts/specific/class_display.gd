# class_display.g\d
extends VBoxContainer
class_name ClassDisplay

# Signals
signal class_chosen(hero_class:HeroClass)

# Parameters
var hero : HeroData
var hero_class : HeroClass

# Setup
func setup(h:HeroData,c:HeroClass):
	# Set Value
	hero = h
	hero_class = c
	
	# Display
	# ICON
	$PanelContainer/MarginContainer/VBoxContainer/RowA/VBoxContainer/ClassNameLabel.text = \
	c.get_current_promotion_name(h.hero_levels[c]) + " (Lv " + str(h.hero_levels[c]) + ")"
	var growth_text = ""
	for stat in c.hc_stat_growths.keys():
		growth_text += Defs.STATNAMES[stat] + "+" + str(c.hc_stat_growths[stat]) + " | "
	growth_text += "per Level"
	$PanelContainer/MarginContainer/VBoxContainer/RowA/VBoxContainer/ClassDetailsLabel.text = \
	growth_text

func _on_choose_button_pressed() -> void:
	class_chosen.emit(hero_class)
