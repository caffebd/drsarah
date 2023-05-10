extends TextureButton


var is_inventory_item:= false

var object_text := "the village elder"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "null"

export var speed := 100.0
export var distance := 100.0
export var direction :=1

var velocity: Vector2

var start_pos: Vector2
var turn_pos: Vector2

var moving := true

var convo_count := 0

var my_conversations = []

var conversation_zero = [
	{
	"speaker":"Woman",
	"text":	"Dr. Sarah, why did you come back? You should leave, it's not safe.",
	"voice":"",
	"spacebar": true
	},
	{
	"speaker":"Sarah",
	"text":	"What happened to you? Who put you in there?",
	"voice":"",
	"spacebar": true
	},
	{
	"speaker":"Woman",
	"text":	"A dangerous man named 'Rakush', Please leave before he comes back.",
	"voice":"",
	"spacebar": true
	},
	{
	"speaker":"Sarah",
	"text":	"I can't do that. I'm going to get you out. Do you know where the key is?",
	"voice":"",
	"spacebar": true
	},
	{
	"speaker":"Woman",
	"text":	"Rakosh has it. It's hopeless. If he catches you, he will lock you up too.",
	"voice":"",
	"spacebar": true
	},
	{
	"speaker":"Sarah",
	"text":	"I can't leave you and all these children locked up. I'll be back.",
	"voice":"",
	"spacebar": true
	},
	]


var conversation_one = [
	{
	"speaker":"Woman",
	"text":	"You did. I can't believe it. Thank you so much.",
	"voice":"",
	"spacebar": true
	},
	{
	"speaker":"Sarah",
	"text":	"Who is this Rakush? What does he want with you?",
	"voice":"",
	"spacebar": true
	},
	{
	"speaker":"Woman",
	"text":	"Our village holds many treasures and secrets. He came here to steal them.",
	"voice":"",
	"spacebar": true
	},
	{
	"speaker":"Woman",
	"text":	"We had to hide them in the caves beneath our village.",
	"voice":"",
	"spacebar": true
	},
	{
	"speaker":"Woman",
	"text":	"He locked us up because we wouldn't tell him where they were.",
	"voice":"",
	"spacebar": true
	},
	{
	"speaker":"Sarah",
	"text":	"I think I may have seen some of those treasures.",
	"voice":"",
	"spacebar": true
	},
	{
	"speaker":"Woman",
	"text":	"If you find any, please bring them back to us. We need to collect them and leave before he comes back.",
	"voice":"",
	"spacebar": true
	},
	{
	"speaker":"Sarah",
	"text":	"I will. Are all the children feeling better now?",
	"voice":"",
	"spacebar": true
	},
	{
	"speaker":"Woman",
	"text":	"Yes, thanks to you. I'm sure this illness was caused by Rakush to punish us.",
	"voice":"",
	"spacebar": true
	},
	{
	"speaker":"Sarah",
	"text":	"Well at least he's gone now.",
	"voice":"",
	"spacebar": true
	},
	{
	"speaker":"Woman",
	"text":	"I fear he will be back soon. We need to leave but not without our treasures.",
	"voice":"",
	"spacebar": true
	},
	{
	"speaker":"Sarah",
	"text":	"Ok, I'm going to help you find them.",
	"voice":"",
	"spacebar": true
	},
	{
	"speaker":"Woman",
	"text":	"Thank you Dr. Sarah.",
	"voice":"",
	"spacebar": true
	},
	]

var conversation_two = [
	{
	"speaker":"Sarah",
	"text":	"What happened to you? Who put you in there?",
	"voice": "res://assets/audio/village_intro/sarah1.mp3",
	"spacebar": true
	},
	{
	"speaker":"Woman",
	"text":	"Thank you. We are desperate, nothing we have tried has helped.",
	"voice":"res://assets/audio/village_intro/woman1.mp3",
	"spacebar": true
	},	
	{
	"speaker":"Sarah",
	"text":	"Are they your children?",
	"voice": "res://assets/audio/village_intro/sarah2.mp3",
	"spacebar": true
	},
	{
	"speaker":"Woman",
	"text":	"Yes, my son and daughter. They have been sick for more than a week now.",
	"voice": "res://assets/audio/village_intro/woman2.mp3",
	"spacebar": true
	},	
	{
	"speaker":"Sarah",
	"text":	"I have some medicine that should help if you allow me to give it to them?",
	"voice": "res://assets/audio/village_intro/sarah3.mp3",
	"spacebar": true
	},	
	{
	"speaker":"Woman",
	"text":	"Yes, of course. I will pray that it works.",
	"voice":"res://assets/audio/village_intro/woman3.mp3",
	"spacebar": true
	},		
]

var conversation_treasure = [
	{
	"speaker":"Woman",
	"text":	"Thank you so much, but I think there are still more to find.",
	"voice": "",
	"spacebar": true
	},
	{
	"speaker":"Sarah",
	"text":	"No problem, I will keep looking.",
	"voice": "",
	"spacebar": true
	},
	
]



var conversation_running := false

var first_conversation := false

var current_convo: Array

var medicine_count := 0

var converation_can_continue := true

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
	GlobalSignals.connect("item_placed_on_shelf", self, "_placed_on_shelf")
	GlobalSignals.connect("medicine_given", self, "_medicine_given")
	GlobalSignals.connect("elder_conversation_advance", self, "_conversation_advance")
	GlobalSignals.connect("treasure_received", self, "_treasure_received")
	my_conversations.append(conversation_zero)
	my_conversations.append(conversation_one)
	my_conversations.append(conversation_treasure)


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func update_state(state):
#	if state == "stop":
#		$CollisionShape2D.disabled = true
#		moving = false
#	else:
#		$CollisionShape2D.disabled = false
#		moving = true

func callback_from_converastion_end():
	print ("YEP CALLBACK HAPPENED")

func _treasure_received():
	GlobalSignals.emit_signal("conversation_time", my_conversations[2], self, "woman")

func _conversation_advance():
	converation_can_continue = true
	convo_count += 1
	GlobalSignals.emit_signal("conversation_time", my_conversations[convo_count], self, "woman")
	converation_can_continue = false

		


func _on_TalkArea_body_entered(body):
	if body.name == "PlayerGirl":
		if convo_count > my_conversations.size() or !converation_can_continue:
			return
		else:
			converation_can_continue = false
			GlobalSignals.emit_signal("conversation_time", my_conversations[convo_count], self, "woman")

func _on_pressed():
	print ("top pressed")
	if GlobalVars.last_clicked == object_text and object_text in GlobalVars.current_sentence:
		GlobalSignals.emit_signal("object_button_pressed")
	else:
		GlobalVars.last_clicked = object_text
		if !GlobalVars.text_typing:
			if object_text in GlobalVars.current_sentence:
				return
		print (GlobalVars.current_sentence)
		if is_inventory_item and "Use" in GlobalVars.current_sentence:
			GlobalSignals.emit_signal("update_on_hover", object_text, " on")
#			GlobalSignals.emit_signal("add_with_preposition","on")
			GlobalVars.using_preposition = true
		elif is_inventory_item and "Give" in GlobalVars.current_sentence:
			GlobalSignals.emit_signal("update_on_hover", object_text, " to")
			
		else:
			GlobalSignals.emit_signal("update_on_hover", object_text)		


func _sentence_check(sentence):
	sentence = sentence.to_lower().strip_edges(true, true)
	var get := "get "+object_text
	var look := "look at "+object_text
	var use_on := "use "+object_text+" on"
	var give := "give "+object_text +" to"	
	var on_shelf_1 := "use "+object_text+" on the first shelf"
	var on_shelf_2 := "use "+object_text+" on the second shelf"
	var on_shelf_3 := "use "+object_text+" on the third shelf"
	var give_woman := "give "+object_text+" to the worried mother"
	if not object_text in sentence or state == "off":
		return
	if "give" in sentence:
		return
	match sentence:
		get:
			GlobalSignals.emit_signal("speak", "I can't take the woman.")
		give:
			var dist_player = GlobalVars.the_drone.position.distance_to(GlobalVars.the_player.position)
			if dist_player > 200:
				_get_closer_to_player()
				return
			GlobalSignals.emit_signal("add_to_inventory_bar_from_drone", object_text)
			GlobalSignals.emit_signal("sentence_clear")
		use_on:
			return
		give_woman:
			return
#			GlobalSignals.emit_signal("speak", "I should give the medicine to the children.")			
		look:
			GlobalSignals.emit_signal("speak", "She looks really worried about her children.")
		
		_:
			if not "shelf" in sentence:
				GlobalSignals.emit_signal("speak", "I can't do that with her.")


func _get_closer():
	print ("GET CLOSER")
	GlobalSignals.emit_signal("speak", "I need to get closer.")
	
func _get_closer_to_player():
	GlobalSignals.emit_signal("speak", "The drone needs to be closer to me.")


func _check_can_remove():
	if GlobalVars.object_used_up and is_inventory_item:
		GlobalVars.object_used_up = false
		GlobalSignals.emit_signal("sentence_clear")	
		queue_free()

func _placed_on_shelf(the_item):
	if the_item == object_text:
		if !is_on_shelf:
			GlobalSignals.emit_signal("remove_from_inventory_list", object_text)
			queue_free()
		
func set_state(new_state):
	state = new_state
#	update_state(state)
	


func _fade_in_sarah():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property($"%PressSarah", "modulate",  Color(1, 1, 1, 0), 1.0)
	yield(get_tree().create_timer(1.0), "timeout")
	_fade_out_sarah()
	
func _fade_out_sarah():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property($"%PressSarah", "modulate",  Color(1, 1, 1, 1), 2.0)
	yield(get_tree().create_timer(2.0), "timeout")
	_fade_in_sarah()
	
func _fade_in_woman():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property($"%PressWoman", "modulate",  Color(1, 1, 1, 0), 1.0)
	yield(get_tree().create_timer(1.0), "timeout")
	_fade_out_woman()
	
func _fade_out_woman():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property($"%PressWoman", "modulate",  Color(1, 1, 1, 1), 2.0)
	yield(get_tree().create_timer(2.0), "timeout")
	_fade_in_woman()

func show_hide_woman_push(state):
	$"%PressWoman".visible=state
	




