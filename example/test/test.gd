@tool
extends Node
class_name Test

func _get_property_list() -> Array[Dictionary]:
	var property_list:Array[Dictionary]
	
	property_list.append({
		"name": "test",
		"class_name": "",
		"type": TYPE_ARRAY,
		"hint": PROPERTY_HINT_ARRAY_TYPE,
		"hint_string": "",
		"usage":PROPERTY_USAGE_ARRAY
	})
	
	return property_list
