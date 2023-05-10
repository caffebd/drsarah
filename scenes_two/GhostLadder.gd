extends Node2D

var start_pos: Vector2

var can_drop := true

func _ready():
	start_pos = GlobalVars.player_pos
	print (start_pos)
	modulate = Color(1,1,1,0.5)

func _physics_process(delta):
	var mouse_pos := get_global_mouse_position()
	var player_pos = get_parent().get_parent().player.global_position
	var x_pos = clamp(mouse_pos.x, player_pos.x - 500, player_pos.x + 500)
	var y_pos = clamp(mouse_pos.y, player_pos.y - 500, player_pos.y + 500)
	global_position = Vector2(x_pos, y_pos)



func _input(event):
	if event is InputEventMouseButton:
		if can_drop:
			print ("clicked "+str(global_position))
			var set_position = Vector2(position.x-56, position.y-175)
			GlobalSignals.emit_signal("place_ladder", set_position)
			queue_free()
		else:
			$NoDrop.play()




func _on_Area2D_body_entered(body):
	print ("body enter")
	can_drop = false
	$LadderBlock.visible = true
	$LadderOk.visible = false



func _on_Area2D_body_exited(body):
	can_drop = true
	$LadderBlock.visible = false
	$LadderOk.visible = true
