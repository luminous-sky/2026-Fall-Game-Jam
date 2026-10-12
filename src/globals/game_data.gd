extends Node

enum AREAS {
	INTRO,
	MAIN,
	FINAL,
}

static var current_area: AREAS
static var current_level: String
static var data_loaded: bool = false


const SAVE_FILE: StringName = "user://save.urevs"


func _ready() -> void:
	# Load data on game start
	var data = load_data()
	if not data:
		return
	
	current_area = data["area"]
	current_level = data["level"]
	
	data_loaded = true


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		# Save data on close
		save_data()


## Loads data from [const SAVE_FILE].
func load_data():
	# Check if a save exists
	if not FileAccess.file_exists(SAVE_FILE):
		return null
	
	# Load data
	var save_file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	var json_data = save_file.get_as_text()
	save_file.close()
	
	return JSON.to_native(JSON.parse_string(json_data))


## Saves data into [const SAVE_FILE].
func save_data():
	var data = {
		"area": current_area,
		"level": current_level
	}
	
	var json_data = JSON.stringify(JSON.from_native(data))
	
	var save_file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	save_file.store_string(json_data)
	save_file.close()
