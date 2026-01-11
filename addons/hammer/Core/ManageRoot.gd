extends Node
class_name ManageRoot
## 对游戏进行管理

## 菜单节点
@export var MenuRootNode:MenuRoot = $MenuRoot:
	set(_menu_root_node):
		MenuRootNode = _menu_root_node
		_menu_root_node.ManageRootNode = self
		update_configuration_warnings()

## 场景节点
@export var SceneRootNode:SceneRoot = $SceneRoot:
	set(_scene_root_node):
		SceneRootNode = _scene_root_node
		_scene_root_node.ManageRootNode = self
		update_configuration_warnings()



## 警告信息
func _get_configuration_warnings() -> PackedStringArray:
	var warning:PackedStringArray
	if not MenuRootNode:
		warning.append("MenuRootNode 不应为空")
	if not SceneRootNode:
		warning.append("SceneRootNode 不应为空")
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
	#var option:OptionResource = OptionResource.new()
	#ResourceSave("Option", option)
	#option = ResourceLoad("Option")



# 
