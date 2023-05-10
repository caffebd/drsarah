extends Control


var my_level_name := ""

var is_active := false

var unlocked_frame := "res://assets/menus/Level Select Screen/Unlocked Level.png"

var locked_frame := "res://assets/menus/Level Select Screen/Locked Level.png"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_image(level_name:String, active: bool):
	my_level_name = level_name
	is_active = active
	if GlobalVars.level_menu_data[level_name]:
		$"%LevelImage".texture_normal = load(GlobalVars.level_menu_data[level_name]["image"])
		$"%LevelName".text = GlobalVars.level_menu_data[level_name]["label"]
	if is_active:
		$"%LevelFrame".texture = load(unlocked_frame)
	else:
		$"%LevelFrame".texture = load(locked_frame)



func _on_LevelImage_pressed():
	GlobalSignals.emit_signal("menu_start_level", my_level_name)
