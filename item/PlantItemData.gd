extends ShelfItemData
class_name PlantItemData

enum GrowthStage {
	YOUNG,
	MATURE,
}

@export var young_texture: Texture
@export var mature_texture: Texture
@export var light: PlantFood
@export var water: PlantFood
@export var fertilizer: PlantFood
@export var fruit_per_day: float
@export var growth_per_day: float
@export var max_num_fruits: int
@export var fruit_item_data: ProductItemData

var growth_stage: GrowthStage = GrowthStage.YOUNG
var curr_fruit_growth: float = 0
var curr_growth: float = 0 # at 1, advance to next GrowthStage
var pot_item_data: RackItemData
var num_fruits: int = 0

static func create_from_seed(seed_component: SeedComponent, pot_data: RackItemData) -> PlantItemData:
	var plant_data : PlantItemData = seed_component.plant.duplicate()
	plant_data.pot_item_data = pot_data
	plant_data.light = plant_data.light.duplicate()
	plant_data.water = plant_data.water.duplicate()
	plant_data.fertilizer = plant_data.fertilizer.duplicate()
	return plant_data

func gather_fruit() -> Array[ProductItemData]:
	var ret: Array[ProductItemData] = []

	for i in num_fruits:
		ret.push_back(fruit_item_data)

	num_fruits = 0

	return ret

func next_day() -> void:
	light.next_day()
	water.next_day()
	fertilizer.next_day()
	var is_happy: bool = light.in_happy_range() and \
						 water.in_happy_range() and \
						 fertilizer.in_happy_range()
	var growth_factors: float = light.growth_factor() * water.growth_factor() * fertilizer.growth_factor()
	var fruit_factors: float = light.fruit_factor() * water.fruit_factor() * fertilizer.fruit_factor()

	curr_growth += growth_per_day * growth_factors
	if curr_growth >= 1:
		growth_stage = GrowthStage.MATURE
	if num_fruits < max_num_fruits:
		curr_fruit_growth += fruit_per_day * fruit_factors
		if curr_fruit_growth >= 1:
			var added_fruit: int = floori(curr_fruit_growth)
			num_fruits = clampi(num_fruits + added_fruit, 0, max_num_fruits)
			curr_fruit_growth -= added_fruit
	else:
		curr_fruit_growth = 0
