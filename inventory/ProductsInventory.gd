extends Inventory
class_name ProductsInventory

@onready var action: Button = $VBoxContainer/MarginContainer2/Action
@onready var help_text: Label = $"VBoxContainer/MarginContainer3/Help text"

func populate_item_grid() -> void:
	for child in item_grid.get_children():
		child.queue_free()

	var prod_inventory_data := inventory_data as ProductInventoryData
	for slot_data in inventory_data.slot_datas:
		var slot: ProductSlot = slot_scene.instantiate()
		item_grid.add_child(slot)
		slot.slot_clicked.connect(on_slot_interact)
		slot.quantity_selected_changed.connect(prod_inventory_data.change_quantity_selected)
		slot.set_slot_data(slot_data)

func connect_and_populate() -> void:
	inventory_data.inventory_updated.connect(update_slot)

	var prod_inventory_data := inventory_data as ProductInventoryData
	action.button_down.connect(prod_inventory_data.action_pressed)
	prod_inventory_data.action_button_updated.connect(update_action_button)
	prod_inventory_data.select_mode_updated.connect(update_select_mode)

	populate_item_grid()

func update_select_mode() -> void:
	var prod_inventory_data := inventory_data as ProductInventoryData
	if prod_inventory_data.select_mode:
		action.disabled = false
		help_text.text = "Click to (de)select items"
	else:
		action.disabled = true
		help_text.text = "Hold down to select items"

func update_action_button() -> void:
	var prod_inventory_data := inventory_data as ProductInventoryData
	action.text = prod_inventory_data.action_text
