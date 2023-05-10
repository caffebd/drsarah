extends Node2D


onready var right := $"%RightArrow"
onready var left:= $"%LeftArrow"
onready var up:= $"%UpArrow"
onready var down:= $"%DownArrow"

var selected_key: Sprite

var key_string: String

var can_repeat := true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	key_selected("right")

func _input(event):
	if visible:
		match key_string:
			"left":
				if event.is_action_pressed("walk_left"):
					remove_timer()
			"right":
				if event.is_action_pressed("walk_right"):
					remove_timer()
			"up":
				if event.is_action_pressed("jump"):
					remove_timer()
			"down":
				if event.is_action_pressed("down"):
					remove_timer()
					
					
func remove_timer():
#	yield(get_tree().create_timer(3), "timeout")
	var yield_timer = Timer.new()
	add_child(yield_timer)
	yield_timer.start(5); yield(yield_timer, "timeout")
	can_repeat = false
	visible = false

func key_selected(key_name):
	key_string = key_name
	can_repeat = true
	match key_name:
		"left":
			selected_key = left
			show_key()
		"right":
			selected_key = right
			show_key()
		"up":
			selected_key = up
			show_key()
		"down":
			selected_key = down
			show_key()
	
func show_key():
	visible = true
	var tween = create_tween()
	tween.tween_property(selected_key, "scale", Vector2(1.15, 1.15), 0.6)
	tween.tween_property(selected_key, "scale", Vector2(0.9, 0.9), 0.6)
	tween.tween_callback(self, "_check_can_repeat" )
	tween.play()

func _check_can_repeat():
	if can_repeat:
		show_key()
	
