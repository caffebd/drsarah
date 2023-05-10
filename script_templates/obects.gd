extends %BASE%

var is_inventory_item:= false

var object_text := ""

var the_player: KinematicBody2D

var is_on_shelf := false


func _ready():
%TS%connect("pressed", self, "_on_pressed")
%TS%GlobalSignals.connect("sentence_checker", self, "_sentence_check")
%TS%connect("mouse_entered", self, "_on_entered")
%TS%connect("mouse_exited", self, "_on_exit")
%TS%GlobalSignals.connect("item_placed_on_shelf", self, "_placed_on_shelf")


func _on_pressed():
%TS%GlobalSignals.emit_signal("object_button_pressed")

func _on_entered():
%TS%if object_text in GlobalVars.current_sentence:
%TS%%TS%return
%TS%if is_inventory_item and "Use" in GlobalVars.current_sentence and GlobalVars.current_sentence.length() < 5:
%TS%%TS%GlobalSignals.emit_signal("update_on_hover", object_text)
%TS%%TS%GlobalSignals.emit_signal("add_with_preposition","on")
%TS%%TS%GlobalVars.using_preposition = true
%TS%else:
%TS%%TS%GlobalSignals.emit_signal("update_on_hover", object_text)

func _on_exit():
%TS%if GlobalVars.last_added == " on":
%TS%%TS%return
%TS%GlobalSignals.emit_signal("remove_object")

func _sentence_check(sentence):
%TS%var get := "Get "+object_text
%TS%var look := "Look at "+object_text
%TS%var use := "Use "+object_text
%TS%var use_on := "Use "+object_text+" on"	
%TS%var on_shelf := "Use "+object_text+" on the shelf"
%TS%if not object_text in sentence:
%TS%%TS%return
%TS%match sentence:
%TS%%TS%get:
%TS%%TS%%TS%if !is_inventory_item:
%TS%%TS%%TS%%TS%if the_player == null:
%TS%%TS%%TS%%TS%%TS%the_player = get_parent().return_player()
%TS%%TS%%TS%%TS%var dist = rect_position.distance_to(the_player.position)
%TS%%TS%%TS%%TS%if dist > 200:
%TS%%TS%%TS%%TS%%TS%_get_closer()
%TS%%TS%%TS%%TS%%TS%return
%TS%%TS%%TS%%TS%GlobalSignals.emit_signal("add_to_inventory_bar", object_text)
%TS%%TS%%TS%%TS%GlobalSignals.emit_signal("sentence_clear")
%TS%%TS%%TS%%TS%if is_on_shelf:
%TS%%TS%%TS%%TS%%TS%GlobalSignals.emit_signal("remove_from_shelf", object_text)
%TS%%TS%%TS%%TS%queue_free()
%TS%%TS%%TS%else:
%TS%%TS%%TS%%TS%GlobalSignals.emit_signal("speak", "You already have it.")
%TS%%TS%use:
%TS%%TS%%TS%GlobalSignals.emit_signal("speak", "You need to get it first.")
%TS%%TS%use_on:
%TS%%TS%%TS%return
%TS%%TS%look:
%TS%%TS%%TS%GlobalSignals.emit_signal("speak", "")
%TS%%TS%_:
%TS%%TS%%TS%GlobalSignals.emit_signal("speak", "I can't do that with the "+object_text)


func _get_closer():
%TS%GlobalSignals.emit_signal("speak", "I need to get closer.")

func _check_can_remove():
%TS%if GlobalVars.object_used_up and is_inventory_item:
%TS%%TS%GlobalVars.object_used_up = false
%TS%%TS%GlobalSignals.emit_signal("sentence_clear")	
%TS%%TS%queue_free()

func _placed_on_shelf(the_item):
%TS%if the_item == object_text:
%TS%%TS%if !is_on_shelf:
%TS%%TS%%TS%queue_free()
