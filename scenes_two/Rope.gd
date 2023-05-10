extends TextureButton

onready var ray := $RayCast2D

onready var collision_shape := $Area2D/CollisionShape2D

var cast_length := -48.0

var distance := 0.0

var can_cast := true

var fake_rope := false

#var rope_piece = preload("res://scenes_two/RopePiece.tscn")

#var rope_piece = preload("res://scenes_two/Rope.tscn")

var extend := false

export var original_rope := false

var is_inventory_item:= false

var object_text := "the rope"

var the_player: KinematicBody2D

var is_on_shelf := false

var is_active = true

var state := "null"

var user_drop := false

var inventory_alt := "res://assets/inventory_images/inventory_rope.png"

func _process(delta):
#	print ("rope extend is"+str(extend))
	if !extend:
		return
	if ray.is_colliding() and can_cast:
		can_cast = false
		cast_length -=112
		print ("collided at "+str(cast_length))
		rect_min_size.y = abs(cast_length)
		$"%CollisionShape2D".position.y = cast_length
		$"%CollisionShape2D".shape.extents.y = abs(cast_length)/2
		$"%Area2D".position.y += abs(cast_length)*1.4
#		rect_size.y = cast_length
#		var pieces = ceil(cast_length/-96)
##		print ("pieces "+str(pieces))
#		_draw_rope(pieces)
		extend = false
	elif can_cast:
		cast_length -= 18
		ray.cast_to = Vector2(0, (cast_length))
		if cast_length < -2000:
			can_cast = false
			GlobalSignals.emit_signal("speak", "The rope is too short to reach the roof.")
			$DropFail.play()

#		print ("cast len "+str(cast_length))

func set_inventory_image():
	rect_size = Vector2(150,150)
	rect_min_size = Vector2(150,150)
	$"%Area2D".queue_free()
	texture_normal = load(inventory_alt)
	print ("ROPE ROPE "+str(rect_size))

#func _draw_rope(pieces: int):
#	if user_drop:
#		$DropSuccess.play()
#	var height = 0.0
#	var rope_piece = load("res://scenes_two/Rope.tscn")
#	for i in pieces:
#		var sprite = rope_piece.instance()
#		add_child(sprite)
#		sprite.fake_rope = true
#		sprite.collision_shape.disabled = true
#		sprite.rect_global_position.x = rect_global_position.x
#		var count = i+1
#		var gap = 96
#		if count == 1:
#			gap = 48
#			height += 0
#			sprite.rect_global_position.y = rect_global_position.y + (count * -gap)
#		else:
#			height += 48
#			sprite.rect_global_position.y = rect_global_position.y + (count * -gap+48)
#
##		print (str(sprite.position.y) + "   " +str(rect_position.y ))
#	collision_shape.shape.extents.y = (height)
#	collision_shape.position.y -= (pieces * 96)/2

#		print (position)
#		print (sprite.position)

func _ready():
	connect("pressed", self, "_on_pressed")
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
	GlobalSignals.connect("remove_game_object_rope", self, "_remove_me")
#	rect_size = Vector2(296.0, 33.0)
	collision_shape.shape.extents.y = 48
	collision_shape.position = Vector2(0,0)
	rect_min_size.y=175
	print ("MADE A ROPE")	
#	Only used for FIRST PLACEMENT OF ROPE IN SCENE TO ENSURE EXTENDS
	if rect_position.y > -2000:
		if !is_inventory_item:
			yield(get_tree().create_timer(0.5), "timeout")
			extend = true

func _remove_me():
	queue_free()

func _on_pressed():
	GlobalVars.last_clicked = object_text
	if !GlobalVars.text_typing:
		if object_text in GlobalVars.current_sentence:
			GlobalSignals.emit_signal("object_button_pressed")
			return
	GlobalSignals.emit_signal("clicker")
	GlobalSignals.emit_signal("update_on_hover", object_text)
	GlobalSignals.emit_signal("object_button_pressed")		


#func _on_entered():
#	if object_text in GlobalVars.current_sentence:
#		return
#	GlobalSignals.emit_signal("update_on_hover", object_text)
#
#func _on_exit():
#	if !is_inventory_item:
#		GlobalSignals.emit_signal("remove_object")	

func _sentence_check(sentence):
	sentence = sentence.to_lower().strip_edges(true, true)
	var give := "give "+object_text	
	if not object_text in sentence:
		return
	print ("ROPE SENTENE CHECK SENTE ROPE ROPE")
	match sentence:
		"get the rope":
			if !GlobalVars.carried_inventory.has("the rope"):
				print ("not carrying ROP not carrying ROP not carrying ROP ")
				GlobalSignals.emit_signal("save_sentence", "found a rope")
				GlobalSignals.emit_signal("add_to_inventory_bar", object_text)
			GlobalSignals.emit_signal("sentence_clear")
			GlobalSignals.emit_signal("remove_from_game_objects", object_text)
			GlobalSignals.emit_signal("collector")
			GlobalSignals.emit_signal("speak", "It's a rope.")
			queue_free()
#			else:
#				print ("tut active is "+str(GlobalVars.tutorial_active))
#				if GlobalVars.tutorial_active:
#					print ("send buuton pressed")
#					GlobalSignals.emit_signal("button_pressed", "ladderinv")
#		"get the rope":
#			if !is_inventory_item:
#				if !GlobalVars.check_drone_inventory():
#					return
##				var dist = rect_position.distance_to(GlobalVars.current_player.position)
##				if fake_rope:
##					if dist > 3000 and GlobalVars.just_got_rope == false:
##						_get_closer()
##						return
##				else:
##					if dist > 300 and GlobalVars.just_got_rope == false:
##						_get_closer()
##						return
#				GlobalVars.just_got_rope = true
#				GlobalSignals.emit_signal("add_to_inventory_bar", object_text)
#				GlobalSignals.emit_signal("sentence_clear")
#				GlobalSignals.emit_signal("remove_from_game_objects", object_text)
#				var ropes = get_tree().get_nodes_in_group("rope")
#				for a_rope in ropes:
#					if !a_rope.is_inventory_item:
#						a_rope.queue_free()
#
#			else:
#				GlobalSignals.emit_signal("speak", "You already have it.")
		"use the rope":
			GlobalSignals.emit_signal("remove_game_object_rope")
			GlobalSignals.emit_signal("drop_rope")
			GlobalSignals.emit_signal("sentence_clear")
		give:
			var dist_player = GlobalVars.the_drone.position.distance_to(GlobalVars.the_player.position)
			if dist_player > 200:
				_get_closer_to_player()
				return
			GlobalSignals.emit_signal("add_to_inventory_bar_from_drone", object_text)
			GlobalSignals.emit_signal("sentence_clear")
		"look at the rope":
			GlobalSignals.emit_signal("speak", "A long rope.")
		_:
			GlobalSignals.emit_signal("speak", "I can't do that.")


func _get_closer():
	GlobalSignals.emit_signal("speak", "I need to get closer.")




func _on_Area2D_body_entered(body):
	if (body.name == "PlayerGirl"):
		GlobalSignals.emit_signal("can_climb", true, "climb_rope")


func _on_Area2D_body_exited(body):
	if (body.name == "PlayerGirl"):
		GlobalSignals.emit_signal("can_climb", false, "climb_rope")


func _on_DropFail_finished():
	GlobalSignals.emit_signal("drop_rope")
	queue_free()

func _get_closer_to_player():
	if GlobalVars.just_got_rope == false:
		GlobalSignals.emit_signal("speak", "The drone needs to be closer to me.")
