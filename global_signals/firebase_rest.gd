extends Node

#CAFFE Firestore
const API_KEY := "AIzaSyD3b20kkQc4Y4xF_og0i1cfZbw--Ae6l3k"
const PROJECT_ID := "englishquest-7aec6"

#DrSarahFirestore
#const API_KEY := "AIzaSyC3wut7sb8Qy8a_3pX5ctdsG9XsACYVogo"
#const PROJECT_ID := "village-of-mystery"

const REGISTER_URL := "https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=%s" % API_KEY
const LOGIN_URL := "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=%s" % API_KEY
const FIRESTORE_URL := "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/" % PROJECT_ID
#const FIRESTORE_URL = "https://firestore.googleapis.com/v1/projects/englishquest-7aec6/databases/(default)/documents/TheOffice/"


var current_token := ""

var main_email = "englishquest@caffebd.org"
var main_password = "znNW@x528xrxEb9zUjFwvS^Mj"

var my_inventory: Array = []

var user_info := {}

#var http: HTTPRequest

var getting_fields = false

#var room_items_game: Dictionary

var room_items = {
	"room_items":{
	"mapValue":{"fields":{}}}}

#var room_items = {
#	"room_items":{
#	"mapValue":{"fields":{
#	"ladder": {"mapValue": {"fields":{
#	"scene":{"stringValue":"res://scenes_two/Ladder.tscn"},
#				"inventory":{"booleanValue":false},
#				"active":{"booleanValue":true},
#				"on_shelf":{"booleanValue":false},
#				"position_x":{"doubleValue":840},
#				"position_y":{"doubleValue":2200}
#			}
#		}
#	},
#	"box": {"mapValue": {"fields":{
#	"scene":{"stringValue":"res://scenes_two/Ladder.tscn"},
#				"inventory":{"booleanValue":false},
#				"active":{"booleanValue":true},
#				"on_shelf":{"booleanValue":false},
#				"position_x":{"doubleValue":840},
#				"position_y":{"doubleValue":2200}
#			}
#		}
#	}
#		}
#	}
#	}
#	}



func _ready():
	pass
#	http = HTTPRequest.new()
#	http.connect("request_completed", self, "_on_request_completed")
#	add_child(http)
#	http.set_timeout(30.0)


func _on_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	print ("resp code" + str(response_code))
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
#	print (result_body)
	if response_code == 200:
		print_debug("firebase success")


func _get_user_info(result: Array) -> Dictionary:
	var result_body := JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
	return {
		"token": result_body.idToken,
		"id": result_body.localId
	}


func _get_request_headers() -> PoolStringArray:
	return PoolStringArray([
		"Content-Type: application/json",
		"Authorization: Bearer %s" % user_info.token
	])


func _get_token_id_from_result(result: Array) -> String:
	var result_body := JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
	return result_body.idToken
	


func register(email: String, password: String) -> bool:
	var body := {
		"email": email,
		"password": password,
#		"returnSecureToken": true
	}
	var	http_register = HTTPRequest.new()
	add_child(http_register)
	http_register.set_timeout(30.0)
	http_register.request(REGISTER_URL, [], false, HTTPClient.METHOD_POST, to_json(body))
	var result := yield(http_register, "request_completed") as Array
	if result[1] == 200:
		user_info = _get_user_info(result)
		current_token = _get_token_id_from_result(result)
		http_register.queue_free()
		return true		
	else:
		http_register.queue_free()
		return false


func login(email: String, password: String)->bool:
	var body := {
		"email": email,
		"password": password,
		"returnSecureToken": true
	}
	var	http_login = HTTPRequest.new()
	add_child(http_login)
	http_login.set_timeout(30.0)
	http_login.request(LOGIN_URL, [], false, HTTPClient.METHOD_POST, to_json(body))
	var result := yield(http_login, "request_completed") as Array
	if result[1] == 200:
		user_info = _get_user_info(result)
		print (user_info)
		http_login.queue_free()
		return true
	else:
		http_login.queue_free()
		return false

func save_document_level(path: String, fields) -> void:
	var document :=  {"fields": fields }
	var body := to_json(document)
	var url := FIRESTORE_URL + path
	var	http_level = HTTPRequest.new()
	add_child(http_level)
	http_level.set_timeout(30.0)
	http_level.request(url, _get_request_headers(), false, HTTPClient.METHOD_POST, body)
	var result := yield(http_level, "request_completed") as Array
	print (result[1])
	http_level.queue_free()

func save_document_player(path: String, fields) -> void:
	var document :=  {"fields": fields }
	var body := to_json(document)
	var url := FIRESTORE_URL + path
	var	http_player = HTTPRequest.new()
	add_child(http_player)
	http_player.set_timeout(30.0)
	http_player.request(url, _get_request_headers(), false, HTTPClient.METHOD_POST, body)
	var result := yield(http_player, "request_completed") as Array
	print (result[1])
	http_player.queue_free()

func save_document_drone(path: String, fields) -> void:
	var document :=  {"fields": fields }
	var body := to_json(document)
	var url := FIRESTORE_URL + path
	var	http_drone = HTTPRequest.new()
	add_child(http_drone)
	http_drone.set_timeout(30.0)
	http_drone.request(url, _get_request_headers(), false, HTTPClient.METHOD_POST, body)
	var result := yield(http_drone, "request_completed") as Array
	print (result[1])
	http_drone.queue_free()

func save_document_active(path: String, fields) -> void:
	var document :=  {"fields": fields }
	var body := to_json(document)
	var url := FIRESTORE_URL + path
	var	http_active = HTTPRequest.new()
	add_child(http_active)
	http_active.set_timeout(30.0)
	http_active.request(url, _get_request_headers(), false, HTTPClient.METHOD_POST, body)
	var result := yield(http_active, "request_completed") as Array
	print (result[1])
	http_active.queue_free()

func save_document_new_panels(path: String, fields) -> void:
	var document :=  {"fields": fields }
	var body := to_json(document)
	var url := FIRESTORE_URL + path
	var	http_new_panels = HTTPRequest.new()
	add_child(http_new_panels)
	http_new_panels.set_timeout(30.0)
	http_new_panels.request(url, _get_request_headers(), false, HTTPClient.METHOD_POST, body)
	var result := yield(http_new_panels, "request_completed") as Array
	print (result[1])
	http_new_panels.queue_free()

#func save_document_level(path: String, fields) -> void:
#	var document :=  {"fields": fields }
#	var body := to_json(document)
#	var url := FIRESTORE_URL + path
#	print (url)
#	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_POST, body)
#	var result := yield(http, "request_completed") as Array
#	print (result[1])


func fetch_comic_panels(data)->Array:
	var temp_sentences = []
	if data["saved_sentences"]["arrayValue"].size() > 0:		
		for item in data["saved_sentences"]["arrayValue"]["values"]:
#			print ("download saved sentence item "+item["stringValue"])
			temp_sentences.append(item["stringValue"])
	print ("fetched "+str(temp_sentences))
	return temp_sentences
	

func get_comic_panels(path: String) -> Array:
	var return_sentences = []
	var url := FIRESTORE_URL + path
	var	http_comic = HTTPRequest.new()
	add_child(http_comic)
	http_comic.set_timeout(30.0)
	http_comic.request(url, _get_request_headers(), false, HTTPClient.METHOD_GET)
	var result := yield(http_comic, "request_completed") as Array
	print ("Get result is "+str(result[1]))
	if result[1] == 404:
		http_comic.queue_free()
		return ["empty"]
	if result[1] == 200:
		var result_body := JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
		http_comic.queue_free()
		return (fetch_comic_panels(result_body.fields))
	else:
		http_comic.queue_free()
		return ["empty"]
	

func get_document_level(path: String) -> Dictionary:
	var empty = {}
	var	http_level = HTTPRequest.new()
	add_child(http_level)
	http_level.set_timeout(30.0)
	var url := FIRESTORE_URL + path
	print ("level "+url)
	http_level.request(url, _get_request_headers(), false, HTTPClient.METHOD_GET)
	var result := yield(http_level, "request_completed") as Array
	print ("Get result is "+str(result[1]))
	if result[1] == 404:
		http_level.queue_free()
		return 
	if result[1] == 200:
		var result_body := JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
		var db_path = result_body.name
		print ("db path is "+db_path)
		if "Level" in db_path or "Demo" in db_path or "Village" in db_path or "Rock" in db_path or "Lava" in db_path or "Water" in db_path:
			print ("loading for update room items")
			http_level.queue_free()
			return (update_my_room_items(result_body.fields))
		else:
			http_level.queue_free()
			return
	else:
		http_level.queue_free()
		return
		
func get_document_player(path: String) -> Dictionary:
	var empty = {}
	var	http_player = HTTPRequest.new()
	add_child(http_player)
	http_player.set_timeout(30.0)
	var url := FIRESTORE_URL + path
	print ("player "+url)
	http_player.request(url, _get_request_headers(), false, HTTPClient.METHOD_GET)
	var result := yield(http_player, "request_completed") as Array
	print ("Get result is "+str(result[1]))
	if result[1] == 404:
		http_player.queue_free()
		return 
	if result[1] == 200:
		var result_body := JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
		var db_path = result_body.name
		print ("db path is "+db_path)
		if "Player" in db_path:
			http_player.queue_free()
			return (update_player_items(result_body.fields))
		else:
			http_player.queue_free()
			return
	else:
		http_player.queue_free()
		return

func get_document_drone(path: String) -> Dictionary:
	var empty = {}
	var	http_drone = HTTPRequest.new()
	add_child(http_drone)
	http_drone.set_timeout(30.0)
	var url := FIRESTORE_URL + path
	print ("drone "+url)
	http_drone.request(url, _get_request_headers(), false, HTTPClient.METHOD_GET)
	var result := yield(http_drone, "request_completed") as Array
	print ("Get result is "+str(result[1]))
	if result[1] == 404:
		http_drone.queue_free()
		return 
	if result[1] == 200:
		var result_body := JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
		var db_path = result_body.name
		print ("db path is "+db_path)
		if "Drone" in db_path:
			http_drone.queue_free()
			return (update_drone_items(result_body.fields))
		else:
			http_drone.queue_free()
			return
	else:
		http_drone.queue_free()
		return

func get_document_active(path: String) -> Dictionary:
	var empty = {}
	var	http_active = HTTPRequest.new()
	add_child(http_active)
	http_active.set_timeout(30.0)
	var url := FIRESTORE_URL + path
	print ("active "+url)
	http_active.request(url, _get_request_headers(), false, HTTPClient.METHOD_GET)
	var result := yield(http_active, "request_completed") as Array
	print ("Get result is "+str(result[1]))
	if result[1] == 404:
		http_active.queue_free()
		return 
	if result[1] == 200:
		var result_body := JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
		var db_path = result_body.name
		print ("db path is "+db_path)
		if "Active" in db_path:
			http_active.queue_free()
			return (active_levels(result_body.fields))
		else:
			http_active.queue_free()
			return
	else:
		http_active.queue_free()
		return

func get_document_new_panels(path: String) -> Dictionary:
	var empty = {}
	var	http_panels = HTTPRequest.new()
	add_child(http_panels)
	http_panels.set_timeout(30.0)
	var url := FIRESTORE_URL + path
	print ("new_panels "+url)
	http_panels.request(url, _get_request_headers(), false, HTTPClient.METHOD_GET)
	var result := yield(http_panels, "request_completed") as Array
	print ("Get result is "+str(result[1]))
	if result[1] == 404:		
		http_panels.queue_free()
		return []
	if result[1] == 200:
		var result_body := JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
		var db_path = result_body.name
		print ("db path is "+db_path)
		if "NewPanels" in db_path:
			http_panels.queue_free()
			return (new_panels_update(result_body.fields))
		else:
			http_panels.queue_free()
			return []
	else:
		http_panels.queue_free()
		return []
	

#func get_document(path: String) -> Dictionary:
#
#	var empty = {}
#	var url := FIRESTORE_URL + path
#	print (url)
#	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_GET)
#	var result := yield(http, "request_completed") as Array
#	print ("Get result is "+str(result[1]))
#	if result[1] == 404:
#		return 
#	if result[1] == 200:
#		var result_body := JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
#		var db_path = result_body.name
#		print ("db path is "+db_path)
#		if "Level" in db_path or "Demo" in db_path or "Village" in db_path or "Lower" in db_path:
#			print ("loading for update room items")
#			return (update_my_room_items(result_body.fields))
#		elif "Player" in db_path:
#			return (update_player_items(result_body.fields))
#		elif "Drone" in db_path:
#			return (update_drone_items(result_body.fields))
#		elif "Active" in db_path:
#			return (active_levels(result_body.fields))
#		elif "NewPanels" in db_path:
#			return (new_panels_update(result_body.fields))
#		else:
#			return empty
#	else:
#		return empty
	

func update_document_level(path: String, fields) -> void:
	var document := { "fields": fields }
	var body := to_json(document)
	var	http_level = HTTPRequest.new()
	add_child(http_level)
	http_level.set_timeout(30.0)
	var url := FIRESTORE_URL + path
	print (body)
	http_level.request(url, _get_request_headers(), false, HTTPClient.METHOD_PATCH, body)
	var result := yield(http_level, "request_completed") as Array
	print (result[1])
	if result[1] == 400:
		save_document_level(path, fields)
		print ("first time save level")
		http_level.queue_free()
	else:
		print ("update save level")
		http_level.queue_free()

func update_document_player(path: String, fields) -> void:
	var document := { "fields": fields }
	var body := to_json(document)
	var	http_player = HTTPRequest.new()
	add_child(http_player)
	http_player.set_timeout(30.0)
	var url := FIRESTORE_URL + path
	print (body)
	http_player.request(url, _get_request_headers(), false, HTTPClient.METHOD_PATCH, body)
	var result := yield(http_player, "request_completed") as Array
	print (result[1])
	if result[1] == 400:
		save_document_player(path, fields)
		print ("first time save player")
		http_player.queue_free()
	else:
		print ("update save player")
		http_player.queue_free()		

func update_document_drone(path: String, fields) -> void:
	var document := { "fields": fields }
	var body := to_json(document)
	var	http_drone = HTTPRequest.new()
	add_child(http_drone)
	http_drone.set_timeout(30.0)
	var url := FIRESTORE_URL + path
	print (body)
	http_drone.request(url, _get_request_headers(), false, HTTPClient.METHOD_PATCH, body)
	var result := yield(http_drone, "request_completed") as Array
	print (result[1])
	if result[1] == 400:
		save_document_drone(path, fields)
		print ("first time save drone")
		http_drone.queue_free()
	else:
		print ("update save drone")
		http_drone.queue_free()		
		

func update_document_active(path: String, fields) -> void:
	var document := { "fields": fields }
	var body := to_json(document)
	var	http_active = HTTPRequest.new()
	add_child(http_active)
	http_active.set_timeout(30.0)
	var url := FIRESTORE_URL + path
	print (body)
	http_active.request(url, _get_request_headers(), false, HTTPClient.METHOD_PATCH, body)
	var result := yield(http_active, "request_completed") as Array
	print (result[1])
	if result[1] == 400:
		save_document_active(path, fields)
		print ("first time save active")
		http_active.queue_free()
	else:
		print ("update save active")
		http_active.queue_free()

func update_document_new_panels(path: String, fields) -> void:
	var document := { "fields": fields }
	var body := to_json(document)
	var	http_new_panels = HTTPRequest.new()
	add_child(http_new_panels)
	http_new_panels.set_timeout(30.0)
	var url := FIRESTORE_URL + path
	print (body)
	http_new_panels.request(url, _get_request_headers(), false, HTTPClient.METHOD_PATCH, body)
	var result := yield(http_new_panels, "request_completed") as Array
	print (result[1])
	if result[1] == 400:
		save_document_new_panels(path, fields)
		print ("first time save active")
		http_new_panels.queue_free()
	else:
		print ("update save active")
		http_new_panels.queue_free()		

#func update_document(path: String, fields) -> void:
#	var document := { "fields": fields }
#	var body := to_json(document)
#	var url := FIRESTORE_URL + path
#	print (body)
#	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_PATCH, body)
#	var result := yield(http, "request_completed") as Array
#	print (result[1])
#	if result[1] == 400:
#		save_document(path, fields)
#		print ("first time save")
#	else:
#		print ("update save")

func delete_document(path: String, http: HTTPRequest) -> void:
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_DELETE)

#
#func update_inventory(new_item: String):
#	my_inventory.append(new_item)
#	var inventory := {
#	"objects":{"arrayValue":{"values":[]}}
#	}
#	for item in my_inventory:
#		print (item+" to add")
#		var push_item = {"stringValue":item}
#		inventory.objects["arrayValue"]["values"].append(push_item)
#	print (inventory)
#	update_document("TheOffice/inventory",  inventory)


func update_active():
	
	var new_active := {
	"arrayValue":{"values":[]}
	}
	var add_active = []
	for item in GlobalVars.unlocked_levels:
		var push_item = {"stringValue":item}
		if not new_active.has(push_item):
			new_active["arrayValue"]["values"].append(push_item)

	var active_data = {}
	

	
	
	active_data["active_levels"] = new_active
	
	
#	var level_data = {"stringValue":GlobalVars.save_level}
#	player_info["current_level"] = level_data
	
	yield(update_document_active("EnglishAdventure/"+user_info.id+"/Game/Active", active_data), "completed")

func update_new_panels():
	var panels_data = {}
	
	var new_panels := {
	"arrayValue":{"values":[]}
	}
	for item in GlobalVars.new_panels:
		var push_item = {"stringValue":item}
		if not new_panels.has(push_item):
			new_panels["arrayValue"]["values"].append(push_item)	
	
	panels_data["new_panels"] = new_panels
	
	print ("NEW PANEL DATA")
	print (panels_data)
	
	yield(update_document_new_panels("EnglishAdventure/"+user_info.id+"/Game/NewPanels", panels_data), "completed")
	

func update_level(room_items_game: Dictionary, player_pos: Vector2, drone_pos: Vector2, player_inventory, drone_inventory):
	room_items = {
	"room_items":{
	"mapValue":{"fields":{}}}}
	var dict_key_array = Array(room_items_game.keys())
	dict_key_array.erase("inventory_list")
	dict_key_array.erase("shelves")
	dict_key_array.erase("using_drone")
	dict_key_array.erase("saved_sentences")
	for key in dict_key_array:
		print (key)
		var active =  room_items_game[key]["active"]
		var scene = room_items_game[key]["scene"]
		var inventory = room_items_game[key]["inventory"]
		var on_shelf = room_items_game[key]["on_shelf"]
		var state = room_items_game[key]["state"]
		var position_x = room_items_game[key]["position_x"]
		var position_y = room_items_game[key]["position_y"]
		var map = room_items_game[key]["map"]
		var to_add = {"mapValue": {"fields":{
	"scene":{"stringValue":scene},
				"inventory":{"booleanValue":inventory},
				"active":{"booleanValue":active},
				"on_shelf":{"booleanValue":on_shelf},
				"state":{"stringValue":state},
				"position_x":{"doubleValue":position_x},
				"position_y":{"doubleValue":position_y},
				"map":{"stringValue": map}
	
			}
		}
		}
		room_items.room_items.mapValue.fields[key] = to_add

	var saved_sentences := {
	"arrayValue":{"values":[]}
	}
	for item in room_items_game["saved_sentences"]:
		var push_item_sent = {"stringValue":item}
		saved_sentences["arrayValue"]["values"].append(push_item_sent)
	room_items["saved_sentences"] = saved_sentences 

	var shelves := {
	"arrayValue":{"values":[]}
	}
	for item in room_items_game["shelves"]:
		print (item+" to add")
		var push_item = {"stringValue":item}
		shelves["arrayValue"]["values"].append(push_item)
	room_items["shelves"] = shelves
	
	var player_data = {"mapValue" :{"fields":{
		"player_x":{"doubleValue":player_pos.x},
		"player_y":{"doubleValue":player_pos.y}
	}}}
	
	room_items["player_data"] = player_data
	
	
	var d_inventory := {
	"arrayValue":{"values":[]}
	}
	for item in drone_inventory:
#		print (item+" to add")
		var push_item = {"stringValue":item}
		d_inventory["arrayValue"]["values"].append(push_item)

	var drone_data = {"mapValue" :{"fields":{
		"drone_x":{"doubleValue":drone_pos.x},
		"drone_y":{"doubleValue":drone_pos.y},
		"using_drone":{"booleanValue":GlobalVars.using_drone},
		}}}

	
	var drone_info = {}
	
	room_items["drone_inventory"] = d_inventory
	room_items["drone_data"] = drone_data
	

#	print (room_items.room_items.mapValue.fields)
	yield(update_document_level("EnglishAdventure/"+user_info.id+"/Game/"+GlobalVars.current_level,  room_items), "completed")

	var inventory := {
	"arrayValue":{"values":[]}
	}
	for item in player_inventory:
#		print (item+" to add")
		var push_item = {"stringValue":item}
		inventory["arrayValue"]["values"].append(push_item)

	
#	var worn_items = {"mapValue" :{"fields":{
#		"mask": {"stringValue":GlobalVars.wearing_mask},
#		"gloves": {"stringValue":GlobalVars.wearing_gloves},
#		"skates": {"stringValue":GlobalVars.wearing_skates},
#		"coat": {"stringValue":GlobalVars.wearing_skates}
#	}}}
	var player_items = {
		"mapValue":{"fields":{
		"mask": {"booleanValue":GlobalVars.wearing_mask},
		"gloves": {"booleanValue":GlobalVars.wearing_gloves},
		"skates": {"booleanValue":GlobalVars.wearing_skates},
		"coat": {"booleanValue":GlobalVars.wearing_coat}
	}}}
	

	
	

	
	var player_info = {}
	
#	player_info["player_data"] = player_data
	player_info["player_items"] = player_items
	player_info["player_inventory"] = inventory

	
#	var level_data = {"stringValue":GlobalVars.save_level}
#	player_info["current_level"] = level_data
	
	yield(update_document_player("EnglishAdventure/"+user_info.id+"/Game/Player", player_info), "completed")
	
	GlobalSignals.emit_signal("show_saving_status", false)
	
#	var d_inventory := {
#	"arrayValue":{"values":[]}
#	}
#	for item in drone_inventory:
##		print (item+" to add")
#		var push_item = {"stringValue":item}
#		d_inventory["arrayValue"]["values"].append(push_item)
#
#	var drone_data = {"mapValue" :{"fields":{
#		"drone_x":{"doubleValue":drone_pos.x},
#		"drone_y":{"doubleValue":drone_pos.y},
#		"using_drone":{"booleanValue":GlobalVars.using_drone},
#		}}}
#
#
#	var drone_info = {}
#
#	drone_info["drone_inventory"] = d_inventory
#	drone_info["drone_data"] = drone_data
	
#	update_document("EnglishAdventure/"+user_info.id+"/Levels/Drone", drone_info)

func update_my_inventory(data):
	var new_array = []
	var end_result = data["objects"]["arrayValue"]["values"]
	print (end_result)
	for item in data["objects"]["arrayValue"]["values"]:
		print (item)
		new_array.append(item.values()[0])
	my_inventory = new_array.duplicate()
	print ("updates inventory is "+str(my_inventory))						

func update_my_room_items(data)->Dictionary:
	print ("in update room items")

	GlobalVars.temp_shelves = []
	if data["shelves"]["arrayValue"].size() > 0:		
		for item in data["shelves"]["arrayValue"]["values"]:
			print ("download shelf item "+item["stringValue"])
			GlobalVars.temp_shelves.append(item["stringValue"])

	GlobalVars.temp_sentences = []
	if data["saved_sentences"]["arrayValue"].size() > 0:		
		for item in data["saved_sentences"]["arrayValue"]["values"]:
			print ("download saved sentence item "+item["stringValue"])
			GlobalVars.temp_sentences.append(item["stringValue"])
	

	var player_x = data["player_data"]["mapValue"]["fields"]["player_x"]["doubleValue"]
	var player_y = data["player_data"]["mapValue"]["fields"]["player_y"]["doubleValue"]
	var player_pos = Vector2(player_x, player_y)
	

	var drone_x = data["drone_data"]["mapValue"]["fields"]["drone_x"]["doubleValue"]
	var drone_y = data["drone_data"]["mapValue"]["fields"]["drone_y"]["doubleValue"]
	var drone_pos = Vector2(drone_x, drone_y)
	GlobalVars.using_drone = data["drone_data"]["mapValue"]["fields"]["using_drone"]["booleanValue"]
	

	
	GlobalVars.temp_drone_inventory = []
	if data["drone_inventory"]["arrayValue"].size() > 0:		
		for item in data["drone_inventory"]["arrayValue"]["values"]:
			GlobalVars.temp_drone_inventory.append(item["stringValue"])
	
	GlobalVars.temp_drone_pos = drone_pos
	GlobalVars.temp_player_pos = player_pos
	
	print ("rest api player pos "+str(GlobalVars.temp_player_pos))
		
	var new_room = {}
	if data["room_items"]["mapValue"].size() == 0:
		return new_room
	var end_result = data["room_items"]["mapValue"]["fields"]
#	print (end_result)
	for item in data["room_items"]["mapValue"]["fields"]:
#		print (item)
		var key = item
		var scene: String = data["room_items"]["mapValue"]["fields"][key]["mapValue"]["fields"]["scene"]["stringValue"]
		var active: bool = data["room_items"]["mapValue"]["fields"][key]["mapValue"]["fields"]["active"]["booleanValue"]
		var inventory: bool = data["room_items"]["mapValue"]["fields"][key]["mapValue"]["fields"]["inventory"]["booleanValue"]
		var on_shelf: bool = data["room_items"]["mapValue"]["fields"][key]["mapValue"]["fields"]["on_shelf"]["booleanValue"]
		var state: String = data["room_items"]["mapValue"]["fields"][key]["mapValue"]["fields"]["state"]["stringValue"]
		var position_x: float = data["room_items"]["mapValue"]["fields"][key]["mapValue"]["fields"]["position_x"]["doubleValue"]
		var position_y: float = data["room_items"]["mapValue"]["fields"][key]["mapValue"]["fields"]["position_y"]["doubleValue"]
		var map: String = data["room_items"]["mapValue"]["fields"][key]["mapValue"]["fields"]["map"]["stringValue"]
#		print (key+" scene is "+scene)
		new_room[key]={
			"scene":scene,
			"inventory": inventory,
			"active": active,
			"on_shelf":on_shelf,
			"state": state,
			"position_x": position_x, 
			"position_y": position_y,
			"map": map
		}



#		new_array.append(item.values()[0])
#	my_inventory = new_array.duplicate()
#	print ("updated room is "+str(new_room))	
	return new_room


func update_player_items(data):
	GlobalVars.wearing_coat = data["player_items"]["mapValue"]["fields"]["coat"]["booleanValue"]
	GlobalVars.wearing_mask = data["player_items"]["mapValue"]["fields"]["mask"]["booleanValue"]
	GlobalVars.wearing_skates = data["player_items"]["mapValue"]["fields"]["skates"]["booleanValue"]
	GlobalVars.wearing_gloves = data["player_items"]["mapValue"]["fields"]["gloves"]["booleanValue"]

		
	GlobalVars.worn_items_after_load()
	
	GlobalVars.temp_inventory = []
	if data["player_inventory"]["arrayValue"].size() > 0:		
		for item in data["player_inventory"]["arrayValue"]["values"]:
			GlobalVars.temp_inventory.append(item["stringValue"])
	print ("FIREBASE temp inv "+str(GlobalVars.temp_inventory))
#



func update_drone_items(data):
	var drone_x = data["drone_data"]["mapValue"]["fields"]["drone_x"]["doubleValue"]
	var drone_y = data["drone_data"]["mapValue"]["fields"]["drone_y"]["doubleValue"]
	var drone_pos = Vector2(drone_x, drone_y)
	GlobalVars.using_drone = data["drone_data"]["mapValue"]["fields"]["using_drone"]["booleanValue"]
	
	GlobalSignals.emit_signal("release_drone", GlobalVars.using_drone)
	GlobalSignals.emit_signal("update_drone_position", drone_pos)
	
	GlobalVars.temp_drone_inventory = []
	if data["drone_inventory"]["arrayValue"].size() > 0:		
		for item in data["drone_inventory"]["arrayValue"]["values"]:
			GlobalVars.temp_drone_inventory.append(item["stringValue"])
	

func active_levels(data)->Array:
	var temp_active = []
	if data["active_levels"]["arrayValue"].size() > 0:		
		for item in data["active_levels"]["arrayValue"]["values"]:
			temp_active.append(item["stringValue"])
	GlobalVars.unlocked_levels = temp_active.duplicate()
	GlobalVars.unlocked_levels = []
	for level in temp_active:
		if !GlobalVars.unlocked_levels.has(level):
			GlobalVars.unlocked_levels.append(level)
	if GlobalVars.unlocked_levels.size()== 0:
		print ("needed to apped unlocked levels")
		GlobalVars.unlocked_levels.append("TheJourney")

	
	return temp_active
	

func new_panels_update(data)->Array:
	
	var temp_panels = []
	
	if data["new_panels"]["arrayValue"].size() > 0:		
		for item in data["new_panels"]["arrayValue"]["values"]:
			temp_panels.append(item["stringValue"])
	
	print (temp_panels)
	
	return temp_panels
	

#	print ("am i wearing a coat "+str(GlobalVars.wearing_coat))
#	print ("am i wearing a mask "+str(GlobalVars.wearing_mask))
#	print ("am i wearing a skates "+str(GlobalVars.wearing_skates))
#	print ("am i wearing a gloves "+str(GlobalVars.wearing_gloves))
#
#inventory.items = {"arrayValue": {
#	"values": [
#	  {
#		"stringValue": "lunch"
#	  },
#	  {
#		"stringValue": "dinner"
#	  }
#	]
#  }}
