extends Control


onready var grid = $"%InventoryGrid"
onready var scroll_container = $"%ScrollContainer"

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignals.connect("add_to_inventory_bar", self, "_add_to_bar")
	GlobalSignals.connect("add_to_inventory_bar_load", self, "_add_to_bar_load")
	GlobalSignals.connect("add_to_inventory_bar_from_drone", self, "_add_to_bar_from_drone")
	GlobalSignals.connect("remove_all_inventory", self, "_remove_all_inventory")
	GlobalSignals.connect("remove_crystal", self, "_remove_crystal")
	scroll_container.get_v_scrollbar().modulate = Color(0, 0, 0, 0)


func _add_to_bar(item: String):
	print ("getting "+item)
	if check_for_doubles(item):
		if GlobalVars.using_drone:
			GlobalSignals.emit_signal("add_to_inventory_bar_drone", item)
			return
		if item == "the rope":
			_add_rope()
			return
		var object_count = count_items(item)
		if object_count>1:
			return
		var new_item = load(GlobalVars.inventory_items[item]["scene"])
		var to_add =  new_item.instance()
		to_add.object_text = item
		to_add.set_inventory_image()
		
		to_add.is_inventory_item = true
		grid.add_child(to_add)
		grid.move_child(to_add, 0)
		
		GlobalSignals.emit_signal("add_to_inventory_list", item)
		print (to_add.is_inventory_item)
	else:
		print ("you got a double")

func _add_rope():
	var new_item = load("res://scenes_two/RopeInventory.tscn")
	var to_add =  new_item.instance()
	to_add.is_inventory_item = true
	grid.add_child(to_add)
	grid.move_child(to_add, 0)
	GlobalSignals.emit_signal("add_to_inventory_list", "the rope")
	

#func _add_to_bar_from_drone(item):
#	var new_item = load(GlobalVars.inventory_items[item]["scene"])
#	var to_add =  new_item.instance()
#	to_add.object_text = item
#	to_add.set_inventory_image()
#	to_add.is_inventory_item = true
#	grid.add_child(to_add)
#	grid.move_child(to_add, 0)
#	GlobalSignals.emit_signal("add_to_inventory_list_from_drone", item)

func _add_to_bar_from_drone(item):
	GlobalSignals.emit_signal("remove_all_inventory_drone")
	if check_for_doubles(item):
		if item == "the rope":
			_add_rope()
			return
		var object_count = count_items(item)
		if object_count>1:
			return
		var new_item = load(GlobalVars.inventory_items[item]["scene"])
		var to_add =  new_item.instance()
		to_add.object_text = item
		to_add.set_inventory_image()
		
		to_add.is_inventory_item = true
		grid.add_child(to_add)
		grid.move_child(to_add, 0)
		
		GlobalSignals.emit_signal("add_to_inventory_list", item)
		print (to_add.is_inventory_item)
		GlobalSignals.emit_signal("add_to_inventory_list_from_drone", item)
	else:
		print ("you got a double")
	GlobalSignals.emit_signal("save_game")
		

func _add_to_bar_load(item: String):
	print ("to inv from load "+item)
	if check_for_doubles(item):
		if item == "the rope":
			_add_rope()
			return
		var object_count = count_items(item)
		if object_count>1:
			return
		var new_item = load(GlobalVars.inventory_items[item]["scene"])
		var to_add =  new_item.instance()
		to_add.object_text = item
		to_add.set_inventory_image()
		to_add.is_inventory_item = true
		grid.add_child(to_add)
		GlobalSignals.emit_signal("add_to_inventory_list", item)
		print (to_add.is_inventory_item)

	
func _remove_all_inventory():
	var inv_items = grid.get_children()
	for inv in inv_items:
		inv.queue_free()
	GlobalVars.carried_inventory = []


func _on_UpArrow_pressed():
	print ("pressy")
	for i in 32:
		scroll_container.set_v_scroll ( scroll_container.get_v_scroll() - 7)
		yield(get_tree().create_timer(0.005), "timeout")	


func _on_DownArrow_pressed():
	for i in 32:
		scroll_container.set_v_scroll ( scroll_container.get_v_scroll() + 7)
		yield(get_tree().create_timer(0.005), "timeout")	


func check_for_doubles(item):
	if GlobalVars.single_inventory_items.has(item):
		if GlobalVars.carried_inventory.has(item):
			return false
		else:
			return true
	else:
		return true

func count_items(item)->int:
	var counter = 1
	for check_item in $"%InventoryGrid".get_children():
		print ("COUNTING "+check_item.object_text+"  "+item)
		if check_item.object_text == item:
			counter += 1
			if counter>1:
				check_item.inventory_count(counter)
#				GlobalVars.crystal_count(item, counter)				
	return counter


func _remove_crystal(color: String):
	var count = 0
	for check_item in $"%InventoryGrid".get_children():
		if color in  check_item.object_text:
			print ("Remove "+color+" "+check_item.object_text)
			count = int(check_item.inventory_count)
			check_item.queue_free()
	var temp_inv = 	GlobalVars.carried_inventory.duplicate()
	for i in range(GlobalVars.carried_inventory.size()-1,-1,-1):
		if color in GlobalVars.carried_inventory[i]:
			GlobalVars.carried_inventory.remove(i)
	print (GlobalVars.carried_inventory)
	GlobalVars.crystal_count(color, count)
	GlobalSignals.emit_signal("save_game")
	FirebaseRest.update_collected_crystals()
	GlobalSignals.emit_signal("update_to_collect")
