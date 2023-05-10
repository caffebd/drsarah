extends Control


onready var vocab_panel = $"%PlayerGirl/UIControl/VocabPanel"
onready var player_sentence_panel = $"%PlayerGirl/UIControl/SentencePanel"
onready var drone_sentence_panel = $"%Drone/DroneCam/SentencePanelDrone"

onready var speak_panel = $"%PlayerGirl/UIControl/SpeakBG"
onready var drone_speak_panel = $"%Drone/DroneCam/SpeakBG"

onready var speak_box = $"%PlayerGirl/UIControl/SpeakBG/SpeakFill/Margin/Speak"
onready var drone_speak_box = $"%Drone/DroneCam/SpeakBG/SpeakFill/Margin/Speak"
#onready var inventory_bar = $"%InventoryPanel"
onready var player = $"%PlayerGirl"
onready var drone = $"%Drone"

onready var shelves = [$"%Shelf"]

onready var barrier_left := $IntroVillageMapA/Convo1Barrier/BarrierLeft
onready var barrier_right := $IntroVillageMapA/Convo1Barrier/BarrierRight

onready var speak_player = $"%speak_player"

export(String) var this_level = ""
export(String) var save_level = ""

onready var maps = {
	"IntroVillageMapA":$"%IntroVillageMapA"
}

onready var player_cam = $"%PlayerGirl/PlayerCam"
onready var drone_cam = $"%Drone/DroneCam"

onready var exit_door =$"%ExitDoor"

var sentence_panel

var ghost_rope_open := false
var ghost_ladder_open := false

var g_rope
var g_ladder

onready var game_objects = {
	"the medicine":	$"%FirstAid"	,
	"the boy":$"%VillageBoy",
	"the girl":$"%VillageGirl"
}

var all_scenes_list = {}

var shelf_correct_order:= []
#var shelf_placed_items := ["","",""]

var set_rope = preload("res://scenes_two/Rope.tscn")
var set_ladder = preload("res://scenes_two/Ladder.tscn")

#var set_ladder = preload("res://scenes_two/Ladder.tscn")
#var set_rope = preload("res://scenes_two/Rope.tscn")
#var set_glass = preload("res://scenes_two/Glass.tscn")
#var set_cup = preload("res://scenes/Cup.tscn")
#var green_crystal = preload("res://scenes_two/GreenCystal.tscn")
#var pink_crystal = preload("res://scenes_two/PinkCrystal.tscn")
#var blue_crystal = preload("res://scenes_two/BlueCrystal.tscn")

var ghost_ladder = preload("res://scenes_two/GhostLadder.tscn")
var ghost_rope = preload("res://scenes_two/GhostRope.tscn")

var room_items = {}

onready var spawns = [
	$IntroVillageMapA/Spawn1,
	$IntroVillageMapA/Spawn2
	]

var conversation_one = [
	{
	"speaker":"Sarah",
	"text":	"I finally made it through the jungle. This looks like the village.",
	"voice":"res://assets/audio/dr_sarah_script_audio/made_it_through_jungle.mp3",
	"spacebar": true
	},
	{
	"speaker":"Sarah",
	"text":	"I should pick up my medicine kit and get moving.",
	"voice":"res://assets/audio/dr_sarah_script_audio/get_medicine_kit.mp3",
	"spacebar": true
	},	
	]

var conversation_two = [
	{
	"speaker":"Sarah",
	"text":	"I need to jump over this gap.",
	"voice":"res://assets/audio/dr_sarah_script_audio/need_jump.mp3",
	"spacebar": true
	}	
	]

var my_conversations: Array

var convo_count := 0

var spawn_count = 0

var saved_sentences = []

var boy_given := false

var first_tutorial := false

func _ready():
	VisualServer.set_default_clear_color(Color(0.458, 0.803, 0.929, 1.0))
	GlobalSignals.connect("drop_ladder", self, "_ghost_ladder")
	GlobalSignals.connect("drop_rope", self, "_ghost_rope")
	GlobalSignals.connect("place_ladder", self, "_drop_ladder")
	GlobalSignals.connect("place_rope", self, "_drop_rope")
	GlobalSignals.connect("reload_level", self, "_reload_level")
	GlobalSignals.connect("online_status", self, "_online_status")
	GlobalSignals.connect("vocab_button_pressed", self, "_build_sentence") 
	GlobalSignals.connect("add_with_preposition", self, "_with_preposition") 
	GlobalSignals.connect("object_button_pressed", self, "_add_object")
	GlobalSignals.connect("update_on_hover", self, "_add_object_hover")
	GlobalSignals.connect("remove_object", self, "_remove_object")
	GlobalSignals.connect("speak", self, "_speak")
	GlobalSignals.connect("remove_speak_panel", self, "_remove_speak")
	GlobalSignals.connect("place_on_shelf", self, "_place_on_shelf")
	GlobalSignals.connect("remove_from_shelf", self, "_remove_from_shelf")
	GlobalSignals.connect("glass_box_broken", self, "_glass_smash_sound")
	GlobalSignals.connect("update_room_save", self, "update_object_data")
	GlobalSignals.connect("remove_from_game_objects", self, "remove_from_game_objects")
	GlobalSignals.connect("add_to_inventory_list", self, "_add_to_inventory_list")
	GlobalSignals.connect("add_to_inventory_list_drone", self, "_add_to_inventory_list_drone")
	GlobalSignals.connect("add_to_inventory_list_from_drone", self, "_add_to_inventory_list_from_drone")
	GlobalSignals.connect("drone_items_to_player", self, "_drone_items_to_player")
	GlobalSignals.connect("remove_from_inventory_list", self, "_remove_from_inventory_list")
	GlobalSignals.connect("release_drone", self, "_release_drone")
	GlobalSignals.connect("save_game", self, "_save_game")
	GlobalSignals.connect("load_game", self, "_load_game")
	GlobalSignals.connect("save_sentence", self, '_save_sentence')
	GlobalSignals.connect("tut_to_give", self, "tut_to_give")
	GlobalSignals.connect("tut_to_push", self, "tut_to_push")
	GlobalSignals.connect("tut_to_medicine", self, "tut_to_medicine")
	GlobalSignals.connect("button_pressed", self, "_button_pressed")
	GlobalSignals.connect("medicine_pressed", self, "_medicine_pressed")
	GlobalSignals.connect("convo_barriers", self, "convo_one_barrier")	
	GlobalSignals.connect("clicker", self, "clicker")
	GlobalSignals.connect("collector", self, "collector")
	
	GlobalVars.current_level = this_level
	GlobalVars.save_level = save_level
	
	GlobalVars.shelf_placed_items = []
	
	if GlobalVars.play_music:
		$"%music".play()
	
	my_conversations.append(conversation_one)
	my_conversations.append(conversation_two)

	GlobalSignals.emit_signal("refresh_inventory")
	for item in shelves:
		shelf_correct_order.append(item.shelf_item)
	
	for i in shelves:
		GlobalVars.shelf_placed_items.append("")
	print (GlobalVars.shelf_placed_items)
	
	get_scene_files()
	
	if GlobalVars.using_drone:
		sentence_panel = drone_sentence_panel
		GlobalVars.current_player = drone
	else:
		sentence_panel = player_sentence_panel
		GlobalVars.current_player = player	

	if !GlobalVars.unlocked_levels.has(this_level):
		GlobalVars.unlocked_levels.append(this_level)
		FirebaseRest.update_active()
	
	_load_game(GlobalVars.load_from_door, GlobalVars.load_from_entry)
	GlobalVars.load_from_door = false
	GlobalVars.load_from_entry = false
	
	
	
#	_place_on_shelf_any_item("Use the green crystal on the first shelf", 0)
	
#	FirebaseRest.room_items_game = room_items.duplicate()
	
#	update_object_data()

#func _online_status(status: bool):
#	$OnlineBar.visible = !status

func _save_sentence(sentence):
	if !saved_sentences.has(sentence):
		saved_sentences.append(sentence)

func get_scene_files():
	var game_object_keys = Array(game_objects.keys())
	for key in game_object_keys:
		all_scenes_list[key] = game_objects[key].get_filename()
		print (game_objects[key].get_parent().name)
	print (all_scenes_list)
		

func check_first_time():
	var user_id = FirebaseRest.user_info.id
	room_items = yield(FirebaseRest.get_document_level("EnglishAdventure/"+user_id+"/Game/"+GlobalVars.current_level), "completed")
	print (room_items)
	if room_items.empty():
		print ("DO FIRST SAVE HERE")
		update_object_data()
	else:
		setup_room_items()

func setup_room_items():
	var game_objects_keys = Array (game_objects.keys())
	print (game_objects_keys)
	for item in room_items:
		if !game_objects_keys.has(item):
			var obj = load(all_scenes_list[item]).instance()
			maps[room_items[item].map].add_child(obj)
			game_objects[item] = obj

		var cur_parent = game_objects[item].get_parent()
		cur_parent.remove_child(game_objects[item])
		maps[room_items[item].map].add_child(game_objects[item])
		if game_objects[item].get_class() == "TextureButton":
			game_objects[item].rect_position.x = room_items[item].position_x
			game_objects[item].rect_position.y = room_items[item].position_y
		else:
			game_objects[item].position.x = room_items[item].position_x
			game_objects[item].position.y = room_items[item].position_y
		game_objects[item].is_on_shelf = room_items[item].on_shelf
		game_objects[item].state = room_items[item].state
		game_objects[item].is_active = room_items[item].active
		if game_objects[item].state != "null":
			game_objects[item].set_state(game_objects[item].state)
#		if room_items[item].active == false:
#			game_objects[item].queue_free()
		print ("LOOK LOOK "+item)
		if item == "the rope":
			game_objects[item].extend = true
	var room_item_keys = Array (room_items.keys())
	print (room_item_keys)
	print (game_objects.size())
	var remove_list = []
	for game_item in game_objects:
		print (game_item)
		if !room_item_keys.has (game_item):
			print ("TO REMOVE "+game_item)
			remove_list.append(game_item)
#			if is_instance_valid(game_objects[game_item]):
#				game_objects[game_item].queue_free()
#				remove_from_game_objects(game_item)
				
#	delete items not in fb array
	if remove_list.size()>0:
		for remove in remove_list:
			if is_instance_valid(game_objects[remove]):
				game_objects[remove].queue_free()
				remove_from_game_objects(remove)
	
	var user_id = FirebaseRest.user_info.id				
	yield(FirebaseRest.get_document_player("EnglishAdventure/"+user_id+"/Game/Player"), "completed")
	setup_inventory_items()
	
#	yield(FirebaseRest.get_document("EnglishAdventure/"+user_id+"/Game/Drone"), "completed")
	setup_drone_inventory_items()
	
	setup_saved_sentences()	

		
func remove_from_game_objects(item:String):
	game_objects.erase(item)
	print (game_objects)

func add_to_game_objects(key: String, item):
	room_items[key]=item
	
func _add_to_inventory_list_drone(label: String):
	if !GlobalVars.drone_carried_inventory.has(label):
		GlobalVars.drone_carried_inventory.append(label)
		print ("INVENTORY add for drone")
		print (GlobalVars.drone_carried_inventory)


func _add_to_inventory_list(label: String):
		if !GlobalVars.carried_inventory.has(label):
			GlobalVars.carried_inventory.append(label)
			print ("INVENTORY add")
			print (GlobalVars.carried_inventory)

func _add_to_inventory_list_from_drone(label: String):
	if !GlobalVars.carried_inventory.has(label):
		GlobalVars.carried_inventory.append(label)
		print ("INVENTORY add")
		print (GlobalVars.carried_inventory)
		if GlobalVars.drone_carried_inventory.has(label):
			GlobalVars.drone_carried_inventory.erase (label)
			GlobalSignals.emit_signal("remove_all_inventory_drone")
			print ("INVENTORY remove drone"+label)
			print (GlobalVars.drone_carried_inventory)

func _remove_from_inventory_list(label: String):
	if GlobalVars.using_drone:
		if GlobalVars.drone_carried_inventory.has(label):
			GlobalVars.drone_carried_inventory.erase (label)
			print ("INVENTORY remove drone"+label)
			print (GlobalVars.drone_carried_inventory)
	else:
		if GlobalVars.carried_inventory.has(label):
			GlobalVars.carried_inventory.erase (label)
			print ("INVENTORY remove "+label)
			print (GlobalVars.carried_inventory)

func update_object_data():
	var game_object_keys = Array(game_objects.keys())
	var temp_items: Dictionary = {}
	for key in game_object_keys:
		print (key)
		var pos_x = 0.0
		var pos_y = 0.0
		if game_objects[key].get_class() == "TextureButton":
			pos_x = game_objects[key].rect_position.x
			pos_y = game_objects[key].rect_position.y
		else:
			pos_x = game_objects[key].position.x
			pos_y = game_objects[key].position.y
		var active = game_objects[key].is_active
		var on_shelf = game_objects[key].is_on_shelf
		var state = game_objects[key].state
		var inventory = game_objects[key].is_inventory_item
		var scene = game_objects[key].get_filename()
		var map = game_objects[key].get_parent().name
		var temp = {
		"scene": scene,
		"inventory": inventory,
		"active": active,
		"on_shelf":on_shelf,
		"state":state,
		"position_x": pos_x, 
		"position_y":pos_y,
		"map": map
		}
		temp_items[key] = temp
#	temp_items["inventory_list"] = GlobalVars.carried_inventory
#	DO DRONE INVENTORY SAVE ONLINE
#	temp_items["drone_inventory_list"] = GlobalVars.drone_carried_inventory
	temp_items["shelves"] = GlobalVars.shelf_placed_items
	temp_items["using_drone"] = GlobalVars.using_drone
	temp_items["saved_sentences"] = saved_sentences

#	print ("----------------------------")
	room_items = temp_items.duplicate()
#	print(room_items)
	print ("save player pos "+ str(player.position))
	FirebaseRest.update_level(room_items, player.position, drone.position,GlobalVars.carried_inventory,GlobalVars.drone_carried_inventory )
	

			
		

		

func _reload_level():
	get_tree().reload_current_scene()

func return_player()->KinematicBody2D:
	return player

func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		if ghost_rope_open:
			GlobalSignals.emit_signal("add_to_inventory_bar", "the rope")
			ghost_rope_open = false
			g_rope.queue_free()
		if ghost_ladder_open:
			GlobalSignals.emit_signal("add_to_inventory_bar", "the ladder")
			ghost_ladder_open = false
			g_ladder.queue_free()

func _unhandled_input(event):
	if event is InputEventMouseButton:		
		_remove_speak()

func _speak(message: String):
	$"%SpeakRemove".stop()
	if GlobalVars.using_drone:
		drone_speak_box.text = message
		drone_speak_panel.visible = true
	else:	
		speak_box.text = message
		speak_panel.visible = true
	if GlobalVars.the_player.conversation_audio.playing:
		GlobalVars.the_player.conversation_audio.stop()
	if ScriptVoice.script_voice.has(message):
		var my_voice = ScriptVoice.script_voice[message]
		print ("MY VOICE "+my_voice)
		if my_voice != null:
			speak_player.stream = load(my_voice)
			speak_player.play()
	$"%SpeakRemove".start()


func _remove_speak():
	speak_panel.visible = false
	drone_speak_panel.visible = false
	
func _on_SpeakRemove_timeout():
	_remove_speak()
	
func _build_sentence(word):
	var sentence_starter = word
	match word:
		"Look":
			sentence_starter = "Look at"
		_:
			sentence_starter = word
	sentence_panel.start_sentence(sentence_starter)

func _with_preposition(with_prep: String):
	sentence_panel.add_to_sentence(with_prep,"")
	

func _add_object():
	sentence_panel.submit_sentence()

func _add_object_hover(word, extra: String = ""):
	print ("extra is "+extra)
	if "on" in GlobalVars.current_sentence or "to" in GlobalVars.current_sentence:
		extra = ""
	if GlobalVars.text_typing:
		word = word+extra
	sentence_panel.add_to_sentence(word, extra)	

func _remove_object():
	sentence_panel.remove_object()


func _release_drone(state):
	if state:
		drone.position = player.position
		drone_cam.current = true
		player_cam.visible = false
		drone.visible = true
		sentence_panel = drone_sentence_panel
		GlobalVars.current_player = drone
	else:
		player_cam.current = true
		drone.visible = false
		player_cam.visible = true
		sentence_panel = player_sentence_panel
		GlobalVars.current_player = player

func _ghost_rope():
	ghost_rope_open = true
	GlobalSignals.emit_signal("sentence_clear")
	g_rope = ghost_rope.instance()
	var this_map = player.return_map_name()
	GlobalVars.player_pos = player.position
	maps[this_map].add_child(g_rope)
	
func _ghost_ladder():
	ghost_ladder_open = true
	GlobalSignals.emit_signal("sentence_clear")
	g_ladder = ghost_ladder.instance()
	var this_map = player.return_map_name()
	GlobalVars.player_pos = player.position
	maps[this_map].add_child(g_ladder)

func _drop_rope(pos):
	ghost_rope_open = false
	var rope = set_rope.instance()
	var this_map = player.return_map_name()
	maps[this_map].add_child(rope)
	rope.user_drop = true
	rope.extend = true
	GlobalVars.just_got_rope = false
	game_objects["the rope"] = rope
	rope.rect_position = pos

func _drop_ladder(pos):
	ghost_ladder_open = false
	var ladder = set_ladder.instance()
	var this_map = player.return_map_name()
	maps[this_map].add_child(ladder)
	game_objects["the ladder"] = ladder
#	add_to_game_objects("the ladder", ladder)
#	_remove_from_inventory_list("the ladder")	
	ladder.rect_position = pos
	$LadderDrop.play()
#	Vector2(player.position.x-50, player.position.y-280)
	
	
func _place_on_shelf(sentence: String, shelf: int):
	if GlobalVars.shelf_placed_items[shelf] != "":
		GlobalSignals.emit_signal("speak", "There is something on the shelf already.")
		return
	for check in GlobalVars.inventory_items:
		print (check)
		if check in sentence:
			var obj = load(GlobalVars.inventory_items[check]["scene"]).instance()
			var this_map = shelves[shelf].get_parent().name
			print ("shelf is in map "+this_map)
			maps[this_map].add_child(obj)
			game_objects[check] = obj
			var width  = shelves[shelf].rect_size.x/2
			var height = shelves[shelf].rect_size.y/2
			obj.rect_position = Vector2(shelves[shelf].rect_position.x + width - 56, shelves[shelf].rect_position.y-height-25)
			obj.is_on_shelf = true
			GlobalVars.shelf_placed_items[shelf] = check
			GlobalSignals.emit_signal("item_placed_on_shelf",check )
			GlobalSignals.emit_signal("save_sentence", sentence)
#			add_to_game_objects(check, obj)
			_remove_from_inventory_list(check)
			_check_shelves(true)		
			
			
#shelves[shelf].rect_position.x, shelves[shelf].rect_position.y-90)

func _check_shelves(can_save:bool):
	if GlobalVars.shelf_placed_items == shelf_correct_order:
		print ("shelves correct")
		GlobalSignals.emit_signal("save_sentence", "the door opened")
		for item in shelf_correct_order:
			game_objects[item].set_state("off")
		if can_save:
			_save_game()
		GlobalSignals.emit_signal("open_door")
		print (saved_sentences)

		
	else:
		print("shelves wrong")

func _remove_from_shelf(item: String):
	print ("remove "+item)
	for i in GlobalVars.shelf_placed_items.size():
		if GlobalVars.shelf_placed_items[i] == item:
			GlobalVars.shelf_placed_items[i] = ""

func setup_shelves_after_load():
	GlobalVars.shelf_placed_items = []
	GlobalSignals.emit_signal("close_door")
	for s in shelves:
		GlobalVars.shelf_placed_items.append("")
	for i in GlobalVars.temp_shelves.size():
		GlobalVars.shelf_placed_items[i] = GlobalVars.temp_shelves[i]
	print ("loaded shelves "+str(GlobalVars.shelf_placed_items))
	_check_shelves(false)
	GlobalSignals.emit_signal("fade_in")
	GlobalVars.temp_shelves = []

func _glass_smash_sound():
	$GlassBreak.play()

#func _on_InventoryBtn_toggled(button_pressed):
#	inventory_panel.visible = button_pressed
#	if inventory_panel.visible:
#		inventory_panel.update_inventory_from_firebase()


#func _on_ActionTimer_timeout():
#	print ("action timer")
#	MyFirebaseFunctions.action_check()


func _save_game():
	update_object_data()
#	FirebaseRest.update_level(room_items)


func _load_game(from_door: bool, from_entry:bool):
	var user_id = FirebaseRest.user_info.id
	room_items = yield(FirebaseRest.get_document_level("EnglishAdventure/"+user_id+"/Game/"+GlobalVars.current_level), "completed")
	print (room_items)
	if room_items == null:
		print ("EMOTY NO SAVES")
		GlobalSignals.emit_signal("fade_in")
		var yield_timer = Timer.new()
		add_child(yield_timer)
		yield_timer.start(1); yield(yield_timer, "timeout")
#		yield(get_tree().create_timer(1), "timeout")
		
		
#		PUTBACK
		begin_tutorial()
		return
	
	print ("Load -> gone past room items check")
	GlobalSignals.emit_signal("remove_all_inventory")
	GlobalSignals.emit_signal("remove_all_inventory_drone")
	
	print (GlobalVars.carried_inventory)

	setup_room_items()
#	setup_inventory_items()
	setup_shelves_after_load()
	GlobalSignals.emit_signal("release_drone", GlobalVars.using_drone)
	GlobalSignals.emit_signal("update_drone_position", GlobalVars.temp_drone_pos)
	if !from_door:
		GlobalSignals.emit_signal("update_player_position", GlobalVars.temp_player_pos)
	if from_entry:
		GlobalSignals.emit_signal("update_player_position", exit_door.position)

func setup_inventory_items():
	for i in range(0, GlobalVars.temp_inventory.size()):
		print ("from load inv set "+GlobalVars.temp_inventory[i])
		GlobalSignals.emit_signal("add_to_inventory_bar_load", GlobalVars.temp_inventory[i])
	GlobalVars.temp_inventory = []
#		yield(get_tree().create_timer(0.2), "timeout")

func setup_drone_inventory_items():
	for i in range(0, GlobalVars.temp_drone_inventory.size()):
		print ("from load drone inv set "+GlobalVars.temp_drone_inventory[i])
		GlobalSignals.emit_signal("add_to_inventory_bar_drone", GlobalVars.temp_drone_inventory[i])
#		yield(get_tree().create_timer(0.2), "timeout")
	GlobalVars.temp_drone_inventory = []

	if GlobalVars.using_drone:
		sentence_panel = drone_sentence_panel
		GlobalVars.current_player = drone
	else:
		sentence_panel = player_sentence_panel
		GlobalVars.current_player = player

func setup_saved_sentences():
	for sent in GlobalVars.temp_sentences:
		print ("Loaded sentence is "+sent)
		if !saved_sentences.has(sent):
			saved_sentences.append(sent)
	GlobalVars.temp_sentences = []
	print ("all sentences from load "+str(saved_sentences))

func _drone_items_to_player():
	if GlobalVars.drone_carried_inventory.size()>0:
		var item = GlobalVars.drone_carried_inventory[0]
		GlobalSignals.emit_signal("add_to_inventory_bar_from_drone", item)


func _on_DeathArea_body_entered(body):
	if body.name=="PlayerGirl":
		GlobalSignals.emit_signal("speak","Yikes, I need to be more careful!")
#		yield(get_tree().create_timer(1.5), "timeout")
		var yield_timer = Timer.new()
		add_child(yield_timer)
		yield_timer.start(1.5); yield(yield_timer, "timeout")
		GlobalSignals.emit_signal("fade_out", true)
#		yield(get_tree().create_timer(0.5), "timeout")
		var yield_timer_2 = Timer.new()
		add_child(yield_timer_2)
		yield_timer_2.start(0.5); yield(yield_timer_2, "timeout")
		player.position = spawns[spawn_count].position
#		yield(get_tree().create_timer(1.5), "timeout")
		var yield_timer_3 = Timer.new()
		add_child(yield_timer_3)
		yield_timer_3.start(1.5); yield(yield_timer_3, "timeout")
		
		_remove_speak()
	


func _on_Spawn2_body_entered(body):
	if body.name == "PlayerGirl":
		spawn_count = 1

func convo_one_barrier(state):
	print ("barr "+str(state))
	call_deferred("change_barrier", state)

func change_barrier(state):
	barrier_left.disabled = state
	barrier_right.disabled = state

func change_lever_area(state):
	$IntroVillageMapA/DoorTut/DoorTutArea.disabled = state
	GlobalVars.tutorial_active = false

func tut_to_give():
#	GlobalSignals.emit_signal("speak", " Follow the arrow. Click on the word Get.") 
	GlobalVars.the_player.tut_to_give()

func tut_to_medicine():
	GlobalVars.the_player.tut_to_medicine()

func tut_to_boy():
#	GlobalSignals.emit_signal("speak", "Click on the boy.")
#	GlobalSignals.emit_signal("boy_clicks", 0)
	GlobalVars.the_player.tut_to_boy($"%VillageBoy".get_global_transform_with_canvas().origin)

func tut_to_girl():
	GlobalSignals.emit_signal("speak", "Click on the girl.")
#	GlobalSignals.emit_signal("girl_clicks", 0)
	GlobalVars.the_player.tut_to_girl($"%VillageGirl".get_global_transform_with_canvas().origin)

func _medicine_pressed():
	if GlobalVars.girl_waiting:
		tut_to_girl()
	elif GlobalVars.boy_waiting :
		tut_to_boy()

func _button_pressed(btn):
	if btn == "Give" and GlobalVars.tut_count == 0:
		tut_to_medicine()
	if btn == "the boyfirst":
#		GlobalSignals.emit_signal("boy_clicks", 1)
		boy_given = true
		if GlobalVars.boy_waiting:
#			GlobalVars.boy_waiting = false
			GlobalVars.girl_waiting = true
			GlobalSignals.emit_signal("speak", "Now give some medicine to the girl.")
			tut_to_give()
#			
#	if btn == "the boysecond":
#		boy_given = true
#		GlobalSignals.emit_signal("boy_clicks", 2)
#		GlobalSignals.emit_signal("speak", "Now give some medicine to the girl.")
#		tut_to_give()
	if btn == "the girlfirst":
#		GlobalSignals.emit_signal("girl_clicks", 1)
#		call_deferred("change_lever_area", false)
#		GlobalSignals.emit_signal("speak", "Click again on the girl.")
#	if btn == "the girlsecond":
#		GlobalSignals.emit_signal("girl_clicks", 2)
		if GlobalVars.girl_waiting:
			
			call_deferred("change_lever_area", false)
	if btn == "Push" and GlobalVars.tut_count == 1:
#		GlobalSignals.emit_signal("lever_clicks", 0)
		tut_to_lever()
	if btn == "the leverfirst":
#		GlobalSignals.emit_signal("lever_clicks", 2)
		GlobalSignals.emit_signal("speak", "Go through the door.")
		GlobalVars.tutorial_active = false
		GlobalVars.the_player.tut_done()
		call_deferred("change_lever_area", true)
		save_end_tutorial()
#	if btn == "the leversecond":
#		GlobalSignals.emit_signal("lever_clicks", 2)
#		GlobalSignals.emit_signal("speak", "Go through the door.")
#		GlobalVars.tutorial_active = false
#		GlobalVars.the_player.tut_done()
#		call_deferred("change_lever_area", true)
#		save_end_tutorial()
	if btn == "Get":
		if !GlobalVars.carried_inventory.has("the medicine"):
			if game_objects.has("the medicine"):
				GlobalSignals.emit_signal("speak", "Click on the medicine box to get it.")
				GlobalVars.the_player.tut_to_medicine_get(game_objects["the medicine"].get_global_transform_with_canvas().origin)
	if btn == "the medicinefirst" and game_objects.has("the medicine"):
		_remove_speak()
		GlobalVars.tutorial_active = false
		GlobalVars.the_player.tut_done()
		GlobalVars.the_player.tut_arrow_keys("right")
		GlobalSignals.emit_signal("speak", "Press the RIGHT arrow key to walk.")
#	if btn == "the medicinesecondget":
#		_remove_speak()
#		GlobalVars.tutorial_active = false
#		GlobalVars.the_player.tut_done()
#		GlobalVars.the_player.tut_arrow_keys("right")
#		GlobalSignals.emit_signal("speak", "Press the RIGHT arrow key to walk.")
		
		

func tut_to_push():

	GlobalVars.the_player.tut_to_push()		


func _on_DoorTut_body_entered(body):
	if body.name == "PlayerGirl":
		GlobalVars.tutorial_active = true
		GlobalSignals.emit_signal("speak","Click on Push.")
		tut_to_push()

func tut_to_lever():
	GlobalVars.the_player.tut_to_lever($"%Lever".get_global_transform_with_canvas().origin)

func tut_to_medicine_get():
	GlobalVars.the_player.tut_to_get()	

func begin_tutorial():
	print ("BEGIN TUT")
	first_tutorial = true
	GlobalSignals.emit_signal("conversation_time", my_conversations[convo_count], self, "Sarah")


func callback_from_converastion_end():
	if convo_count == 0:
		GlobalVars.tutorial_active = true
		GlobalVars.the_player.tut_to_get()
	if convo_count == 1:
		GlobalVars.the_player.tut_arrow_keys("up")
		GlobalSignals.emit_signal("speak", "Press UP to jump.")
#		yield(get_tree().create_timer(4), "timeout")
		var yield_timer = Timer.new()
		add_child(yield_timer)
		yield_timer.start(4); yield(yield_timer, "timeout")
		
		_remove_speak()
	


func _on_JumpTut_body_entered(body):
	if body.name == "PlayerGirl":
		_remove_speak()
		convo_count = 1
		GlobalSignals.emit_signal("conversation_time", my_conversations[convo_count], self, "Sarah")


func _on_CanClimbRope_body_entered(body):
	if body.name=="PlayerGirl":
		GlobalSignals.emit_signal("speak", "I think I can climb that rope.")


func _on_rope_area_body_entered(body):
	if (body.name == "PlayerGirl"):
		GlobalSignals.emit_signal("can_climb", true, "climb_rope")
		GlobalVars.the_player.tut_arrow_keys("up")
		GlobalSignals.emit_signal("speak", "Press the UP arrow key to climb the rope.")
	

func _on_rope_area_body_exited(body):
	if (body.name == "PlayerGirl"):
		GlobalSignals.emit_signal("can_climb", false, "climb_rope")



	


func _on_UpArrowTrigger_body_entered(body):
	if (body.name == "PlayerGirl"):
		GlobalVars.the_player.tut_arrow_keys("up")
		GlobalSignals.emit_signal("speak", "Press the UP arrow key to go trough the door.")
	

func running():
	print ("RUNING SOUND")
	$"%running".play()
	_run_right()


func _run_right():
	var tween = create_tween()
	tween.tween_property($run_node, "position", Vector2(12870, 700), 6)
	tween.tween_callback(self, "_run_left")

func _run_left():
	var tween = create_tween()
	tween.tween_property($run_node, "position", Vector2(10450, 500), 6)
	tween.tween_callback(self, "_run_right")	

func save_end_tutorial():
	GlobalVars.unlocked_levels.append("Lower1")
	FirebaseRest.update_active()


func _on_swim_warning_body_entered(body):
	if body.name == "PlayerGirl":
		GlobalSignals.emit_signal("speak", "Looks like I am going to have to swim.")


func clicker():
	$"%clicker".play()
	
func collector():
	$"%collector".play()
