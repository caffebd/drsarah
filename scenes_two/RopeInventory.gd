extends TextureButton


var is_inventory_item := true

var object_text := "the rope"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "_on_pressed")


func _on_pressed():
	var sentence = GlobalVars.current_sentence
	sentence = sentence.to_lower().strip_edges(true, true)
	if sentence == "get":
		GlobalSignals.emit_signal("update_on_hover", object_text)
		GlobalSignals.emit_signal("sentence_clear")
		GlobalSignals.emit_signal("remove_from_game_objects", object_text)
		GlobalSignals.emit_signal("collector")
		GlobalSignals.emit_signal("remove_game_object_rope")
	if sentence == "use":
		GlobalSignals.emit_signal("remove_game_object_rope")
		GlobalSignals.emit_signal("drop_rope")
		GlobalSignals.emit_signal("sentence_clear")



