extends Sprite


onready var solid_part = $solidarea/SolidShape

export var is_solid := false

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_solid:
		solid_part.disabled = false
	else:
		solid_part.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if (body.name == "PlayerGirl"):
		print (GlobalVars.wearing_gloves)
		GlobalVars.active_map = get_parent().name
		if GlobalVars.wearing_gloves:
			GlobalSignals.emit_signal("can_climb", true)


func _on_Area2D_body_exited(body):
	if (body.name == "PlayerGirl"):
		GlobalSignals.emit_signal("can_climb", false)
