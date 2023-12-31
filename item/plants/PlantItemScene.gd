extends ItemScene
class_name PlantItemScene

@onready var plant_sprite_young: Sprite2D = $PlantSpriteYoung
@onready var plant_sprite_mature: Sprite2D = $PlantSpriteMature
@onready var fruits: Node2D = $Fruits
@onready var fruit_button: Button = $FruitButton
@onready var pot: ItemScene = $Pot

signal fruit_clicked

func on_fruit_clicked() -> void:
	fruit_clicked.emit()

func set_item_data(item_data: ItemData) -> void:
	var plant_component: PlantItemComponent = item_data.get_component("Plant")
	var plant_data := plant_component.plant
	assert(plant_data)
	plant_sprite_young.texture = plant_data.young_texture
	plant_sprite_mature.texture = plant_data.mature_texture
	pot.set_item_data(plant_data.pot_item_data)
	plant_sprite_young.hide()
	plant_sprite_mature.hide()
	fruit_button.hide()
	for fruit in fruits.get_children():
		(fruit as Node2D).hide()
	match plant_data.growth_stage:
		PlantData.GrowthStage.YOUNG:
			plant_sprite_young.show()
		PlantData.GrowthStage.MATURE:
			plant_sprite_mature.show()
	if plant_data.num_fruits > 0:
		fruit_button.show()
		fruit_button.self_modulate = Color(Color.WHITE, 0)
		if plant_data.plant_is_fruit:
			fruit_button.tooltip_text = "Click to pick %s" % plant_data.fruit_item_data.name
		else:
			fruit_button.tooltip_text = "Click to pick %s %s" % [plant_data.num_fruits, plant_data.fruit_item_data.name]
			for i in plant_data.num_fruits:
				if i >= fruits.get_child_count():
					break
				var fruit: Sprite2D = fruits.get_child(i)
				var fruit_texture_component: TextureComponent = plant_data.fruit_item_data.get_component("Texture")
				fruit.texture = fruit_texture_component.texture
				fruit.show()

