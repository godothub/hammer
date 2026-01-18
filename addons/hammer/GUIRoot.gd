@tool
extends Control
class_name GUIRoot
## GUI根节点

## 管理根节点
var ManageRootNode:ManageRoot

func _ready() -> void:
	child_order_changed.connect(update_configuration_warnings)

func _get_configuration_warnings() -> PackedStringArray:
	var warning:PackedStringArray
	for _child in get_children():
		if _child is not GUI:
			warning.append(_child.get_name() + " 作为 GUIRoot 的节点应是 GUI 类型")
	return warning
