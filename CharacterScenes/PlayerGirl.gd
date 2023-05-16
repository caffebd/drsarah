extends KinematicBody2D

var UP_DIRECTION := Vector2.UP
export var walk_speed := 650.0
export var skate_speed := 1200.0

export var walk_acceleration := 0.5
export var skate_acceleration := 0.8

export var walk_friction := 0.8
export var skate_friction := 0.05

export var walk_idle := 5.0
export var skate_idle := 200.0

export var acceleration := 100.0
export var jump_strength:= 1500.0
export var max_jumps := 2
export var double_jump_strength:= 1250.0
export var gravity:= 4500.0
export var climb_speed:=300
export var swim_speed:=100

var gravity_dir := 1

var last_move_right := true

var _is_dancing = false

onready var countdown_area = $"%CountDown"
onready var countdown_label = $"%counter"

onready var cover_screen := $"%UIControl/CoverScreen"

onready var sarah_talk_box = $"%SarahTextBox"
onready var other_talk_box = $"%OtherTextBox"
onready var sarah_talk_text = $"%RichTextLabel"
onready var other_talk_text = $"%OtherRichTextLabel"
onready var sarah_spacebar = $"%SpacebarPanel"
onready var other_spacebar = $"%OtherSpacebarPanel"
onready var other_speaker = $"%OtherSpeaker"

onready var conversation_audio = $"%Conversation"

onready var vocab_grid = $"%UIControl/VocabPanel/MarginContainer/VocabGrid"
onready var inv_grid = $"%UIControl/InventoryPanel/Node2D/MarginContainer/ScrollContainer/InventoryGrid"

onready var arrow_keys = $"%ArrowKeys"

var climb_anim := "climb_ladder"

var jump_delay := 0.5
var jump_pressed := false
var is_grounded: = false
var is_on_door := false

var countdown_time := 0

var level_to_load := "res://DemoLevels/Demo1.tscn"

var _jumps_made := 0
var _velocity := Vector2.ZERO

var _can_climb = false

var _can_fly := false

var is_skating := false

var swimming := false

var diving := false

var from_entry:= false

var player_pause := false

var start_pos := Vector2.ZERO

var i_am_talking := false

var full_conversation: Array

var convo_count := 0

var other_speaker_object

var talk_left_x := 65.00
var talk_right_x := 1125.00

var touch_x: float = 0
var touch_y: float = 0

func _ready():
	GlobalSignals.connect("can_climb", self, "_set_climbing")
	GlobalSignals.connect ("wear_skates", self, "_set_skates")
	GlobalSignals.connect("touching_door", self, "_set_touching_door")
	GlobalSignals.connect("update_player_position", self, "_update_player_pos")
	GlobalSignals.connect("water_entered", self, "_water_entered")
	GlobalSignals.connect("water_exited", self, "_water_exited")
	GlobalSignals.connect("fade_in", self, "_fade_in")
	GlobalSignals.connect("fade_out", self, "_fade_out")
	GlobalSignals.connect("pause_player_movement", self, "_pause_player_movement")
	GlobalSignals.connect("tut_done", self, "tut_done")
	GlobalSignals.connect("hide_pointer", self, "hide_pointer")
	GlobalSignals.connect("dance", self, "_dance")
	GlobalSignals.connect("xyzzy", self, "xyzzy")
	GlobalSignals.connect("start_countdown", self, "_start_countdown")
	GlobalSignals.connect("Timeup", self, "_timeup")
	GlobalSignals.connect("conversation_time", self, "_conversation_time")
	GlobalSignals.connect("i_can_fly", self, "_i_can_fly")
	GlobalSignals.connect("speedster", self, "_speedster")
	GlobalSignals.connect("gravity_change", self, "_gravity_change")
	GlobalSignals.connect("pogo", self, "_pogo")
	GlobalSignals.connect("use_move_vector", self, "_use_move_vector")
	GlobalSignals.connect("touch_jump", self, "_touch_jump")
	
	cover_screen.visible = true
	_can_climb = false
	GlobalVars.the_player = self
	start_pos = position

func _use_move_vector(move_vector):
	touch_x = move_vector.x
	touch_y = move_vector.y

func _gravity_change(dir):
	if dir == "up":
		gravity_dir = 1
		UP_DIRECTION = Vector2.UP
		$AnimatedSprite.flip_v = false
		
	else:
		gravity_dir = -1
		UP_DIRECTION = Vector2.DOWN
		$AnimatedSprite.flip_v = true
		walk_speed = 650
		_can_fly = false
		$"%timer_image".texture = load("res://assets/ui/escher.png")
		countdown_time = 10 
		countdown_label.text = str(countdown_time)
		countdown_area.visible = true
		$"%TickTimer".start()
		

func xyzzy():
	position = start_pos

func _pause_player_movement(state):
	print ("PLAYER PAUSE CALLED "+str(state))
	player_pause = state

func _fade_in():
	cover_screen.modulate = Color(1, 1, 1, 1)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(cover_screen, "modulate",  Color(1, 1, 1, 0), 1.0)

func _fade_out(back_in:bool):
	cover_screen.modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(cover_screen, "modulate",  Color(1, 1, 1, 1), 0.5)
	var yield_timer = Timer.new()
	add_child(yield_timer)
	yield_timer.start(0.5); yield(yield_timer, "timeout")
	if back_in:
		_fade_in()



	
func _set_skates(state):
	is_skating = state	

func _water_entered():
	gravity = 10.0
	_velocity.y = 0
	swimming = true
	print ("swim")

func _water_exited():
	gravity = 4500.0
	swimming = false
	print ("stop swim")

func _update_player_pos(player_pos):
	print ("Player pos load is "+str(player_pos))
	position = player_pos
	
func _set_touching_door(door_state, level, entry_door):
	level_to_load = level
	is_on_door = door_state
	from_entry = entry_door
	print (level_to_load)

func _set_climbing(climb_state, anim):
	if _can_fly:
		return
	_can_climb = climb_state
	climb_anim = anim
	

func _input(event):
	if !i_am_talking:
		return
	if event is InputEventKey and event.is_action_pressed("ui_select") and event.echo == false:
		convo_count += 1
		if convo_count < full_conversation.size():
			conversation(full_conversation[convo_count])
		else:
			conversation_over()

func _touch_jump():
	if is_on_door:
		print ("level done")
		if from_entry:
			GlobalVars.load_from_door = false
			GlobalVars.load_from_entry = true
		else:
			GlobalVars.load_from_door = true
			GlobalVars.load_from_entry = false
		if GlobalVars.tree_timers.size() > 0:
			for t in GlobalVars.tree_timers:
				t.stop()
		GlobalSignals.emit_signal("changing_level")
		get_tree().change_scene(level_to_load)
		return	
	jump_pressed = true
	$JumpTimer.start()

func _physics_process(delta: float) -> void:
	
#	countdown_label.text = str(Engine.get_frames_per_second())
	if _is_dancing:
		return

	if i_am_talking:
		if !$"%StopCover".visible:
			$"%StopCover".visible = true
	else:		
		if $"%StopCover".visible:
			$"%StopCover".visible = false	
	
	if GlobalVars.using_drone or player_pause or i_am_talking:
		if $AnimatedSprite.animation != "idle":
				$AnimatedSprite.set_animation("idle")
				print ("Player is Paused "+str(player_pause))	
				print ("Player is Talking "+str(i_am_talking))	
		return
	

	
	var _horizontal_direction = (
		Input.get_action_strength("walk_right") -
		Input.get_action_strength("walk_left")
	)
	
	if touch_x !=0:
		_horizontal_direction = touch_x
	
#	print (touch_y)


	
	var speed:= walk_speed
	var friction:= walk_friction
	var accelearation:= walk_acceleration
	var idle_speed := walk_idle
	
	var _is_falling = _velocity.y > 0.0 and not is_on_floor()
	var _is_jumping = jump_pressed and is_grounded
	var _is_climbing_up = Input.is_action_pressed("jump") or touch_y < -0.2
	var _is_climbing_down = Input.is_action_pressed("down") or touch_y > 0.2
	var _in_air =  not is_grounded
	var _is_double_jumping = Input.is_action_just_pressed("jump") and _is_falling
	var _is_jump_cancelled = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var _is_idling := is_on_floor() and abs(_velocity.x) < idle_speed
#	is_zero_approx(_velocity.x)
	var _is_walking := is_on_floor() and not abs(_velocity.x) < idle_speed
	var _climb_anim := false
	var _climb_stop := false
	var _is_sliding := false	
	
	if is_skating:
		speed = skate_speed
		friction = skate_friction
		accelearation = skate_acceleration
		idle_speed = skate_idle

	if swimming:
		speed = swim_speed
		if _is_climbing_up:
			_velocity.y = -swim_speed
		elif _is_climbing_down:
			_velocity.y = +swim_speed
		if Input.is_action_just_released("jump") or Input.is_action_just_released("down"):
			lerp(_velocity.y, 0, 0.08)
	
#	_velocity.x = _horizontal_direction * speed
#	_velocity.x  = lerp(_horizontal_direction * speed , 0, 0.9)
	if _horizontal_direction != 0:
		_velocity.x = lerp(_velocity.x, _horizontal_direction * speed, accelearation)
	else:
		_velocity.x = lerp(_velocity.x, 0, friction)
	_velocity.y += gravity * delta * gravity_dir

	if is_on_floor():
		is_grounded = true
		_jumps_made = 0
		$CoyoteTimer.start()
	
	if Input.is_action_just_pressed("jump"):
		if is_on_door:
			print ("level done")
			if from_entry:
				GlobalVars.load_from_door = false
				GlobalVars.load_from_entry = true
			else:
				GlobalVars.load_from_door = true
				GlobalVars.load_from_entry = false
			if GlobalVars.tree_timers.size() > 0:
				for t in GlobalVars.tree_timers:
					t.stop()
			GlobalSignals.emit_signal("changing_level")
			get_tree().change_scene(level_to_load)
			return			
		jump_pressed = true
		$JumpTimer.start()


	
	
	if _can_climb:
		if _is_climbing_up:
			_velocity.y = -climb_speed
			_climb_anim = true
		elif _is_climbing_down:
			_velocity.y = +climb_speed
			_climb_anim = true
		else:
			_velocity.y = 0
			_climb_stop = true
	elif _can_fly:
		if _is_climbing_up:
			_velocity.y = -climb_speed
		elif _is_climbing_down:
			_velocity.y = +climb_speed
		else:
			_velocity.y = 0	
	elif _is_jumping and _jumps_made == 0:
		jump_pressed = false
		_jumps_made = 1
		_velocity.y = -jump_strength * gravity_dir
#	elif _is_double_jumping:
#		_jumps_made += 1
#		if _jumps_made <= max_jumps:
#			_velocity.y = -double_jump_strength
#	elif _is_jump_cancelled:
#		_velocity.y = 0.0
#	elif _is_idling or _is_walking:
#		_jumps_made = 0
			
	if _is_jumping:
		$AnimatedSprite.set_animation("jump_right")		
	elif _is_walking and $AnimatedSprite.animation != "walk":
		$AnimatedSprite.set_animation("walk")
	elif _is_idling and $AnimatedSprite.animation != "idle":
		$AnimatedSprite.set_animation("idle")
	elif _climb_anim and not is_on_floor() and $AnimatedSprite.animation != climb_anim:
		$AnimatedSprite.set_animation(climb_anim)
	elif _climb_stop and not is_on_floor()  and $AnimatedSprite.animation != climb_anim+"_back":
		$AnimatedSprite.set_animation(climb_anim+"_back")
	
	$AnimatedSprite.flip_h = _velocity.x<0
	
	
	_velocity = move_and_slide(_velocity, UP_DIRECTION, true)

#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		if "map" in collision.collider.name:
#			print (collision.collider.name)
#		else:
#			if "map" in collision.collider.get_parent().name:
#				print(collision.collider.get_parent().name)
#			else:
#				if "map" in collision.collider.get_parent().get_parent().name:
#					print(collision.collider.get_parent().get_parent().name)


func _on_JumpTimer_timeout():
	jump_pressed = false


func _on_CoyoteTimer_timeout():
	is_grounded = false

func return_map_name()->String:
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if "map" in collision.collider.name:
			return collision.collider.name
		else:
			if "map" in collision.collider.get_parent().name:
				return collision.collider.get_parent().name
			else:
				if "map" in collision.collider.get_parent().get_parent().name:
					return collision.collider.get_parent().get_parent().name
				else:
					return GlobalVars.active_map	
	return GlobalVars.active_map		


func _on_SaveBtn_pressed():
	GlobalSignals.emit_signal("save_game")


func _on_LoadBtn_pressed():
	GlobalSignals.emit_signal("load_game", false, false)

func _dance():
	_is_dancing = true
	var krider = load("res://assets/audio/music/krider-mp3.mp3")
	$GirlAudio.stream=krider
	$GirlAudio.play()
	$AnimatedSprite.set_animation("dance")

func _on_GirlAudio_finished():
	_is_dancing = false
	$AnimatedSprite.set_animation("idle")

func tut_done():
	player_pause = false
	$"%TutMouse".visible = false

func hide_pointer():
	$"%TutMouse".visible = false
	
func find_button(btn_name)->Button:
	var ret_btn = null
	for btn in vocab_grid.get_children():
		if btn.my_word == btn_name:
			return btn
	return ret_btn

func find_inventory(inv_name)->TextureButton:
	var ret_inv = null
	for inv in inv_grid.get_children():
		if inv.object_text==inv_name:
			return inv
	return ret_inv


func tut_to_look():
	print ("tut look")
	player_pause = true
	GlobalVars.tutorial_active = true
	var move_to_me = find_button("Look at")
	if move_to_me == null:
		return
	player_pause = true
	$"%TutMouse".visible = true
	var tween = create_tween()
	var go_to = Vector2(move_to_me.rect_global_position.x+60, move_to_me.rect_global_position.y+40)
	tween.tween_property($"%TutMouse", "rect_global_position", go_to, 2.0 )

	
func tut_to_give():
	print ("tut give")
	var move_to_me = find_button("Give")
	if move_to_me == null:
		return
	player_pause = true
	$"%TutMouse".visible = true
	var tween = create_tween()
	var go_to = Vector2(move_to_me.rect_global_position.x+60, move_to_me.rect_global_position.y+40)
	tween.tween_property($"%TutMouse", "rect_global_position", go_to, 2.0 )

func tut_to_get():
	print ("tut get")
	var move_to_me = find_button("Get")
	if move_to_me == null:
		return
	player_pause = true
	$"%TutMouse".visible = true
	var tween = create_tween()
	var go_to = Vector2(move_to_me.rect_global_position.x+60, move_to_me.rect_global_position.y+40)
	tween.tween_property($"%TutMouse", "rect_global_position", go_to, 2.0 )
	GlobalSignals.emit_signal("speak", "Follow the arrow. Click on the word Get.") 

func tut_to_use():
	print ("tut use")
	var move_to_me = find_button("Use")
	if move_to_me == null:
		return
	player_pause = true
	$"%TutMouse".visible = true
	var tween = create_tween()
	var go_to = Vector2(move_to_me.rect_global_position.x+60, move_to_me.rect_global_position.y+40)
	tween.tween_property($"%TutMouse", "rect_global_position", go_to, 2.0 )
#	GlobalSignals.emit_signal("speak", "Follow the arrow. Click on the word Use.") 


func tut_to_medicine():
	print ("tut medicine")
	var move_to_me = find_inventory("the medicine")
	if move_to_me == null:
		return
	player_pause = true
	$"%TutMouse".visible = true
	var tween = create_tween()
	var go_to = Vector2(move_to_me.rect_global_position.x+60, move_to_me.rect_global_position.y+40)
	tween.tween_property($"%TutMouse", "rect_global_position", go_to, 2.0 )


func tut_to_clock():
	print ("tut clock")
	var move_to_me = find_inventory("the clock")
	if move_to_me == null:
		return
	player_pause = true
	$"%TutMouse".visible = true
	var tween = create_tween()
	var go_to = Vector2(move_to_me.rect_global_position.x+60, move_to_me.rect_global_position.y+40)
	tween.tween_property($"%TutMouse", "rect_global_position", go_to, 2.0 )

func tut_to_ladder_inventory():
	print ("tut ladder")
	var move_to_me = find_inventory("the ladder")
	if move_to_me == null:
		return
	player_pause = true
	$"%TutMouse".visible = true
	var tween = create_tween()
	var go_to = Vector2(move_to_me.rect_global_position.x+60, move_to_me.rect_global_position.y+40)
	tween.tween_property($"%TutMouse", "rect_global_position", go_to, 2.0 )


func tut_to_sign(pos):	
	pos.x += 30
	pos.y += 60
	$"%TutMouse".visible = true
	var tween = create_tween()
	tween.tween_property($"%TutMouse", "rect_global_position", pos, 2.0 )



func tut_to_hole(pos):
	pos.x += 50
	pos.y += 170
	$"%TutMouse".visible = true
	var tween = create_tween()
	tween.tween_property($"%TutMouse", "rect_global_position", pos, 2.0 )


func tut_to_boy(pos):
	pos.x += 30
	pos.y += 60
	$"%TutMouse".visible = true
	var tween = create_tween()
	tween.tween_property($"%TutMouse", "rect_global_position", pos, 2.0 )

func tut_to_girl(pos):
	pos.x += 30
	pos.y += 60
	$"%TutMouse".visible = true
	var tween = create_tween()
	tween.tween_property($"%TutMouse", "rect_global_position", pos, 2.0 )

func tut_to_medicine_get(pos):
	pos.x += 30
	pos.y += 60
	$"%TutMouse".visible = true
	var tween = create_tween()
	tween.tween_property($"%TutMouse", "rect_global_position", pos, 2.0 )


func tut_to_push():
	print ("tut push")
	var move_to_me = find_button("Push")
	if move_to_me == null:
		return
	player_pause = true
	$"%TutMouse".visible = true
	var tween = create_tween()
	var go_to = Vector2(move_to_me.rect_global_position.x+60, move_to_me.rect_global_position.y+40)
	tween.tween_property($"%TutMouse", "rect_global_position", go_to, 2.0 )


func tut_to_lever(pos):
	pos.x += 30
	pos.y += 60
	GlobalSignals.emit_signal("speak","Click on the lever.")
	$"%TutMouse".visible = true
	var tween = create_tween()
	tween.tween_property($"%TutMouse", "rect_global_position", pos, 2.0 )

func _i_can_fly():
	gravity = 0
	walk_speed = 650
	jump_strength = 1500
	_can_fly = true
	$"%timer_image".texture = load("res://assets/ui/jet_pack.png")
	countdown_time = 10 
	countdown_label.text = str(countdown_time)
	countdown_area.visible = true
	$"%TickTimer".start()
	
func _pogo():
	gravity = 4500.0
	walk_speed = 650
	jump_strength = 2500
	$"%timer_image".texture = load("res://assets/ui/pogo.png")
	countdown_time = 10 
	countdown_label.text = str(countdown_time)
	countdown_area.visible = true
	$"%TickTimer".start()

func _speedster():
	walk_speed = 2000
	gravity = 4500.0
	jump_strength = 1500
	_can_fly = false
	$"%timer_image".texture = load("res://assets/ui/flash.png")
	countdown_time = 10 
	countdown_label.text = str(countdown_time)
	countdown_area.visible = true
	$"%TickTimer".start()
	
func _start_countdown(time):
	$"%timer_image".texture = load("res://assets/ui/Clock.png")
	countdown_time = time 
	countdown_label.text = str(countdown_time)
	countdown_area.visible = true
	$"%TickTimer".start()

func _end_countdown():
	print ("player end countdoen")
	GlobalSignals.emit_signal("Timeup")
	

func _timeup():
	countdown_time = 0
	countdown_area.visible = false
	gravity = 4500.0
	_can_fly = false
	jump_strength = 1500
	walk_speed = 650
	_gravity_change("up")
	

func _on_TickTimer_timeout():
	countdown_time -= 1
	countdown_label.text = str(countdown_time)
	if countdown_time <= 0:
		$"%TickTimer".stop()
		_end_countdown()
	else:
		$"%TickTimer".start()
	
		
func _conversation_time(full_convo, object, left_speaker):
	other_speaker_object = object
	full_conversation = full_convo
	if left_speaker == "Sarah":
		sarah_talk_box.rect_position.x = talk_left_x
		other_talk_box.rect_position.x = talk_right_x
	else:
		sarah_talk_box.rect_position.x = talk_right_x
		other_talk_box.rect_position.x = talk_left_x
	convo_count = 0
	conversation(full_conversation[convo_count])
	_pause_player_movement(true)
	i_am_talking = true
	
func conversation(convo):
	if convo["speaker"] == "Sarah":
		sarah_speak(convo["text"], convo["voice"], convo["spacebar"])
	else:
		other_speak(convo["speaker"], convo["text"], convo["voice"],convo["spacebar"])

func sarah_speak(text, voice, spacebar):
	other_talk_box.visible = false
	sarah_talk_text.text = text
	sarah_talk_box.visible = true
	sarah_talk_box.spacebar_anim(true)
	if voice != "":
		conversation_audio.stream = load(voice)
		conversation_audio.play()
		

func other_speak(speaker, text, voice, spacebar):
	sarah_talk_box.visible = false
	sarah_talk_box.spacebar_anim(false)
	other_speaker.text = speaker
	other_talk_text.text = text
	other_talk_box.visible = true
	if voice != "":
		conversation_audio.stream = load(voice)
		conversation_audio.play()
	

func conversation_over():
	print ("convo done")
	sarah_talk_box.visible = false
	other_talk_box.visible = false
	sarah_talk_box.spacebar_anim(false)
	i_am_talking = false
	_pause_player_movement(false)
	other_speaker_object.callback_from_converastion_end()


func tut_arrow_keys(dir):
	arrow_keys.key_selected(dir)
	


func _on_TextureButton_pressed():
	if GlobalVars.can_exit:
		get_tree().change_scene("res://UI_Scenes/LevelSelect.tscn")


func _on_ZoomBtn_toggled(button_pressed):
	var tween = create_tween()
	if button_pressed:
		print ("Zoom Out")
		tween.tween_property($"%PlayerCam", "zoom", Vector2(1.75, 1.75), 1.5 )

	else:
		print ("Zoom IN")
		tween.tween_property($"%PlayerCam", "zoom", Vector2(1.25, 1.25), 1.5 )

