extends Node2D

onready var cam = $Camera2D
onready var tween = $Tween
onready var story = $"%StoryText"

var cam_start := Vector2.ZERO
var cam_end := Vector2.ZERO

var story_count := 0

var intro_text = [
	"In a far away part of the country, there lives a community cut off from the rest of the world.",
	"The journey to this community is long and dangerous but Dr. Sarah Bari knows she must make it.",
	"She has heard rumours that the children of this community have been falling sick.",
	"A blood test that arrived at her clinic showed that the children might have an infection known as TB.",
	"TB or to give it its full name, Tuberculosis, can be treated with the right medication.",
	"Dr Sarah knows this community does not have this medicine; she is on a mission to bring it to them to save their children."
]

# Called when the node enters the scene tree for the first time.
func _ready():
	cam_start = cam.position
	cam_end = cam_start
	cam_end.y = cam_start.y - 8000
	story.text = intro_text[story_count]
	scroll_up()
	_fade_out()

func _input(event):
	if event is InputEventKey and event.pressed and event.echo == false:
		if story_count < intro_text.size()-1:
			story_count += 1
			story.text = intro_text[story_count] 
		else:
			var tween = create_tween()
			tween.set_ease(Tween.EASE_OUT_IN)
			tween.tween_property($"%PressPrompt", "modulate",  Color(1, 1, 1, 1), 2.0)
			yield(get_tree().create_timer(2.0), "timeout")
			get_tree().change_scene("res://Intro/VillageIntro.tscn")

func _fade_in():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property($"%PressPrompt", "modulate",  Color(1, 1, 1, 0), 1.0)
	yield(get_tree().create_timer(1.0), "timeout")
	_fade_out()
	
func _fade_out():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property($"%PressPrompt", "modulate",  Color(1, 1, 1, 1), 2.0)
	yield(get_tree().create_timer(2.0), "timeout")
	_fade_in()

func scroll_up():
	tween.interpolate_property(cam, "position", cam_start, cam_end, 120.0)
	tween.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
