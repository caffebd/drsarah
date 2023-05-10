extends Node2D


#onready var speak_panel = $"%PlayerGirl/PlayerCam/SpeakBG"
#
#onready var speak_box = $"%PlayerGirl/PlayerCam/SpeakBG/Speak"

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerGirl._fade_in()
	GlobalSignals.emit_signal("speak", "I need to get out of this cave.")



func fall_time():
	$floor.queue_free()
	$PlayerGirl.gravity = 800
	GlobalVars.emit_signal("speak","I need to get out of this cave.")
	yield(get_tree().create_timer(5), "timeout")
	$PlayerGirl._fade_out(false)
	yield(get_tree().create_timer(1), "timeout")
	GlobalVars.load_from_door = false
	GlobalVars.load_from_entry = true
	get_tree().change_scene("res://DemoLevels/Demo1.tscn")
