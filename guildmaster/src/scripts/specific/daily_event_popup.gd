# Daily_event_popup.gd
extends PanelContainer
class_name DailyEventPopup

# Signals
signal close_popup

# Functions
func setup():
	$MarginContainer/Content/EventLabel.text = GuildManager.daily_event.effect_name
	$MarginContainer/Content/EventDescLabel.text = GuildManager.daily_event.effect_description

func _on_close_button_pressed() -> void:
	close_popup.emit()
