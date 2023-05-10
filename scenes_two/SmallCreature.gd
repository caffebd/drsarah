extends KinematicBody2D


var is_inventory_item:= false

export var object_text := "the creature"

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

var no_more_text := false

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = position
	turn_pos.y = start_pos.y
	turn_pos.x = start_pos.x + (distance * direction)
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
	GlobalSignals.connect("item_placed_on_shelf", self, "_placed_on_shelf")


func _physics_process(delta):
	if !moving:
		return
		
	var new_distance = abs(start_pos.x - position.x)
	
	if is_on_wall():
		direction = direction * -1
	
	if position.x > start_pos.x + distance/2:
		direction = -1
	if position.x < start_pos.x - distance/2:
		direction = 1
	
	velocity.x = speed * direction
	velocity.y = 4500
	
	velocity = move_and_slide(velocity, Vector2.UP, true, 50.0, 45.0, true)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_state(state):
	if state == "stop":
		$CollisionShape2D.disabled = true
		moving = false
	else:
		$CollisionShape2D.disabled = false
		moving = true
		

func _on_DetectArea_body_entered(body):
	if body.name == "PlayerGirl":
		GlobalSignals.emit_signal("save_sentence", "there was a strange creature in the way")		
		if state == "stop" and no_more_text == false:
			no_more_text = true
			GlobalSignals.emit_signal("speak", "It seems much friendlier now.")
		else:
			GlobalSignals.emit_signal("speak", "It's not going to let me pass.")


func _was_pressed():
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
	if not object_text in sentence or state == "off":
		return
	match sentence:
		get:
			GlobalSignals.emit_signal("speak", "I can't take this creature!")
		give:
			var dist_player = GlobalVars.the_drone.position.distance_to(GlobalVars.the_player.position)
			if dist_player > 200:
				_get_closer_to_player()
				return
			GlobalSignals.emit_signal("add_to_inventory_bar_from_drone", object_text)
			GlobalSignals.emit_signal("sentence_clear")
		use_on:
			return
		"give the apple to the creature":
			set_state("stop")
			GlobalSignals.emit_signal("speak", "It seems to like that.")			
		look:
			GlobalSignals.emit_signal("speak", "I have never seen an animal like this one before.")
		_:
			if not "shelf" in sentence:
				GlobalSignals.emit_signal("speak", "I can't do that with the "+object_text)


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
	update_state(state)
	

