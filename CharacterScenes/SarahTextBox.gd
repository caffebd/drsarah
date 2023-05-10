extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var spacebar = $"%SpacebarPanel"

var can_repeat = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spacebar_anim(state):
	if !state:
		can_repeat =false
#	if spacebar.visible:
#		do_anim()
		

func do_anim():
	var tween = create_tween()
	tween.tween_property(spacebar, "rect_scale", Vector2(1.1, 1.1), 0.9)
	tween.tween_property(spacebar, "rect_scale", Vector2(0.9, 0.9), 0.9)
	tween.tween_callback(self, "_check_can_repeat" )
	tween.play()

func _check_can_repeat():
	if can_repeat:
		do_anim()
