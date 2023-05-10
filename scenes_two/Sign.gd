extends TextureButton

export var sign_text :String

var is_inventory_item:= false

export var object_text := "the sign"

var the_player: KinematicBody2D

onready var large_sign := $"%LargeSign"

onready var large_sign_text := $"%SignText"

onready var read_sign := $"%ReadSign"


func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
	read_sign.stream = load(ScriptVoice.script_voice[sign_text])
	$"%ObjectInfo".setup_label(object_text)
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")


func _on_pressed():
#	if GlobalVars.last_clicked == object_text:		
#		GlobalSignals.emit_signal("object_button_pressed")
#		$"%ReminderClick".stop()
#	else:
	GlobalVars.last_clicked = object_text
	if object_text in GlobalVars.current_sentence:
		GlobalSignals.emit_signal("object_button_pressed")
		return
	GlobalSignals.emit_signal("update_on_hover", object_text)
	GlobalSignals.emit_signal("object_button_pressed")

#func _on_entered():
#	if GlobalVars.no_click:
#		return
#	if object_text in GlobalVars.current_sentence:
#		return
#	GlobalSignals.emit_signal("update_on_hover", object_text)
#
#func _on_exit():
#	if !is_inventory_item:
#		GlobalSignals.emit_signal("remove_object")	

func _sentence_check(sentence):
	sentence = sentence.to_lower().strip_edges(true, true)
	if not object_text in sentence:
		return
	var look := "look at "+object_text
	match sentence:
		look:
			print ("looked at sign")
			GlobalSignals.emit_signal("save_sentence", sentence)
			show_large_sign(true)
		_:
			GlobalSignals.emit_signal("speak", "I can't do that with the sign.")


func _get_closer():
	GlobalSignals.emit_signal("speak", "I need to get closer.")

func _check_can_remove():
	if GlobalVars.object_used_up and is_inventory_item:
		GlobalVars.object_used_up = false
		GlobalSignals.emit_signal("sentence_clear")	
		queue_free()
		

func show_large_sign(state):
	large_sign_text.text = sign_text
	large_sign.visible = state
	read_sign.play()
	GlobalSignals.emit_signal("remove_sign_reminder")
	yield(get_tree().create_timer(4), "timeout")
	large_sign.visible = false
	if GlobalVars.tutorial_active:
		GlobalSignals.emit_signal("button_pressed", "tut_sign")
	

#if !is_inventory_item:
#	if the_player == null:
#		the_player = get_parent().return_player()
#	var dist = rect_position.distance_to(the_player.position)
#	print (dist)
#	if dist > 200:
#		_get_closer()
#		return

