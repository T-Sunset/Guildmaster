# NAME.GD
extends Effect
class_name BlessEffect

# Constructor
func _init():
	super("Bless", "This hero's base health regeneration is increased by a flat +4.")

# Overrides
func _get_base_regeneration() -> int:
	return 4 # Base health regeneration increased from 1 to 5.
