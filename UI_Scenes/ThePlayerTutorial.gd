extends KinematicBody2D


const UP_DIRECTION := Vector2.UP
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


var _jumps_made := 0
var _velocity := Vector2.ZERO

var _can_climb = false

var is_skating := false

var swimming := false

var diving := false

var from_entry:= false

var player_pause := false

var start_pos := Vector2.ZERO

var climb_anim := "climb_ladder"

var jump_delay := 0.5
var jump_pressed := false
var is_grounded: = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _set_climbing(climb_state, anim):
	_can_climb = climb_state
	climb_anim = anim

func _physics_process(delta: float) -> void:
	
	

	
	var _horizontal_direction = (
		Input.get_action_strength("walk_right") -
		Input.get_action_strength("walk_left")
	)


	
	var speed:= walk_speed
	var friction:= walk_friction
	var accelearation:= walk_acceleration
	var idle_speed := walk_idle
	
	var _is_falling = _velocity.y > 0.0 and not is_on_floor()
	var _is_jumping = jump_pressed and is_grounded
	var _is_climbing_up = Input.is_action_pressed("jump")
	var _is_climbing_down = Input.is_action_pressed("down")
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
	_velocity.y += gravity * delta
	

	if is_on_floor():
		is_grounded = true
		_jumps_made = 0
		$CoyoteTimer.start()
	
	if Input.is_action_just_pressed("jump"):
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
	elif _is_jumping and _jumps_made == 0:
		jump_pressed = false
		_jumps_made = 1
		_velocity.y = -jump_strength
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


func _on_JumpTimer_timeout():
	jump_pressed = false


func _on_CoyoteTimer_timeout():
	is_grounded = false



func _on_Area2D_body_entered(body):
	_set_climbing(true,"climb_ladder")


func _on_Area2D_body_exited(body):
	_set_climbing(false,"climb_ladder")
