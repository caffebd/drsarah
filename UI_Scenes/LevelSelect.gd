extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var grid = $"%LevelGrid"

var level_template = preload("res://UI_Scenes/LevelButton.tscn")

var book_btn_image = "res://assets/ui/level_select/level_book_btn.png"
var book_btn_alert = "res://assets/ui/level_select/Button With Book Exclaim.png"

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVars.load_from_door = false
	GlobalVars.load_from_entry = false
	
	if GlobalVars.use_touch_controls:
		_on_TouchControls_toggled(true)
	else:
		_on_TouchControls_toggled(false)
#	yield (FirebaseRest.login("a","a"), "completed")
	$"%LoadTimer".start()
	var user_id = FirebaseRest.user_info.id
	yield(FirebaseRest.get_document_active("EnglishAdventure/"+user_id+"/Game/Active"), "completed")
	GlobalVars.new_panels = yield(FirebaseRest.get_document_new_panels("EnglishAdventure/"+user_id+"/Game/NewPanels"), "completed")
		
	print ("unlcoked levels is "+str(GlobalVars.unlocked_levels))
	
	print ("new panels in "+str(GlobalVars.new_panels))
	

	
	$"%LoadTimer".stop()
	_hide_anim()
	
	if GlobalVars.new_panels.size()>0:
		$"%ComicButton".texture_normal = load(book_btn_alert)
	else:
		$"%ComicButton".texture_normal = load(book_btn_image)
	
	for level in GlobalVars.level_menu_data:
		print (level)
		var active = GlobalVars.unlocked_levels.has(level)
		var level_box = level_template.instance()
		level_box.set_image(level, active)
		grid.add_child(level_box)
	GlobalSignals.connect("menu_start_level", self, "_start_level")

func _start_level(level_scene):
	get_tree().change_scene(GlobalVars.level_menu_data[level_scene]["scene"])
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ComicButton_pressed():
	get_tree().change_scene("res://UI_Scenes/ComicBook.tscn")
	


func _on_SignOut_pressed():
	FirebaseRest.user_info = {}
	GlobalVars.carried_inventory = []
	GlobalVars.wearing_skates = false
	GlobalVars.wearing_gloves = false
	GlobalVars.wearing_mask = false
	GlobalVars.wearing_coat = false
	GlobalVars.using_drone = false
	GlobalVars.last_added = ""
	GlobalVars.temp_inventory = []
	GlobalVars.temp_drone_inventory = []
	GlobalVars.temp_shelves = []	
	GlobalVars.unlocked_levels = ["TheJourney"]
	get_tree().change_scene("res://UI_Scenes/TitleMenu.tscn")
	


func _on_LoadTimer_timeout():
	$"%LoadingAnim".play("loading")
	$"%LoadingAnim".visible = true

func _hide_anim():
	$"%LoadingAnim".stop()
	$"%LoadingAnim".visible = false
	


func _on_HowToPlay_pressed():
	get_tree().change_scene("res://UI_Scenes/HowToPlay.tscn")


func _on_TouchControls_toggled(button_pressed):
	if button_pressed:
		$"%touch_icon".visible = true
		$"%key_icon".visible = false
		$"%control_label".text = "Touch"
		GlobalVars.use_touch_controls = true
		$"%TouchControls".pressed = true
	else:
		$"%touch_icon".visible = false
		$"%key_icon".visible = true
		$"%control_label".text = "Keyboard"
		GlobalVars.use_touch_controls = false		
