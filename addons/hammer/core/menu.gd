@tool
@abstract
extends Control
class_name Menu

## 获取菜单根节点
func get_menu_root() -> MenuRoot:
	return get_parent()

## 警告信息
func _get_configuration_warnings() -> PackedStringArray:
	var warning: PackedStringArray

	if get_parent() is not MenuRoot:
		warning.append("Menu 类型的父节点必须是 MenuRoot 类型")

	return warning

## 用于传递页面能接受的指令。
@abstract func command(_argument: String) -> void

func _init() -> void:
	tree_entered.connect(_get_configuration_warnings)
