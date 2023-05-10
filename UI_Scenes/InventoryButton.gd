extends TextureButton


var my_item := ""


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "_on_pressed")
	connect("mouse_entered", self, "_on_entered")
	connect("mouse_exited", self, "_on_exit")

func set_up_inventory_button(item: String):
	my_item = item
	var image_type:String = GlobalVars.inventory_items[item]["image"]
	texture_normal = load(image_type)

func _on_pressed():
	GlobalSignals.emit_signal("object_button_pressed")

func _on_entered():
	GlobalSignals.emit_signal("update_on_hover", my_item)

func _on_exit():
	GlobalSignals.emit_signal("remove_object")	
	
