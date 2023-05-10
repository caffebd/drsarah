extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state:="off"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_state("off")

func set_state(new_state):
	state = new_state
	if state == "on":
		visible = true
		$"%ladd_col".disabled = false
	else:
		visible = false
		$"%ladd_col".disabled = true



func _on_on_ladder_body_entered(body):
	if body.name=="PlayerGirl":
		GlobalSignals.emit_signal("can_climb", true, "climb_ladder")


func _on_on_ladder_body_exited(body):
	if body.name=="PlayerGirl":
		GlobalSignals.emit_signal("can_climb", false, "climb_ladder")

