extends KinematicBody2D

const UP_DIRECTION := Vector2.UP

var _velocity := Vector2.ZERO

export var speed := 350.0
export var friction := 0.07
export var acceleration := 1

var go_home := false

onready var cover_screen := $"%CoverScreen"


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignals.connect("sentence_checker", self, "_sentence_check")
	GlobalSignals.connect("update_drone_position", self, "_drone_position")
	GlobalVars.the_drone = self
	GlobalSignals.connect("fade_in", self, "_fade_in")
	GlobalSignals.connect("fade_out", self, "_fade_out")

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
	yield(get_tree().create_timer(0.5), "timeout")
	if back_in:
		_fade_in()
	
func _drone_position(drone_pos):
	position = drone_pos

func _physics_process(delta: float) -> void:
	if !GlobalVars.using_drone:
		return
	var _horizontal_direction = (
		Input.get_action_strength("walk_right") -
		Input.get_action_strength("walk_left")
	)
	var _vertical_direction = (
		Input.get_action_strength("down") -
		Input.get_action_strength("jump")
	)

	if _horizontal_direction != 0:
		_velocity.x = lerp(_velocity.x, _horizontal_direction * speed, acceleration)
		if _velocity.x < 0:
			rotation_degrees = -5
		elif _velocity.x > 0:
			rotation_degrees = 5
			
			
	else:
		_velocity.x = lerp(_velocity.x, 0, friction)
		rotation_degrees = 0
		
	if _vertical_direction != 0:
		_velocity.y = lerp(_velocity.y, _vertical_direction * speed, acceleration)
	else:
		_velocity.y = lerp(_velocity.y, 0, friction)
	
	if go_home:
		_velocity = position.direction_to(GlobalVars.the_player.position) * speed
		if abs(position.y - GlobalVars.the_player.position.y) < 20  and abs(position.x - GlobalVars.the_player.position.x) < 50:
			GlobalSignals.emit_signal("drone_items_to_player")
			go_home = false
			GlobalVars.using_drone = false
			GlobalSignals.emit_signal("release_drone", false)
			_velocity = Vector2.ZERO
	
	_velocity = move_and_slide(_velocity, UP_DIRECTION, true)
	


func _sentence_check(sentence):
	sentence = sentence.to_lower().strip_edges(true, true)
	if !visible:
		return
	var shutdown := "return"

	match sentence:
		shutdown:			
			if GlobalVars.using_drone:
				var dist_player = position.distance_to(GlobalVars.the_player.position)
				if dist_player > GlobalVars.pick_up:
					GlobalSignals.emit_signal("speak", "The drone needs to be closer to me.")
					return
				go_home = true
				$DroneTween.interpolate_property(self, "position", position, GlobalVars.the_player.position, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)				
#				GlobalVars.using_drone = false
#				GlobalSignals.emit_signal("release_drone", false)
