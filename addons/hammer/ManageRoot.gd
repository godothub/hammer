@tool
extends Node
class_name ManageRoot
## 所有子根节点的信息交换中心

## 菜单节点
@export var MenuRootNode:MenuRoot:
	set(_menu_root_node):
		MenuRootNode = _menu_root_node
		update_configuration_warnings()

## GUI节点
@export var GUIRootNode:GUIRoot:
	set(_gui_root_node):
		GUIRootNode = _gui_root_node
		update_configuration_warnings()

## 游戏节点
@export var GameRootNode:GameRoot:
	set(_game_root_node):
		GameRootNode = _game_root_node
		update_configuration_warnings()



## 警告信息
func _get_configuration_warnings() -> PackedStringArray:
	var warning:PackedStringArray
	if not MenuRootNode:
		warning.append("MenuRootNode 不应为空")
	if not GUIRootNode:
		warning.append("GUIRootNode 不应为空")
	if not GameRootNode:
		warning.append("GameRootNode 不应为空")
	return warning


## 资源

## 资源标签对照表
@export var ResourcePathTable:Dictionary[StringName, StringName]
## 资源更新信号
signal ResourceUpdateSignal(_tag:StringName, _resource:Resource)
## 加载资源
func ResourceLoad(_tag:StringName) -> Resource:
	var path:StringName = ResourcePathTable[_tag]
	return ResourceLoader.load(path)
## 保存资源
func ResourceSave(_tag:StringName, _resource:Resource) -> Error:
	var path:StringName = ResourcePathTable[_tag]
	# 存储资源
	var error:Error = ResourceSaver.save(_resource, path)
	# 资源更新
	ResourceUpdateSignal.emit(_tag, _resource)
	return error

#func _ready() -> void:
	#ResourceUpdateSignal.connect(a)
	#var option:OptionResource = OptionResource.new()
	#ResourceSave("Option", option)
#
#func a(_tag:StringName, _resource:Resource):
	#print(_tag)



# 
