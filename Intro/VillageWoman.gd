extends TextureButton


var is_inventory_item:= false

var object_text := "the worried mother"

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

var conversation_one = [
	{
	"speaker":"Sarah",
	"text":	"Hello, my name is Dr Sarah Bari. I am here to help your children.",
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

var conversation_two = [

	{
	"speaker":"Woman",
	"text":	"You should leave, it's not safe for you here.",
	"voice": "res://assets/audio/village_intro/woman4.mp3",
	"spacebar": true
	},	
	{
	"speaker":"Sarah",
	"text":	"But I need to give this medicine to all the children first.",
	"voice": "res://assets/audio/village_intro/sarah4.mp3",
	"spacebar": true
	},
	{
	"speaker":"Woman",
	"text":	"Give it to me, I will do it. If he finds you, he will punish us all.",
	"voice": "res://assets/audio/village_intro/woman5.mp3",
	"spacebar": true
	},	
	{
	"speaker":"Sarah",
	"text":	"Who are you talking about? What's going on?",
	"voice":"res://assets/audio/village_intro/sarah5.mp3",
	"spacebar": true
	},	
	{
	"speaker":"Woman",
	"text":	"There’s no time to explain. Hide in that cave. Just push the lever to open the door.",
	"voice": "res://assets/audio/village_intro/woman6.mp3",
	"spacebar": true
	},		
]

onready var player_talk := $PlayerTalk
onready var player_label := $PlayerTalk/PlayerLabel

onready var woman_talk := $WomanTalk
onready var woman_label := $WomanTalk/WomanLabel

var conversation_running := false

var first_conversation := false

var current_convo: Array

var medicine_count := 0

var converation_can_continue := true

var my_conversations = []

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
	GlobalSignals.connect("item_placed_on_shelf", self, "_placed_on_shelf")
	GlobalSignals.connect("medicine_given", self, "_medicine_given")
	my_conversations.append(conversation_one)
	my_conversations.append(conversation_two)


	
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

#func _input(event):
#	if !conversation_running:
#		return
#	if event is InputEventKey and event.is_action_pressed("ui_select") and event.echo == false:
#		convo_count += 1
#		conversation()
		
func _conversation_advance():
	converation_can_continue = true
	convo_count += 1
	GlobalSignals.emit_signal("conversation_time", my_conversations[convo_count], self, "Sarah")
	converation_can_continue = false

		


func _on_DetectArea_body_entered(body):
	if body.name == "PlayerGirl":
		if convo_count > my_conversations.size() or !converation_can_continue:
			return
		else:			
			converation_can_continue = false
			GlobalSignals.emit_signal("conversation_time", my_conversations[convo_count], self, "Sarah")

func callback_from_converastion_end():
	if medicine_count !=2:
		GlobalSignals.emit_signal("tut_to_give")
		GlobalVars.girl_waiting = false
		GlobalVars.boy_waiting = true
		print("before speak "+str(GlobalVars.boy_waiting ))
		GlobalSignals.emit_signal("speak", "Give the medicine to the boy. Follow the arrow.")
		GlobalVars.tutorial_active = true
	else:
#			end first tutorial here
		GlobalSignals.emit_signal("tut_done")
		GlobalSignals.emit_signal("convo_barriers", true)
		GlobalSignals.emit_signal("hand_over_box")
		GlobalVars.tut_count = 1

func conversation():
	show_hide_woman_push(true)
	conversation_running = true
	GlobalSignals.emit_signal("convo_barriers", false)
	var speaker = 	current_convo[convo_count]["speaker"]
	var sentence = 	current_convo[convo_count]["text"]
	$Voices.stream = load(current_convo[convo_count]["voice"])
	match speaker:
		"Sarah":
			woman_talk.visible = false
			player_label.text = sentence
			player_talk.visible = true
			
		"Woman":
			player_talk.visible = false
			woman_label.text= sentence
			woman_talk.visible = true
	$Voices.play()
	if convo_count == current_convo.size()-1:
		current_convo = conversation_two
		convo_count = 0
		conversation_running = false
		show_hide_woman_push(false)
		if medicine_count !=2:
			GlobalSignals.emit_signal("tut_to_give")
			GlobalSignals.emit_signal("speak", "Give the medicine to the boy. Follow the arrow.")
			GlobalVars.tutorial_active = true
		else:
#			end first tutorial here
			GlobalSignals.emit_signal("tut_done")
			GlobalSignals.emit_signal("convo_barriers", true)
			GlobalSignals.emit_signal("hand_over_box")
			GlobalVars.tut_count = 1
		
func _medicine_given():
	medicine_count += 1
	if medicine_count == 2:
		loud_noise()
		GlobalSignals.emit_signal("can_give_box")
		
func loud_noise():
	GlobalSignals.emit_signal("hide_pointer")
	yield(get_tree().create_timer(1), "timeout")
	GlobalSignals.emit_signal("speak","AHHHH.... ROARRRR!!!!!!")
	$Loud.play()

#func _on_DetectArea_body_entered(body):
#	if body.name == "PlayerGirl":
#		if !first_conversation:
#			first_conversation = true
#			conversation()
#			_fade_in_sarah()
#			_fade_in_woman()
			
func _on_pressed():
	print ("top pressed")
#	if GlobalVars.last_clicked == object_text and object_text in GlobalVars.current_sentence:
#		GlobalSignals.emit_signal("object_button_pressed")
#	else:
	GlobalVars.last_clicked = object_text
	if !GlobalVars.text_typing:
		if object_text in GlobalVars.current_sentence:
			GlobalSignals.emit_signal("object_button_pressed")
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
		GlobalSignals.emit_signal("object_button_pressed")		


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
	
func _on_Loud_finished():
	_conversation_advance()
	GlobalSignals.emit_signal("sentence_clear")
	get_parent().get_parent().running()

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
	
