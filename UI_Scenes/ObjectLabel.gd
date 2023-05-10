extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var object_text := "This is a long label"

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignals.connect("show_object_labels", self, "_show_hide")
	if get_parent().is_inventory_item:
		visible = false
	else:
		visible = true
		_show_hide(false)
#	setup_label("a large lever")
	
func _show_hide(state):
	$"%ObjectLabel".visible = state
	$"%Star".visible =!state

func setup_label(passed_object:String):
	object_text = passed_object
	var length = object_text.length()
	$"%ObjectLabel".rect_size.x = length*30
	$"%inside_panel".rect_min_size.x = $"%ObjectLabel".rect_size.x-10
	$"%object_text".text = object_text
