extends Control


onready var grid = $"%InventoryGrid"

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignals.connect("add_to_inventory_bar_drone", self, "_add_to_bar")
	GlobalSignals.connect("remove_all_inventory_drone", self, "_remove_all_inventory")

func _add_to_bar(item: String):
	var new_item = load(GlobalVars.inventory_items[item]["scene"])
	var to_add =  new_item.instance()
	to_add.object_text = item
	to_add.set_inventory_image()
	to_add.is_inventory_item = true
	grid.add_child(to_add)
	GlobalSignals.emit_signal("add_to_inventory_list_drone", item)
	print (to_add.is_inventory_item)
	
	
func _remove_all_inventory():
	print ("REMOVE DRONE INV")
	var inv_items = grid.get_children()
	for inv in inv_items:
		print (inv)
		inv.queue_free()
	GlobalVars.drone_carried_inventory = []
