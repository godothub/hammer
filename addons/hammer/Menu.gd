@tool
@abstract
extends Control
class_name Menu

## 保持菜单显示状态，除非菜单自行隐藏或关闭
@export var AlwaysOn:bool = false

## 获取菜单根节点
func GetMenuRoot() -> MenuRoot:
	return get_parent()

## 警告信息
func _get_configuration_warnings() -> PackedStringArray:
	var warning:PackedStringArray
	
	if get_parent() is not MenuRoot:
		warning.append("Menu 类型的父节点必须是 MenuRoot 类型")
	
	return warning

## 获取管理根节点
func ManageRootNode() -> ManageRoot:
	return GetMenuRoot().GetManageRoot()

## 加载资源
func ResourceLoad(_tag:StringName) -> Resource:
	return ManageRootNode().ResourceLoad(_tag)

## 保存资源
func ResourceSave(_tag:StringName, _resource:Resource):
	return ManageRootNode().ResourceSave(_tag, _resource)


## 用于菜单隐藏时的处理，将被 MenuRoot 的 HideMenuNode 调用
func Hide() -> void:
	hide()

## 用于菜单显示时的处理，将被 MenuRoot 的 ShowMenuNode 调用
func Show() -> void:
	show()

## 用于传递页面能接受的指令，在 MenuRoot 的 ShowMenuNode 时会一并被调用
@abstract func Command(_argument:String) -> void

func _init() -> void:
	tree_entered.connect(_get_configuration_warnings)
