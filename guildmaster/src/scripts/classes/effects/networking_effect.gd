# NAME.GD
extends Effect
class_name NetworkingEffect

# Constructor
func _init():
	super("Networking", "This hero adds a flat +1 to their Aptitude contribution for every " + \
	"point of Influence the guild holds.")

# Overrides
func _get_aptitude_bonus(quest:QuestData) -> int:
	return int(float(GameManager.influence) * 0.33) # 33% of Influence as Aptitude
