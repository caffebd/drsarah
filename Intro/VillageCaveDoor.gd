extends TextureButton

var is_inventory_item:= false

var object_text := "the cave door"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "off"

export var y_pos_change :float
export var x_pos_change :float

onready var up_arrow = $UpArrow

var tween: SceneTreeTween

var move_to_x := 0.0
var move_to_y := 0.0

var start_x := 0.0
var start_y := 0.0

var close_state := "res://assets/platformer/village_cave_closed.png"
var open_state := "res://assets/platformer/village_cave_open.png"

func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
#	connect("mouse_entered", self, "_on_entered")
#	connect("mouse_exited", self, "_on_exit")
#	GlobalSignals.connect("move_log", self, "_move_log")
	move_to_x = rect_position.x + x_pos_change
	move_to_y = rect_position.y + y_pos_change
	start_x = rect_position.x
	start_y = rect_position.y
	
	

func _on_pressed():
#	if GlobalVars.last_clicked == object_text:
#		GlobalSignals.emit_signal("object_button_pressed")
#	else:
	GlobalVars.last_clicked = object_text
	if object_text in GlobalVars.current_sentence:
		GlobalSignals.emit_signal("object_button_pressed")
		return
	if is_inventory_item and "Use" in GlobalVars.current_sentence and GlobalVars.current_sentence.length():
		GlobalSignals.emit_signal("update_on_hover", object_text, " on")
#			GlobalSignals.emit_signal("add_with_preposition","on")
		GlobalVars.using_preposition = true
	else:
		GlobalSignals.emit_signal("update_on_hover", object_text)
		GlobalSignals.emit_signal("object_button_pressed")		


#func _on_entered():
#	if object_text in GlobalVars.current_sentence:
#		return
#	if is_inventory_item and "Use" in GlobalVars.current_sentence and GlobalVars.current_sentence.length() < 5:
#		GlobalSignals.emit_signal("update_on_hover", object_text)
#		GlobalSignals.emit_signal("add_with_preposition","on")
#		GlobalVars.using_preposition = true
#	else:
#		GlobalSignals.emit_signal("update_on_hover", object_text)
#
#func _on_exit():
#	if GlobalVars.last_added == " on":
#		return
#	GlobalSignals.emit_signal("remove_object")

func _sentence_check(sentence):
	sentence = sentence.to_lower().strip_edges(true, true)
	var get := "get "+object_text
	var look := "look at "+object_text
	var use := "use "+object_text
	var use_on := "use "+object_text+" on"	
	var on_shelf := "use "+object_text+" on the shelf"
	if not object_text in sentence:
		return
	match sentence:
		get:
			GlobalSignals.emit_signal("speak", "I cannot pick a door.")
		use:
			GlobalSignals.emit_signal("speak", "I think there is a lever to open the door.")
		use_on:
			return
		"pull the cave door":
			GlobalSignals.emit_signal("speak", "I think there is a lever to open the door.")
		"push the cave door":
			GlobalSignals.emit_signal("speak", "I think there is a lever to open the door.")
		look:
			GlobalSignals.emit_signal("speak", "I wonder what's inside?")
		_:
			GlobalSignals.emit_signal("speak", "I can't do that with the "+object_text)


func _get_closer():
	GlobalSignals.emit_signal("speak", "I need to get closer.")

func set_state(new_state):
	state = new_state
	if state == "on":
		$"%DoorAnim".play("open")
		$"%doorOpen".play()
	else:
		$"%DoorAnim".play("closed")

func _on_Area2D_body_entered(body):
	if body.name == "PlayerGirl":
		if state == "on":
			animate_arrow()
			var to_level = "res://cave_scenes/AnteCave.tscn"
			GlobalSignals.emit_signal("touching_door", true, to_level, false)
		else:
			GlobalSignals.emit_signal("speak", "The door is locked.")
	
func animate_arrow():	
		tween = create_tween()
		tween.tween_property($UpArrow, "scale", Vector2(0.4, 0.4), 0.8)
		tween.tween_property($UpArrow, "scale", Vector2(0.7, 0.7), 0.8)
		up_arrow.visible = true
#		$ArrowTimer.start()




func _on_Area2D_body_exited(body):
	if body.name == "PlayerGirl":
		var to_level = "res://DemoLevels/Demo1.tscn"
		GlobalSignals.emit_signal("touching_door", false, to_level, false)
		up_arrow.visible = false
		$ArrowTimer.stop()


func _on_ArrowTimer_timeout():
	animate_arrow()
