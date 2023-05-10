extends TextureButton

var my_label :=""

onready var long = $"%long"
onready var short = $"%short"
onready var text_label = $"%Label"

var normal_image := "res://assets/ui/comic_book_ui/bookmark_short.png"
var alert_image := "res://assets/ui/comic_book_ui/Bookmark Short Exclaim.png"

var short_x = 150
var long_x = 72

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_up_button(name):
	$"%Label".text = name
	my_label = name
#	if GlobalVars.new_panels.has(my_label):
#		$"%Short".texture = load(alert_image)
#	else:
#		$"%Short".texture = load(normal_image)
	
func selected(state):
	if state:
		long.visible = true
		short.visible = false
		text_label.rect_position.x = long_x
	else:
		long.visible = false
		short.visible = true
		text_label.rect_position.x = short_x
