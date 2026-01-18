@tool
extends Node3D
class_name GameRoot
## 场景根节点


## 管理根节点
func GetManageRoot() -> ManageRoot:
	return get_parent()

## 玩家节点
@export var PlayerNode:Player:
	set(_player_node):
		PlayerNode = _player_node
		update_configuration_warnings()

## 警告信息
func _get_configuration_warnings() -> PackedStringArray:
	var warning:PackedStringArray
	if get_parent() is not ManageRoot:
		warning.append("GameRoot 类型的父节点必须是 ManageRoot 类型")
	if not PlayerNode:
		warning.append("PlayerNode 不应为空")
	return warning

# 场景

## 场景文件目录
@export_dir var SceneDirectory

## 场景附加信号
signal SceneAppendSignal(_file:StringName)
## 附加场景
func SceneAppend(_file:String) -> bool:
	if get_node(_file):
		return false
	
	var path:String = SceneDirectory.path_join(_file + ".tscn")
	var scene:Scene = load(path).instantiate()
	
	add_child(scene)
	scene.set_name(_file)
	scene.set_owner(self)
	
	SceneAppendSignal.emit(_file)
	return true

## 场景移除信号
signal SceneRemoveSignal(_file:StringName)
## 场景移除
func SceneRemove(_file:String) -> bool:
	var scene:Scene = get_node(_file)
	if not scene:
		return false
	scene.queue_free()
	SceneRemoveSignal.emit(_file)
	return true

func SceneNode(_file:String) -> Scene:
	return get_node(_file)


func _init() -> void:
	tree_entered.connect(update_configuration_warnings)
	child_order_changed.connect(update_configuration_warnings)
