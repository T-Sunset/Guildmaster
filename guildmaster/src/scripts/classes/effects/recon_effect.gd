# NAME.GD
extends Effect
class_name ReconEffect

# Constructor
func _init():
	super("Recon", "25% of this hero's AGI gets added as part of their contribution towards " +\
	"quests.")

# Overrides
func _get_aptitude_bonus(quest:QuestData) -> int:
	return int(float(effect_hero.get_stat(Defs.Stats.AGILITY)) * 0.25) # Apply 25% AGI to contribution
