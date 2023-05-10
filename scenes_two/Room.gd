extends Control


onready var vocab_panel = $"%VocabPanel"
onready var player_sentence_panel = $"%SentencePanel"
onready var drone_sentence_panel = $"%SentencePanelDrone"

onready var speak_panel = $"%SpeakBG"
onready var drone_speak_panel = $"%DroneSpeakBG2"

onready var speak_box = $"%SpeakBG/Speak"
onready var drone_speak_box = $"%DroneSpeakBG2/Speak"
onready var inventory_bar = $"%InventoryPanel"
onready var player = $"%PlayerGirl"
onready var drone = $"%Drone"

onready var shelves = [$"%Shelf",$"%Shelf2",$"%Shelf3"]

export(String) var this_level = ""

onready var maps = {
	"mapA": $"%mapA",
	"mapB": $"%mapB"
}

onready var player_cam = $"%CameraPlayer"
onready var drone_cam = $"%Camera2DDrone"

var sentence_panel

var ghost_rope_open := false
var ghost_ladder_open := false

var g_rope
var g_ladder

onready var game_objects = {
	"the ladder":$"%Ladder",
	"the gold cup": $"%CupBtn2",
	"the fire": 	$"%FireBtn",
	"the glass of water": $"%Glass",
	"the green crystal": $"%GreenCystal",
	"the pink crystal":$"%PinkCrystal",
	"the blue crystal":$"%BlueCrystal",
	"the lever":$"%Lever",
	"the old log":$"%Log",
	"cup inside glass box":$"%CupInGlass",
	"the glass box":$"%GlassBox",
	"the hammer":$"%Hammer",
	"the yellow crystal": $"%YellowCrystal",
	"the roller skates":$"%Skate",
	"the climbing gloves":$"%Gloves",
	"the rope":$"%Rope",
	"the diving mask":$"%ScubaMask",
	"the fireproof coat": $"%FireCoat",
	"the weak wall":$"%BreakableWall1",
	"the drone":$"%TheDrone",
	"the fuse box":$"%FuseBox",
	"the fuse":$"%TheFuse",
	"the switch":$"%LeverNeedFuse",
	"the alpha door":$"%AlphaDoor",
	"the alpha key":$"%AlphaKey"
		
}

var all_scenes_list = {}

var shelf_correct_order:= []
#var shelf_placed_items := ["","",""]

var set_ladder = preload("res://scenes_two/Ladder.tscn")
var set_rope = preload("res://scenes_two/Rope.tscn")
var set_glass = preload("res://scenes_two/Glass.tscn")
var set_cup = preload("res://scenes/Cup.tscn")
var green_crystal = preload("res://scenes_two/GreenCystal.tscn")
var pink_crystal = preload("res://scenes_two/PinkCrystal.tscn")
var blue_crystal = preload("res://scenes_two/BlueCrystal.tscn")

var ghost_ladder = preload("res://scenes_two/GhostLadder.tscn")
var ghost_rope = preload("res://scenes_two/GhostRope.tscn")

var room_items = {}




func _ready():
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

	Firebase.Auth.connect("login_succeeded", self, "_on_FirebaseAuth_login_succeeded")
	Firebase.Auth.connect("login_failed", self, "on_login_failed")
	Firebase.Auth.connect("userdata_received", self, "userdata_received")	

	GlobalVars.current_level = this_level

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


	
#	_place_on_shelf_any_item("Use the green crystal on the first shelf", 0)
	
#	FirebaseRest.room_items_game = room_items.duplicate()
	
#	update_object_data()

#func _online_status(status: bool):
#	$OnlineBar.visible = !status

func get_scene_files():
	var game_object_keys = Array(game_objects.keys())
	for key in game_object_keys:
		all_scenes_list[key] = game_objects[key].get_filename()
		print (game_objects[key].get_parent().name)
	print (all_scenes_list)
		

func check_first_time():
	var user_id = FirebaseRest.user_info.id
	room_items = yield(FirebaseRest.get_document("EnglishAdventure/"+user_id+"/Levels/"+GlobalVars.current_level), "completed")
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
		game_objects[item].rect_position.x = room_items[item].position_x
		game_objects[item].rect_position.y = room_items[item].position_y
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
	yield(FirebaseRest.get_document("EnglishAdventure/"+user_id+"/Levels/Player"), "completed")
	setup_inventory_items()
	
#	yield(FirebaseRest.get_document("EnglishAdventure/"+user_id+"/Levels/Drone"), "completed")
	setup_drone_inventory_items()	

		
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
		var pos_x = game_objects[key].rect_position.x
		var pos_y = game_objects[key].rect_position.y
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

#	print ("----------------------------")
	room_items = temp_items.duplicate()
#	print(room_items)
	print (player.position)
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
	if GlobalVars.using_drone:
		drone_speak_box.text = message
		drone_speak_panel.visible = true
	else:	
		speak_box.text = message
		speak_panel.visible = true

func _remove_speak():
	speak_panel.visible = false
	drone_speak_panel.visible = false

	
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
	if "on" in GlobalVars.current_sentence:
		extra = ""
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
#			add_to_game_objects(check, obj)
			_remove_from_inventory_list(check)
			_check_shelves()		
			
			
#shelves[shelf].rect_position.x, shelves[shelf].rect_position.y-90)

func _check_shelves():
	if GlobalVars.shelf_placed_items == shelf_correct_order:
		print ("shelves correct")
		for item in shelf_correct_order:
			game_objects[item].set_state("off")
			
		GlobalSignals.emit_signal("open_door")
		
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
	_check_shelves()
	GlobalSignals.emit_signal("fade_in")

func _glass_smash_sound():
	$GlassBreak.play()

#func _on_InventoryBtn_toggled(button_pressed):
#	inventory_panel.visible = button_pressed
#	if inventory_panel.visible:
#		inventory_panel.update_inventory_from_firebase()


#func _on_ActionTimer_timeout():
#	print ("action timer")
#	MyFirebaseFunctions.action_check()


func _on_Button_pressed():
	update_object_data()
#	FirebaseRest.update_level(room_items)


func _on_Load_pressed():
	GlobalSignals.emit_signal("remove_all_inventory")
	GlobalSignals.emit_signal("remove_all_inventory_drone")
	
	print (GlobalVars.carried_inventory)
	var user_id = FirebaseRest.user_info.id
	room_items = yield(FirebaseRest.get_document("EnglishAdventure/"+user_id+"/Levels/"+GlobalVars.current_level), "completed")
	print (room_items)
	if room_items.empty():
		print ("EMOTY NO SAVES")
	setup_room_items()
#	setup_inventory_items()
	setup_shelves_after_load()

	
func setup_inventory_items():
	for i in range(0, GlobalVars.temp_inventory.size()):
		print ("from load inv set "+GlobalVars.temp_inventory[i])
		GlobalSignals.emit_signal("add_to_inventory_bar_load", GlobalVars.temp_inventory[i])
#		yield(get_tree().create_timer(0.2), "timeout")

func setup_drone_inventory_items():
	for i in range(0, GlobalVars.temp_drone_inventory.size()):
		print ("from load drone inv set "+GlobalVars.temp_drone_inventory[i])
		GlobalSignals.emit_signal("add_to_inventory_bar_drone", GlobalVars.temp_drone_inventory[i])
#		yield(get_tree().create_timer(0.2), "timeout")

	if GlobalVars.using_drone:
		sentence_panel = drone_sentence_panel
		GlobalVars.current_player = drone
	else:
		sentence_panel = player_sentence_panel
		GlobalVars.current_player = player


func _drone_items_to_player():
	if GlobalVars.drone_carried_inventory.size()>0:
		var item = GlobalVars.drone_carried_inventory[0]
		GlobalSignals.emit_signal("add_to_inventory_bar_from_drone", item)

#"ladder":{
#		"scene":"res://scenes_two/Ladder.tscn",
#		"inventory": false,
#		"active": true,
#		"on_shelf":false,
#		"position_x": 840, 
#		"position_y":2200,
#
#	},
#	"cup":{
#		"scene":"res://scenes/Cup.tscn",
#		"inventory": false,
#		"active": true,
#		"on_shelf":false,
#		"position_x": 4872, 
#		"position_y":1512,
#
#	},
#	"fire":{
#		"scene":"res://scenes_two/Fire.tscn",
#		"inventory": false,
#		"active": true,
#		"on_shelf":false,
#		"position_x": 72, 
#		"position_y":2144,
#
#	}

#func _place_on_shelf_old(sentence: String, shelf: int):
#	print (sentence +" on "+ str(shelf))
#	if shelf_placed_items[shelf] != "":
#		GlobalSignals.emit_signal("speak", "There is something on the shelf already.")
#		return
#	if "glass of water" in sentence:
#		var obj = set_glass.instance()
#		add_child(obj)
#		game_objects["glass"] = obj
##		do that for all
#		obj.rect_position = shelves[shelf].set_position.global_position
#		obj.is_on_shelf = true
#		shelf_placed_items[shelf] = "the glass of water"
#		GlobalSignals.emit_signal("item_placed_on_shelf","the glass of water" )
#		add_to_game_objects("glass", obj)
#		_remove_from_inventory_list("the glass of water")
#		_check_shelves()
#	if "gold cup" in sentence:
#		var obj = set_cup.instance()
#		add_child(obj)
#		game_objects["cup"] = obj
#		obj.rect_position = Vector2(shelves[shelf].rect_position.x, shelves[shelf].rect_position.y-90)
#		obj.is_on_shelf = true
#		shelf_placed_items[shelf] = "the gold cup"
#		GlobalSignals.emit_signal("item_placed_on_shelf","the gold cup" )
#		add_to_game_objects("cup", obj)
#		_remove_from_inventory_list("the gold cup")
#		_check_shelves()
#	if "green crystal" in sentence:
#		var obj = green_crystal.instance()
#		add_child(obj)
#		game_objects["the green crystal"] = obj
#		obj.rect_position = Vector2(shelves[shelf].rect_position.x, shelves[shelf].rect_position.y-90)
#		obj.is_on_shelf = true
#		shelf_placed_items[shelf] = "the green crystal"
#		GlobalSignals.emit_signal("item_placed_on_shelf","the green crystal" )
#		add_to_game_objects("the green crystal", obj)
#		_remove_from_inventory_list("the green crystal")
#		_check_shelves()
#	if "pink crystal" in sentence:
#		var obj = pink_crystal.instance()
#		add_child(obj)
#		game_objects["pink_crystal"] = obj
#		obj.rect_position = Vector2(shelves[shelf].rect_position.x, shelves[shelf].rect_position.y-90)
#		obj.is_on_shelf = true
#		shelf_placed_items[shelf] = "the pink crystal"
#		GlobalSignals.emit_signal("item_placed_on_shelf","the pink crystal" )
#		add_to_game_objects("pink_crystal", obj)
#		_remove_from_inventory_list("the pink crystal")
#		_check_shelves()
#	if "blue crystal" in sentence:
#		var obj = blue_crystal.instance()
#		add_child(obj)
#		game_objects["blue_crystal"] = obj
#		obj.rect_position = Vector2(shelves[shelf].rect_position.x, shelves[shelf].rect_position.y-60)
#		obj.is_on_shelf = true
#		shelf_placed_items[shelf] = "the blue crystal"
#		print ("b4 place shelf")
#		GlobalSignals.emit_signal("item_placed_on_shelf","the blue crystal" )
#		add_to_game_objects("blue_crystal", obj)
#		_remove_from_inventory_list("the blue crystal")
#		_check_shelves()
