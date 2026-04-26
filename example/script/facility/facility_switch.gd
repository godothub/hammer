@tool
extends FacilityInteract
class_name FacilitySwitch


func interact() -> void:
	active = not active
