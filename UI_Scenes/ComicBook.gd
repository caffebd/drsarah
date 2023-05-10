extends Control


onready var comic_grid = $"%Panels"

onready var pages_grid = $"%PagesGrid"



var comic_panel = preload("res://UI_Scenes/ComicPanel.tscn")

var comic_sentences = []

var selected_level = ""

var scroll_down := false
var scroll_up := false

# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color(0.86,0.86, 0.54, 1.0))
	GlobalSignals.connect("read_comic_panel", self, "_read_panel")
	make_buttons()

func _read_panel(to_read):
	$"%Read".stream = load(to_read)
	$"%Read".play()

func make_buttons():
	var button_scene = load("res://UI_Scenes/ComicPageButton.tscn")
	for level in GlobalVars.level_menu_data:
		print (level)
		if !GlobalVars.unlocked_levels.has(level):
			continue
		if level != "TheJourney":
			var btn_name = GlobalVars.level_menu_data[level]["label"]
			var btn = button_scene.instance()
			btn.set_up_button(btn_name, level)
			btn.connect("pressed", self, "_on_pressed", [level])
			$"%PagesGrid".add_child(btn)
	if 	GlobalVars.unlocked_levels.has("TheVillage"):	
		_on_pressed("TheVillage")




func make_comic():
	_remove_all_panels()
	for sent in comic_sentences:
		if !GlobalVars.comic_events[selected_level].has(sent):
			continue
		var image = GlobalVars.comic_events[selected_level][sent]["image"]
		var text = GlobalVars.comic_events[selected_level][sent]["label"]
		var voice = GlobalVars.comic_events[selected_level][sent]["voice"]
		var panel = comic_panel.instance()
		panel.setup_panel(image, text, voice)
		comic_grid.add_child(panel)
	if $"%ScrollContainer".get_v_scroll() > 100:
		for i in 400:
			$"%ScrollContainer".set_v_scroll ( $"%ScrollContainer".get_v_scroll() - 10)
			yield(get_tree().create_timer(0.002), "timeout")
			if 	$"%ScrollContainer".get_v_scroll() <=0:
				break
		
func _remove_all_panels():
	var inv_items = comic_grid.get_children()
	for inv in inv_items:
		inv.queue_free()


func _on_pressed(btn: String):
	for other_btn in $"%PagesGrid".get_children():
		print (other_btn.my_label)
		print (btn)
		if other_btn.my_label != btn:
			other_btn.selected(false)
		else:
			other_btn.selected(true)
	$"%PageTitle".text = GlobalVars.level_menu_data[btn]["label"]
	selected_level = btn
	if selected_level == "TheVillage":
		comic_sentences = GlobalVars.village_sentences
		make_comic()
	else:
		var user_id = FirebaseRest.user_info.id
		comic_sentences = yield(FirebaseRest.get_comic_panels("EnglishAdventure/"+user_id+"/Game/"+selected_level), "completed")
		print ("In comic the sentences are "+str(comic_sentences))
		if comic_sentences[0]!="empty":
			make_comic()
		else:
			_remove_all_panels()
			_play_level()
#		if GlobalVars.new_panels.has(btn):
#			var index = GlobalVars.new_panels.find(btn)
#			GlobalVars.new_panels.remove(index)
#			yield (FirebaseRest.update_new_panels(),"completed")
			


func _on_Play_Levels_pressed():
	get_tree().change_scene("res://UI_Scenes/LevelSelect.tscn")

func _play_level():
	var panel = comic_panel.instance()
	var image := "res://assets/ui/default_comic_panel.png"
	var text := "Play this level to create your story."
	var voice := "res://assets/audio/dr_sarah_script_audio/play_level_create_story.mp3"
	panel.setup_panel(image, text, voice)
	comic_grid.add_child(panel)

func _process(delta):
	if Input.is_mouse_button_pressed(1):
		if scroll_down:
			$"%ScrollContainer".set_v_scroll ($"%ScrollContainer".get_v_scroll() + 6)
		elif scroll_up:
			$"%ScrollContainer".set_v_scroll ($"%ScrollContainer".get_v_scroll() - 6)
		
#		yield(get_tree().create_timer(0.005), "timeout")	

func _on_ScrollDown_button_down():
	scroll_down = true

func _on_ScrollDown_button_up():
	scroll_down = false


func _on_ScrollUp_button_down():
	scroll_up = true


func _on_ScrollUp_button_up():
	scroll_up = false
