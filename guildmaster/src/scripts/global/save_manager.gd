# save_manager.gd
extends Node

# Save the game
func save_game():
	var data = GameManager.get_save_data()
	var file = FileAccess.open("user://save.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		print("SAVE SUCCESSFUL.")

# Load the game
func load_game():
	if not FileAccess.file_exists("user://save.json"):
		return
	var file = FileAccess.open("user://save.json", FileAccess.READ)
	var text = file.get_as_text()
	var data = JSON.parse_string(text)
	GameManager.load_save_data(data)
	print("LOAD SUCCESSFUL.")

# Wipe Save
func wipe_save():
	if FileAccess.file_exists("user://save.json"):
		DirAccess.remove_absolute("user://save.json")
