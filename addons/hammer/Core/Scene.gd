extends Node3D
class_name Scene

## 场景根节点
var SceneRootNode:SceneRoot

## 场景更变
func SceneChange(_tag:StringName, _file:StringName) -> void:
	SceneRootNode.SceneChange(_tag, _file)

## 玩家节点
@export var PlayerNode:Player
