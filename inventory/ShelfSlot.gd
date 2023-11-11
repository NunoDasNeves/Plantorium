extends Slot
class_name ShelfSlot

@onready var container: Node2D = $Container
@onready var water_bar: ProgressBar = $Water/Control/WaterBar
@onready var water_low: ColorRect = $Water/Control/WaterLow
@onready var water_high: ColorRect = $Water/Control/WaterHigh
@onready var fertilizer_bar: ProgressBar = $Fertilizer/FertilizerBar
@onready var water: Node2D = $Water
@onready var fertilizer: Node2D = $Fertilizer

@export var happy_bar_stylebox_fill: StyleBoxFlat
@export var bad_bar_stylebox_fill: StyleBoxFlat
@export var happy_bar_stylebox_background: StyleBoxFlat
@export var bad_bar_stylebox_background: StyleBoxFlat

func set_slot_data(slot_data: SlotData) -> void:
	for child in container.get_children():
		child.queue_free()
	water.hide();
	fertilizer.hide();

	if not slot_data:
		tooltip_text = ""
		return

	var item_data: ItemData = slot_data.item_data
	var node := item_data.scene.instantiate() as Node2D
	container.add_child(node)
	if item_data is RackItemData: # pots are RackItemData
		(node as RackItemScene).set_item_data(item_data)
	elif item_data is PlantItemData:
		(node as PlantItemScene).set_item_data(item_data)
		var plant_data := item_data as PlantItemData
		water_bar.max_value = plant_data.water.max_val
		water_bar.value = plant_data.water.curr_val
		water_low.position.x = plant_data.water.happy_min / plant_data.water.max_val * water_bar.size.x
		water_high.position.x = plant_data.water.happy_max / plant_data.water.max_val * water_bar.size.x
		if plant_data.water.in_happy_range():
			water_bar.add_theme_stylebox_override("background", happy_bar_stylebox_background)
			water_bar.add_theme_stylebox_override("fill", happy_bar_stylebox_fill)
		else:
			water_bar.add_theme_stylebox_override("background", bad_bar_stylebox_background)
			water_bar.add_theme_stylebox_override("fill", bad_bar_stylebox_fill)
		fertilizer_bar.value = plant_data.fertilizer.curr_val / 100 * 5
		water.show();
		fertilizer.show();
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
