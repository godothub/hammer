extends Node3D
class_name SceneRoot
## 场景根节点

## 管理根节点
var ManageRootNode:ManageRoot


# 玩家
## 玩家嵌入场景
#@export var PlayerEmbedScene:bool = true

## 玩家节点
#@export var PlayerNode:Player


# 场景
## 当前场景
@export var SceneNode:Scene:
	set(_scene_node):
		_scene_node.SceneRootNode = self
		SceneNode = _scene_node
signal SceneChangedSignal(_tag:StringName, _file:StringName)
## 场景文件目录
@export var SceneDirectoryTable:Dictionary[StringName, StringName] = {"Scene": "res://Scene/"}
## 更改场景
func SceneChange(_tag:StringName, _file:StringName) -> void:
	var path:String = SceneDirectoryTable[_tag].path_join(_file)
	var scene:Scene = load(path).instantiate()
	scene.set_name("Scene")
	
	add_child(scene)
	SceneNode = scene
	SceneNode.queue_free()
	
	SceneChangedSignal.emit(_tag, _file)
