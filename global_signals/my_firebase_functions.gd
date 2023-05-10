extends Node

const uuid_util = preload("res://global_signals/uuid.gd")

var is_teacher: bool = true

var my_inventory: Array = []

var my_clues: Array = []

var my_stacked_actions = []

var my_old_stacked_actions = []

var vote_visible: bool = false

var last_received_sentence: String = "first"

var is_online: bool = false

var teacher_continue: bool = false

var delay = 0.5

var inventory_items = {
	"watch": {
		"image":"res://assets/New1920/Clock Zoomed.png",
		"text":"This is a silver watch. It looks very old."
	},
	"gold_plate": {
		"image":"res://assets/New1920/Gold Plate Zoomed.png",
		"text":"This is a golden plate. It looks expensive."
	},
	"silver_plate": {
		"image":"res://assets/New1920/Silver Plate Zoomed.png",
		"text":"A large, round plate made of silver."
	},
	"cup": {
		"image":"res://assets/New1920/Cup Zoomed.png",
		"text":"A golden cup. It looks old and expensive."
	},
	"coin": {
		"image":"res://assets/New1920/Coin Zoomed.png",
		"text":"It is a small, round, silver coin."
	},

}

var all_clues: Array = [
	"The treasure is not gold",
	"The treasure is round",
	"The treasure has numbers"
]

var all_votes = {
	"cup":0,
	"silver_plate":0,
	"gold_plate": 0,
	"watch":0,
	"coin":0
}

var clue_count: int = 0

var found_clues: Array = []

var user_id: String = ""

var my_uuid: String = ""

var short_id: String = ""

var my_vote: String = "null"

var http


func _init():
	print ("Gerating UUID")
	my_uuid = uuid_util.v4()
	short_id = "Q"+my_uuid.substr(0, 7)
	print ("short id is  "+short_id)


func _ready():
	http = HTTPRequest.new()
	http.connect("request_completed", self, "_on_request_completed")
	add_child(http)


func _on_request_completed(result, response_code, headers, body):
	print ("resp code" + str(response_code))
	if response_code == 200:
		is_online = true





func register_id(user_data):
	user_id = user_data.local_id



	

#	old online check
#	is_online = false
#	var try_count = 0
#	while !is_online:
#		yield(get_tree().create_timer(1), "timeout")
#		print ("connecting......")
#		try_count = try_count + 1
#		if try_count > 10:
#			GlobalSignals.emit_signal("online_status", false)
#		if http.get_http_client_status()  != 6:
#			http.request("https://firestore.googleapis.com/v1/")	
