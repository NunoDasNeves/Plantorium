extends Resource
class_name ItemComponent

var name: StringName: get = get_component_name

static func get_component_name() -> StringName:
	assert(false) # must override this
	return "None"
